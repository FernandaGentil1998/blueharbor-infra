# Exercise 9.1 — Containerise TrackIt

## Objective

Containerise the BlueHarbor TrackIt application using Docker, build a lightweight image, and configure the container to run as a non-root user.

## 1. Application Requirements

The TrackIt application uses:

- Python 3.12
- Flask
- Gunicorn as the production WSGI server

Dependencies are defined in `requirements.txt`.

## 2. Dockerfile

Created a Dockerfile using the lightweight `python:3.12-slim` base image.

The configuration includes:

- Disabled Python bytecode generation.
- Enabled unbuffered Python output for container logs.
- Installed application dependencies.
- Created a dedicated user named `appuser` (UID 10001).
- Copied the application code with the correct ownership.
- Configured the container to run as a non-root user.
- Exposed port 5000.
- Started the application using Gunicorn.

```dockerfile
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt \
    && useradd --create-home --uid 10001 appuser

COPY --chown=appuser:appuser app.py .

USER appuser

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
```

## 3. Build the Docker Image

Built the application image with the following command:

```bash
docker build -t trackit:1.0.1 .
```

The build completed successfully.

The resulting image was approximately 196 MB in disk usage, with a reported content size of 47.2 MB.

## 4. Non-Root User Verification

Verified the configured container user:

```bash
docker run --rm --entrypoint id trackit:1.0.1
```

Result:

```text
uid=10001(appuser) gid=10001(appuser) groups=10001(appuser)
```

This confirms that the application runs under a dedicated non-root user rather than the root account, following the principle of least privilege.

## 5. Container Execution

Started the application container:

```bash
docker run -d --name trackit-test -p 5000:5000 trackit:1.0.1
```

The container started successfully and returned a container ID.

Accessed the application at port 5000 and confirmed that it responded with:

```text
BlueHarbor TrackIt
Version 1.0.1 served by <container-id> - visits: n/a
```

The `visits: n/a` value is expected because Redis is not configured in this exercise.

## 6. Health Check Verification

Tested the application's health endpoint:

```bash
curl -i http://localhost:5000/health
```

Response:

```http
HTTP/1.1 200 OK
Server: gunicorn
Content-Type: application/json

{"status":"ok","version":"1.0.1"}
```

The HTTP 200 response confirms that the application is running and responding successfully.

## 7. Container Logs

Inspected the container logs:

```bash
docker logs trackit-test
```

Gunicorn started successfully, listening on `0.0.0.0:5000` and running a synchronous worker.

## 8. Cleanup

Stopped and removed the test container:

```bash
docker stop trackit-test
docker rm trackit-test
```

The Docker image remains available locally and can be used to create new containers.

## Conclusion

Exercise 9.1 successfully containerised the BlueHarbor TrackIt application.

The Docker image was built and tested successfully. The application ran as a non-root user, Gunicorn started correctly, and the health endpoint returned HTTP 200.

The application is now ready for the next stage: building a multi-container environment with Docker Compose and Redis.
