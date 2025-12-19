# 빌드/실행 방법 (Docker Hub 이미지 Pull)

#### 1단계
```bash
export DOCKERHUB_USER=catcert
export IMAGE_TAG=latest
export RPC_ROOT="$(pwd)"
export SERVER_IP=34.64.143.22
```

#### 2단계 (한 번에 Pull)
```bash
docker compose pull
```

#### 2단계 (서버가 힘들면 서비스별 Pull)
```bash
for s in mongodb webui run gnb ue strapi frontend mailhog; do
  docker compose pull --policy missing -q "$s" || exit 1
done
```

#### 3단계
```bash
docker compose up -d mongodb webui run gnb ue strapi frontend mailhog
```

#### 4단계
```bash
docker compose ps
```

###### Docker 버전에 따라 `docker compose`/`docker-compose` 명령이 다를 수 있습니다.
