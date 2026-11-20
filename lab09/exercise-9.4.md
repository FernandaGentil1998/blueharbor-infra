# Exercise 9.4 — Deploy TrackIt on Kubernetes

## Objective

Deploy the BlueHarbor TrackIt application and Redis cache on a local Kubernetes cluster using Kind. Configure Kubernetes Deployments, Services, persistent storage, health probes, and validate scaling, self-healing, rolling updates, and rollback operations.

## 1. Kubernetes Cluster Setup

Created a local Kubernetes cluster using Kind:

```bash
kind create cluster --name blueharbor
```

Verified the cluster connection:

```bash
kubectl cluster-info
kubectl get nodes -o wide
```

The cluster was created successfully, and the control-plane node reached the `Ready` state.

The Kubernetes client version was 1.37.2, and the cluster node was running Kubernetes 1.37.0.

## 2. Prepare the Kubernetes Manifests

Created the Kubernetes configuration directory:

```bash
mkdir -p trackit/k8s
```

Created two manifest files:

- `redis.yaml`: defines the Redis PersistentVolumeClaim, Deployment, and Service.
- `trackit.yaml`: defines the TrackIt Deployment and Service.

The Redis configuration includes:

- A PersistentVolumeClaim requesting 1 GiB of storage.
- A Redis Deployment using `redis:7-alpine`.
- Append-only persistence enabled through Redis.
- A volume mounted at `/data`.
- A ClusterIP Service named `cache` on port 6379.

The TrackIt configuration includes:

- Two application replicas.
- The `trackit:1.1.0` Docker image.
- `imagePullPolicy: Never`, using the image previously loaded into Kind.
- `APP_VERSION=1.1.0`.
- `REDIS_HOST=cache`.
- Liveness and readiness HTTP probes using `/health`.
- A ClusterIP Service exposing port 5000.

Validated both manifests before deployment:

```bash
kubectl apply --dry-run=client -f trackit/k8s/redis.yaml
kubectl apply --dry-run=client -f trackit/k8s/trackit.yaml
```

Both validation commands completed successfully.

## 3. Load Images into Kind

Loaded the TrackIt image into the Kubernetes node:

```bash
kind load docker-image trackit:1.1.0 --name blueharbor
```

The Redis image import initially failed because of a container image content digest error.

Instead of retrying the import, deployed Redis using its public image reference. Kubernetes successfully downloaded the image from Docker Hub.

## 4. Deploy Redis

Applied the Redis manifest:

```bash
kubectl apply -f trackit/k8s/redis.yaml
```

Verified the resources:

```bash
kubectl get pods,pvc,services
```

The results confirmed:

- Redis Pod: `1/1 Running`.
- PersistentVolumeClaim `redis-data`: `Bound`.
- Storage capacity: 1 GiB.
- Redis Service `cache`: ClusterIP on port 6379.

The persistent volume was dynamically provisioned by the cluster's default StorageClass.

## 5. Deploy TrackIt

Applied the application manifest:

```bash
kubectl apply -f trackit/k8s/trackit.yaml
```

Verified the deployment:

```bash
kubectl get pods,deployments,services
```

The application started successfully with two replicas:

- TrackIt Deployment: `2/2` available.
- Both TrackIt Pods: `1/1 Running`.
- TrackIt Service: ClusterIP on port 5000.
- Redis remained operational.

The readiness and liveness probes successfully monitored the application's `/health` endpoint.

## 6. Verify Service Discovery and Connectivity

Inspected the TrackIt Service endpoints:

```bash
kubectl get endpoints trackit
```

Both application Pods were registered as endpoints on port 5000.

Also inspected the modern EndpointSlice resource:

```bash
kubectl get endpointslices -l kubernetes.io/service-name=trackit
```

The EndpointSlice confirmed both application Pod addresses.

Tested Redis DNS resolution and TCP connectivity from a TrackIt Pod:

```bash
kubectl exec deployment/trackit -- python -c "import socket; print(socket.gethostbyname('cache')); print('Redis port:', socket.create_connection(('cache', 6379), timeout=5).getpeername())"
```

The application successfully resolved `cache` to `10.96.78.115` and established a connection to port 6379.

## 7. Application Endpoint Verification

Tested the health endpoint from inside a TrackIt Pod:

```bash
kubectl exec deployment/trackit -- python -c "import urllib.request; print(urllib.request.urlopen('http://localhost:5000/health').read().decode())"
```

