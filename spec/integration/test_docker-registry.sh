#!/bin/bash
set -e

APP="/docker-registry"
STORAGE="${APP}/storage"
REGISTRY_HOST="127.0.0.1"
REGISTRY_PORT="9292"
REGISTRY_PREFIX="${REGISTRY_HOST}:${REGISTRY_PORT}"
REPOSITORY="test/scratch"


function docker_rmi_all {
  echo "Removing existing Docker images..."
  docker rmi -f $(docker images -q)
}

fuser -k "${REGISTRY_PORT}/tcp" || true

cd "${APP}"
if [ ! -f "config.yml" ]; then
  cp config.yml.sample config.yml
fi
bundle install --jobs 4
bundle exec unicorn -p 9292 &
UNICORN_PID=$!

sleep 3

if [ "$(docker images -q | wc -l)" != 0 ]; then
  docker_rmi_all
fi
echo "Building test image..."
cd "${APP}/spec/fixtures/repositories/test/scratch/" && docker build -t "${REGISTRY_PREFIX}/${REPOSITORY}" .

echo "Pushing to the local repository..."
docker push "${REGISTRY_PREFIX}/${REPOSITORY}"
echo "Removing existing Docker images..."
docker rmi -f $(docker images -q)
echo "Pulling from the local repository"
docker pull "${REGISTRY_PREFIX}/${REPOSITORY}"

docker_rmi_all

# clean-up
kill $UNICORN_PID
rm -rf "${STORAGE}/repositories"
rm -rf "${STORAGE}/images"
