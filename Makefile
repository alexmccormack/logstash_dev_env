ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
DEV_LS_TAG=elastic/logstash:6.3.2

.PHONY: test
test:
	docker run \
		-v $(ROOT_DIR)/pipeline:/usr/share/logstash/pipeline/ \
		-e XPACK_MONITORING_ENABLED=false \
		-e CONFIG_RELOAD_AUTOMATIC=true \
		-p 8080:8080 \
		${DEV_LS_TAG}
