FROM python:3.11-slim

# Avoid Python buffering + reduce noise
ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

# System deps (matplotlib can need basic font/render libs in slim images)
RUN apt-get update && apt-get install -y --no-install-recommends \
    fonts-dejavu-core \
    && rm -rf /var/lib/apt/lists/*

# Install Python deps
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy notebook (rename your notebook to app.ipynb in the repo)
COPY app.ipynb .

# Render provides $PORT at runtime. Expose is optional but harmless.
EXPOSE 8080

# Start Voila (widgets enabled), listen on all interfaces
#CMD ["sh", "-c", "voila app.ipynb --no-browser --ip=0.0.0.0 --port=${PORT:-8080} --Voila.enable_nbextensions=True"]
CMD ["sh", "-c", "voila app.ipynb --no-browser --Voila.ip=0.0.0.0 --Voila.port=${PORT:-8080}"]


