#!/bin/bash
docker run \
    -v $PWD/pipeline:/usr/share/logstash/pipeline/ \
    -e XPACK_MONITORING_ENABLED=false \
    -e CONFIG_RELOAD_AUTOMATIC=true \
    -p 8080:8080 \
    elastic/logstash:6.3.2
