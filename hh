#! /bin/sh

podman run --tty --interactive \
  -v"$(pwd)":/app \
  -v"/app/.git" \
  --workdir /app \
  hhvm/hhvm:latest bash -c 'hh_client; bash'
