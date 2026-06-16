FROM python:3.14-slim

RUN apt-get update && apt-get install -y \
    x11vnc \
    xvfb \
    fluxbox \
    novnc \
    websockify \
    python3-tk \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 1000 researcher

WORKDIR /app
RUN chown -R researcher:researcher /app

ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NOVNC_PORT=6080 \
    RESOLUTION=1920x1080x24 \
    HOME=/home/researcher

COPY --chown=researcher:researcher app/ ./app/
COPY --chown=researcher:researcher scripts/start.sh ./start.sh

RUN chmod 755 ./start.sh

USER researcher

EXPOSE 5901 6080

CMD ["./start.sh"]