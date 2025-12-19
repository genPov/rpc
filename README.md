# 빌드/실행 방법

#### 1단계
```bash
export DOCKERHUB_USER=catcert
export IMAGE_TAG=latest
```

#### 2단계
```bash
docker compose pull
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
