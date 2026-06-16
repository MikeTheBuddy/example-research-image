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
about the container it is running in. Replace it with your own research
application.

## What's Inside

- `app/main.py` — example Tkinter application
- `scripts/start.sh` — startup script that brings up the VNC stack
- `Dockerfile` — rootless container definition based on python:3.14-slim
- `.github/workflows/build.yml` — GitHub Actions workflow that builds and
  pushes the image to GHCR automatically on every push to main and on
  version tags

## Reproducing This Environment

The image is available at:

```
ghcr.io/mikethebuddy/example-research-image:latest
```

To pull and run locally with Podman:

```
podman pull ghcr.io/mikethebuddy/example-research-image:latest

podman run --rm \
    -p 6080:6080 \
    -p 5901:5901 \
    ghcr.io/mikethebuddy/example-research-image:latest
```

Then open your browser at:

```
http://localhost:6080/vnc.html
```

The Dockerfile used to build this image is included in this repository. If
the image is ever unavailable it can be rebuilt from the Dockerfile alone:

```
podman build -t vnc-research-example:v1.0 .
```

## Deploying on Kubernetes

Apply the included manifests to deploy on a Kubernetes cluster:

```
kubectl apply -f k8s/
```

The manifests assume a namespace called `your-namespace`. Update this to
match your own before applying.

## Using This Template

1. Click **Use this template** on GitHub
2. Update `app/main.py` with your own application
3. Update the image name in `.github/workflows/build.yml`
4. Push to main — the workflow builds and pushes your image to GHCR
   automatically
5. Tag a release with `git tag v1.0 && git push origin v1.0` to publish
   a versioned image

## License

MIT