# ---------- Stage 1 ----------
FROM python:3.10-slim AS builder

RUN apt-get update && apt-get install -y \
    gcc \
    default-libmysqlclient-dev \
    pkg-config

WORKDIR /app

COPY requirements.txt .

RUN pip install --prefix=/install \
    --no-cache-dir \
    -r requirements.txt


# ---------- Stage 2 ----------
FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /install /usr/local

COPY . .

WORKDIR /app/fundoo

EXPOSE 8000

CMD ["python3","manage.py","runserver","0.0.0.0:8000"]
