SNAME ?= rpi-hugo
NAME ?= elswork/$(SNAME)
VER ?= `cat VERSION`
BASE ?= latest
BASENAME ?= alpine:$(BASE)
RUTA ?= /home/pirate/docker/www
SITE ?= elswork.github.io
TO ?= /src
ARCH2 ?= armv7l
ARCH3 ?= aarch64
GOARCH := $(shell uname -m)
ifeq ($(GOARCH),x86_64)
	GOARCH := amd64
	ARCHITECTURE := 64bit
endif
ifeq ($(GOARCH),aarch64)
	ARCHITECTURE := ARM64
endif
ifeq ($(GOARCH),armv7l)
	ARCHITECTURE := ARM
endif

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# DOCKER TASKS
# Build the container

debug: ## Build the container
	docker build -t $(NAME):$(GOARCH) \
	--build-arg BASEIMAGE=$(BASENAME) \
	--build-arg VERSION=$(SNAME)_$(GOARCH)_$(VER) .
build: ## Build the container
	docker build --no-cache -t $(NAME):$(GOARCH) \
	--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	--build-arg VCS_REF=`git rev-parse --short HEAD` \
	--build-arg BASEIMAGE=$(BASENAME) \
	--build-arg ARCH=$(ARCHITECTURE) \
	--build-arg HUGO_VERSION=$(VER) \
	--build-arg VERSION=$(GOARCH)_$(VER) \
	. > ../builds/$(SNAME)_$(GOARCH)_$(VER)_`date +"%Y%m%d_%H%M%S"`.txt
tag: ## Tag the container
	docker tag $(NAME):$(GOARCH) $(NAME):$(GOARCH)_$(VER)
push: ## Push the container
	docker push $(NAME):$(GOARCH)_$(VER)
	docker push $(NAME):$(GOARCH)	
deploy: build tag push
manifest: ## Create an push manifest
	docker manifest create $(NAME):$(VER) \
	$(NAME):$(GOARCH)_$(VER) \
	$(NAME):$(ARCH2)_$(VER) \
	$(NAME):$(ARCH3)_$(VER)
	docker manifest push --purge $(NAME):$(VER)
	docker manifest create $(NAME):latest $(NAME):$(GOARCH) \
	$(NAME):$(ARCH2) \
	$(NAME):$(ARCH3)
	docker manifest push --purge $(NAME):latest
newsite: ## Generate a site
	docker run --rm -v $(RUTA):$(TO) $(NAME):$(GOARCH) new site $(SITE)
generate: ## Build a site
	docker run --rm -v $(RUTA)/$(SITE):$(TO) $(NAME):$(GOARCH) --cleanDestinationDir
serve: ## Test Serving
	docker run --rm -p 1313:1313 -v $(RUTA)/$(SITE):$(TO) $(NAME):$(GOARCH) server -b http://deft.work --bind=0.0.0.0 -w
post:
	docker run --rm -v $(RUTA)/$(SITE):$(TO) $(NAME):$(GOARCH) new blog/2099-12-31-nuevo-articulo/index.md
up:
	docker-compose -f $(RUTA)/$(SITE)/docker-compose.yml up -d