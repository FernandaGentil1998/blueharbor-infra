# Exercise 9.2 — Compose a Multi-Container Stack

## Objective

Deploy the TrackIt application together with a Redis cache using Docker Compose. Configure persistent storage to preserve Redis data across container restarts and implement an automatic container restart policy.

## 1. Docker Compose Configuration

Created `compose.yaml` to define two services:

- **web:** TrackIt application, built from the local Dockerfile and tagged as `trackit:1.1.0`.
- **cache:** Redis service using the `redis:7-alpine` image.

The configuration includes:

- `APP_VERSION=1.1.0`
- `REDIS_HOST=cache`
- Port mapping `5000:5000`
- `depends_on` to start Redis before the application
- `restart: unless-stopped` for both services
- A named volume, `redis-data`, mounted at `/data` in Redis

The application uses port 5000, so the port mapping was adapted accordingly.

## 2. Start and Verify the Services

Started the stack with:

```bash
docker compose up -d --build
```

Verified the running containers with:

```bash
docker compose ps
```

Both services started successfully:

- `trackit-web-1`
- `trackit-cache-1`

Accessed the application through the forwarded Codespaces port. The application displayed version `1.1.0` and the visit counter.

Refreshed the page several times and confirmed that the visit counter increased with each request.

## 3. Inspect Application Logs

Executed:

```bash
docker compose logs web
```

The logs confirmed that Gunicorn started successfully, listened on `0.0.0.0:5000`, and initialized its worker process without errors.

## 4. Verify Redis Data Persistence

First, accessed the application and observed the visit counter.

Stopped and removed the containers without deleting the volume:

```bash
docker compose down
```

Started the services again:

```bash
docker compose up -d
```

After refreshing the application, the visit counter continued from its previous value (5), confirming that Redis data persisted across container recreation.

## 5. Remove the Persistent Volume

Executed:

```bash
docker compose down -v
```

This removed the containers, network, and named volume `trackit_redis-data`.

Started the services again and accessed the application. The visit counter restarted at 1, confirming that deleting the volume also deleted the stored Redis data.

## 6. Test the Restart Policy

Started the services and checked their status.

An initial manual stop using `docker kill` left the container stopped, as expected for a manually requested stop under the `unless-stopped` policy.

After restarting the service, simulated a process failure from inside the web container:

```bash
docker compose exec web sh -c 'kill -TERM 1'
```

Checked the container status:

```bash
docker compose ps -a
```

The web container was running again, confirming that Docker automatically restarted it after the main process exited.

## Results

All Exercise 9.2 tests were completed successfully.

The multi-container application stack ran with Docker Compose, Redis stored the visit counter, named volumes preserved data across container recreation, and the restart policy recovered the web container after a process failure.

**Key takeaway:** Containers are replaceable, while persistent volumes keep application data independent of container lifecycles. Docker Compose simplifies the deployment and management of multi-container applications.
