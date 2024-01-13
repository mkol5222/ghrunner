```shell
. ./.env

docker build --tag runner-image .

docker run \
  --detach \
  --env ORGANIZATION=$GHORG \
  --env ACCESS_TOKEN=$GHPAT \
  --env REPO=$REPO \
  --env OWNER=$OWNER \
  --name runner \
  runner-image

docker logs -ft runner

docker rm runner

docker-compose up -d
docker-compose scale runner=3
docker-compose logs -ft

docker-compose down

docker build --tag runner-image .
docker-compose up -d --force-recreate

  ```

Expects .env similar to:
```shell
GHORG=yourorg
GHPAT=ghp_xyz
REPO=somerepo
OWNER=youruser
```

