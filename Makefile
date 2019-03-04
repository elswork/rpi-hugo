SNAME ?= rpi-hugo
NAME ?= elswork/$(SNAME)
BASENAME ?= alpine
GOARCH ?= armv7l
#GOARCH ?= amd64
ARCHITECTURE ?= ARM
#ARCHITECTURE ?= 64bit
ARCH2 ?= armv7l
VER ?= `cat VERSION`

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# DOCKER TASKS
# Build the container

build: ## Build the container
	docker build --no-cache -t $(NAME):$(GOARCH) --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	--build-arg VCS_REF=`git rev-parse --short HEAD` \
	--build-arg BASEIMAGE=$(BASENAME) \
	--build-arg ARCH=$(ARCHITECTURE) \
	--build-arg HUGO_VERSION=$(VER) \
	--build-arg VERSION=$(SNAME)_$(GOARCH)_$(VER) . > ../builds/$(SNAME)_$(GOARCH)_$(VER)_`date +"%Y%m%d_%H%M%S"`.txt
tag: ## Tag the container
	docker tag $(NAME):$(GOARCH) $(NAME):$(GOARCH)_$(VER)
push: ## Push the container
	docker push $(NAME):$(GOARCH)_$(VER)
	docker push $(NAME):$(GOARCH)	
deploy: build tag push
manifest: ## Create an push manifest
	docker manifest create $(NAME):$(VER) $(NAME):$(GOARCH)_$(VER) $(NAME):$(ARCH2)_$(VER)
	docker manifest push --purge $(NAME):$(VER)
	docker manifest create $(NAME):latest $(NAME):$(GOARCH) $(NAME):$(ARCH2)
	docker manifest push --purge $(NAME):latest
generate: ## Generate a site
	docker run --rm -v /home/pirate/docker/Hugo/Sites/deft.work:/src --name HugoBuild $(NAME):$(GOARCH) --cleanDestinationDir
serve: ## Test Serving
	docker run -p 1313:1313 -v /home/pirate/docker/Hugo/Sites/deft.work:/src $(NAME):$(GOARCH) server -b http://deft.work/ --bind=0.0.0.0 -w