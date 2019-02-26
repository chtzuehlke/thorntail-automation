#!/bin/bash

SERVICE=$1
EXPECTED_VERSION=$2

VERSION=$(./ecs_task_definition_version.sh $SERVICE)
while [ $VERSION -ne "$EXPECTED_VERSION" ]; do
  echo "$SERVICE has version $VERSION. Expected: $EXPECTED_VERSION. Sleeping 30s"
  sleep 30
  VERSION=$(./ecs_task_definition_version.sh $SERVICE)
done
