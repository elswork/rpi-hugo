SNAME ?= rpi-hugo
RNAME ?= elswork/$(SNAME)
VER ?= `cat VERSION`
BASE ?= latest
BASENAME ?= alpine:$(BASE)
#RUTA ?= /home/pirate/docker/hugosample
RUTA ?= /home/pirate/docker/www
#SITE ?= test
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

# New build way

bootstrap: ## Start multicompiler
	docker buildx inspect --bootstrap
buildx: ## Buildx the container
	docker buildx build \
	--platform linux/amd64,linux/arm64,linux/ppc64le,linux/s390x,linux/386,linux/arm/v7,linux/arm/v6 \
  	-t $(RNAME):latest -t $(RNAME):$(VER) --push \
	--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	--build-arg VCS_REF=`git rev-parse --short HEAD` \
	--build-arg BASEIMAGE=$(BASENAME) \
	--build-arg VERSION=$(VER) .

# Old build way

debug: ## Debug the container
	docker build -t $(RNAME):$(GOARCH) \
	--build-arg BASEIMAGE=$(BASENAME) \
	--build-arg VERSION=$(GOARCH)_$(VER) \
	--build-arg HUGO_VERSION=$(VER) .
build: ## Build the container
	docker build --no-cache -t $(RNAME):$(GOARCH) \
	--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	--build-arg VCS_REF=`git rev-parse --short HEAD` \
	--build-arg BASEIMAGE=$(BASENAME) \
	--build-arg ARCH=$(ARCHITECTURE) \
	--build-arg HUGO_VERSION=$(VER) \
	--build-arg VERSION=$(GOARCH)_$(VER) \
	. > builds/$(GOARCH)_$(VER)_`date +"%Y%m%d_%H%M%S"`.txt
tag: ## Tag the container
	docker tag $(RNAME):$(GOARCH) $(RNAME):$(GOARCH)_$(VER)
push: ## Push the container
	docker push $(RNAME):$(GOARCH)_$(VER)
	docker push $(RNAME):$(GOARCH)	
deploy: build tag push
manifest: ## Create an push manifest
	docker manifest create $(RNAME):$(VER) \
	$(RNAME):$(GOARCH)_$(VER) \
	$(RNAME):$(ARCH2)_$(VER) \
	$(RNAME):$(ARCH3)_$(VER)
	docker manifest push --purge $(RNAME):$(VER)
	docker manifest create $(RNAME):latest $(RNAME):$(GOARCH) \
	$(RNAME):$(ARCH2) \
	$(RNAME):$(ARCH3)
	docker manifest push --purge $(RNAME):latest

# Operations

console: ## Open console
	docker run -it --rm --entrypoint "/bin/ash" $(RNAME):$(VER)
newsite: ## Generate a site
	docker run --rm -v $(RUTA):$(TO) $(RNAME):$(VER) new site $(SITE)
generate: ## Build a site
	docker run --rm -v $(RUTA)/$(SITE):$(TO) $(RNAME):$(VER) --cleanDestinationDir
serve: ## Test Serving
	docker run --rm -p 1313:1313 -v $(RUTA)/$(SITE):$(TO) $(RNAME):$(VER) server -b http://deft.work --bind=0.0.0.0 -w
post:
	docker run --rm -v $(RUTA)/$(SITE):$(TO) $(RNAME):$(VER) new post/2099-12-31-nuevo-articulo/index.md
theme:
	docker run --rm -v $(RUTA)/$(SITE):$(TO) $(RNAME):$(VER) new theme anticitera
version:
	docker run --rm -v $(RUTA)/$(SITE):$(TO) $(RNAME):$(VER) version
