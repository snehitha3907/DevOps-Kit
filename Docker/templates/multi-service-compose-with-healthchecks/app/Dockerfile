# last_verified: 2026-09-29 · Docker (n/a)
# Minimal runtime image for the scaffold's app service: stdlib-only HTTP server,
# runs as a non-root user, exposes the port the compose healthcheck probes.
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN useradd --create-home --uid 10001 appuser
WORKDIR /home/appuser

COPY app.py ./app.py
RUN chmod 444 ./app.py

USER 10001:10001

EXPOSE 8000

CMD ["python", "app.py"]
