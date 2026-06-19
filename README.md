# VNC Research Container Template

A minimal, reproducible container template for running graphical research
applications through a browser. Built with Python, Tkinter, and noVNC.

This repository is a **template** — click "Use this template" to create your
own repository with the same structure and GitHub Actions workflow.

## What This Is

This template demonstrates how to package a graphical Python application into
a rootless container accessible through a browser via VNC. It is intended as
a starting point for researchers who need a reproducible graphical environment
that runs consistently across machines and on a Kubernetes cluster.

The included application is a simple Tkinter window that displays information
about the container it is running in — hostname, current user, Python version,
OS, and display. Replace it with your own research application.

## What's Inside

- `app/main.py` — example Tkinter application
- `scripts/start.sh` — startup script that brings up the VNC stack
- `Dockerfile` — rootless container definition based on python:3.14-slim
- `.github/workflows/build.yml` — GitHub Actions workflow that builds and
  pushes the image to GHCR automatically on every push to main and on
  version tags
- `k8s/` — Kubernetes manifests for deploying on a cluster

## Reproducing This Environment

The image is available at:

```
ghcr.io/mikethebuddy/example-research-image:1.0.0
```

To pull and run locally with Podman:

```
podman pull ghcr.io/mikethebuddy/example-research-image:1.0.0

podman run --rm \
    -p 6080:6080 \
    -p 5901:5901 \
    ghcr.io/mikethebuddy/example-research-image:1.0.0
```

Then open your browser at:

```
http://localhost:6080/vnc.html
```

The Dockerfile used to build this image is included in this repository. If
the image is ever unavailable it can be rebuilt from the Dockerfile alone:

```
podman build -t example-research-image:1.0.0 .
```

## Deploying on Kubernetes

The `k8s/` directory contains four manifests:

- `namespace.yaml` — creates the `research-example` namespace
- `pod.yaml` — a bare Pod for quick testing with port-forward
- `deployment.yaml` — a Deployment for persistent use
- `service.yaml` — a Service for inter-pod communication

### Required Permissions

The container runs as a non-root user (UID 1000) and is compatible with
Kubernetes Pod Security Standards at the restricted level. The following
security context is applied to all manifests and must be satisfied by your
cluster:

- `runAsNonRoot: true`
- `runAsUser: 1000`
- `allowPrivilegeEscalation: false`
- `capabilities.drop: ["ALL"]`
- `seccompProfile.type: RuntimeDefault`

If your cluster enforces a different Pod Security policy or uses a custom
admission controller, speak to your cluster administrator before deploying.
You will need at minimum permission to create Pods and Namespaces in your
cluster.

### Option 1 — Quick Test with a bare Pod

Apply the namespace and pod manifests:

```
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/pod.yaml
```

Wait for the Pod to be ready:

```
kubectl get pods -n research-example -w
```

Then port-forward directly to the Pod:

```
kubectl port-forward -n research-example pod/vnc-research-example 6080:6080 5901:5901
```

Then open your browser at `http://localhost:6080/vnc.html`.

When done, clean up:

```
kubectl delete -f k8s/pod.yaml
```

### Option 2 — Persistent Deployment

Apply all manifests for a self-healing, persistent deployment:

```
kubectl apply -f k8s/
```

Port-forward to the Deployment:

```
kubectl port-forward -n research-example deployment/vnc-research-example 6080:6080 5901:5901
```

Then open your browser at `http://localhost:6080/vnc.html`.

The Deployment will automatically restart the container if it crashes. To
update to a new image version, update the image tag in `k8s/deployment.yaml`
and apply again:

```
kubectl apply -f k8s/deployment.yaml
```

To tear down the full deployment:

```
kubectl delete -f k8s/
```

## Using This Template

1. Click **Use this template** on GitHub
2. Update `app/main.py` with your own application
3. Update the image name in `.github/workflows/build.yml`
4. Push to main — the workflow builds and pushes your image to GHCR
   automatically
5. Tag a release with `git tag v1.0.0 && git push origin v1.0.0` to publish
   a versioned image

## License

MIT