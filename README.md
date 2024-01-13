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
  ```

