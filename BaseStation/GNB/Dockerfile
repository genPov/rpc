# syntax=docker/dockerfile:1.4
FROM ubuntu:20.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates curl gnupg && \
    mkdir -p /usr/share/keyrings && \
    curl -fsSL https://apt.kitware.com/keys/kitware-archive-latest.asc | \
      gpg --dearmor -o /usr/share/keyrings/kitware-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main" \
      > /etc/apt/sources.list.d/kitware.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      build-essential cmake ninja-build ccache libsctp-dev lksctp-tools iproute2 net-tools && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

RUN chmod +x /app/announcer.sh || true

RUN --mount=type=cache,target=/root/.ccache \
    cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_C_COMPILER_LAUNCHER=ccache \
      -DCMAKE_CXX_COMPILER_LAUNCHER=ccache && \
    cmake --build build --parallel

# Run announcer in background then start gNB
CMD ["/bin/bash","-lc","/app/announcer.sh & exec /app/build/nr-gnb -c /app/config/open5gs-gnb.yaml"]
