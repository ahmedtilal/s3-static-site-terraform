#!/bin/sh

set -a
. ./.env
set +a

cat <<EOF
{
  "secret": "$SECRET"
}
EOF