# recommended GNU make >= 3.82
.DEFAULT_GOAL := build

DEV_PROJECT != basename $$PWD
DOCKER_PLATFORM := linux/amd64
DOCKER_TAG := gabidullin

export GOOS:= linux
export GOARCH:= amd64

# export NODE_OPTIONS := --max-old-space-size=12288
export DOCKER_BUILDKIT := 1

C_RED := "\033[0;31m"
C_YELLOW := "\033[0;33m"
C_NC := "\033[0m"


run: update-modules
	npm run start

update-modules:
	npm ci --prefer-offline

build: 
	npm run build

build-dev: 
	npm run build:dev

docker-build:
	docker buildx build --platform=${DOCKER_PLATFORM} -t ildar2393/${DEV_PROJECT}:${DOCKER_TAG} .

docker-push:
	docker push ildar2393/${DEV_PROJECT}:${DOCKER_TAG}

docker: docker-build docker-push

publish: build docker
publish-dev: build-dev docker

push: publish
push-dev: publish-dev

update-pod:
	kubectl patch deployment ${DEV_PROJECT} -p '{"spec":{"template":{"spec":{"containers":[{"name":"${DEV_PROJECT}","image":"ildar2393/${DEV_PROJECT}:${DOCKER_TAG}"}]}}}}'
	kubectl delete pod --selector app=${DEV_PROJECT}

recreate: publish update-pod

recreate-dev: publish-dev update-pod