Response:

```json
{"status":"ok","version":"1.1.0"}
```

Tested the main application page:

```bash
kubectl exec deployment/trackit -- python -c "import urllib.request; print(urllib.request.urlopen('http://localhost:5000/').read().decode())"
```

The application returned the BlueHarbor TrackIt page, version 1.1.0, and an incrementing visit counter.

Tested the shipments API:

```bash
kubectl exec deployment/trackit -- python -c "import urllib.request; print(urllib.request.urlopen('http://localhost:5000/api/shipments/SH001').read().decode())"
```

Response:

```json
{"hub":"Lille","id":"SH001","source":"static","status":"in transit"}
```

The static response was expected because Supabase credentials were not configured in the Kubernetes Deployment.

## 8. Test Kubernetes Self-Healing

Listed the TrackIt Pods:

```bash
kubectl get pods -l app=trackit
```

Deleted one application Pod to simulate a failure:

```bash
kubectl delete pod trackit-6d45bb85dd-j27qf
```

Checked the Pods again:

```bash
kubectl get pods -l app=trackit
```

Kubernetes automatically created a replacement Pod.

The Deployment maintained the desired number of two replicas, demonstrating its self-healing capability.

## 9. Test Horizontal Scaling

Scaled the TrackIt Deployment from two to three replicas:

```bash
kubectl scale deployment/trackit --replicas=3
```

Verified the result:

```bash
kubectl get deployment trackit
kubectl get pods -l app=trackit
```

The Deployment reported:

```text
READY   UP-TO-DATE   AVAILABLE
3/3     3            3
```

All three Pods reached the `Running` state.

## 10. Perform a Rolling Update

Updated the application version through the Deployment environment variable:

```bash
kubectl set env deployment/trackit APP_VERSION=1.1.1
```

Monitored the rollout:

```bash
kubectl rollout status deployment/trackit
```

Result:

```text
deployment "trackit" successfully rolled out
```

Verified the new application version:

```bash
kubectl exec deployment/trackit -- python -c "import urllib.request; print(urllib.request.urlopen('http://localhost:5000/health').read().decode())"
```

Response:

```json
{"status":"ok","version":"1.1.1"}
```

The update was performed through a Deployment configuration change, triggering Kubernetes to create a new ReplicaSet and gradually replace the existing Pods.

## 11. Perform a Rollback

Reverted the Deployment to its previous revision:

```bash
kubectl rollout undo deployment/trackit
```

Kubernetes successfully restored the previous Deployment revision.

Verified the rollout:

```bash
kubectl rollout status deployment/trackit
kubectl get deployment trackit
```

The Deployment returned to a healthy state with three available replicas.

Verified the restored application version:

```bash
kubectl exec deployment/trackit -- python -c "import urllib.request; print(urllib.request.urlopen('http://localhost:5000/health').read().decode())"
```

Response:

```json
{"status":"ok","version":"1.1.0"}
```

A warning indicated that the rollback did not update the `kubectl.kubernetes.io/last-applied-configuration` annotation. This was resolved by reapplying the original manifest.

## 12. Restore the Original Configuration

Reapplied the original TrackIt manifest:

```bash
kubectl apply -f trackit/k8s/trackit.yaml
```

This restored the declared configuration, including two application replicas and version 1.1.0.

Verified the final cluster state:

```bash
kubectl get deployments,pods
```

Final results:

- Redis Deployment: `1/1` available.
- TrackIt Deployment: `2/2` available.
- Redis Pod: `1/1 Running`.
- Both TrackIt Pods: `1/1 Running`.

## Results

All major Kubernetes deployment and management tests were completed successfully.

The TrackIt application and Redis cache were deployed on Kind. Persistent storage was provisioned, internal DNS and service connectivity were verified, and application endpoints responded correctly.

Kubernetes self-healing was demonstrated by deleting an application Pod and observing its automatic replacement. Horizontal scaling successfully increased the application to three replicas. A rolling update to version 1.1.1 and a rollback to version 1.1.0 were also completed successfully.

The original two-replica configuration was restored at the end of the exercise.

**Key takeaway:** Kubernetes automates container orchestration through Deployments, Services, persistent storage, health probes, self-healing, scaling, and controlled application updates.

The next stage is to continue with the remaining cloud infrastructure exercises.