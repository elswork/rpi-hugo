# Hugo

A [Docker](http://docker.com) file to build [Hugo](https://gohugo.io), one of the most popular open-source static site generators for AMD & ARM devices over an alpine base image based.

> Be aware! You should read carefully the usage documentation of [Hugo](https://gohugo.io)!

## Details

- [GitHub](https://github.com/DeftWork/rpi-hugo)
- [Deft.Work my personal blog](https://deft.work)

| Docker Hub | Docker Pulls | Docker Stars | Docker Build | Size/Layers |
| --- | --- | --- | --- | --- |
| [rpi-hugo](https://hub.docker.com/r/elswork/rpi-hugo "elswork/rpi-hugo on Docker Hub") | [![](https://img.shields.io/docker/pulls/elswork/rpi-hugo.svg)](https://hub.docker.com/r/elswork/rpi-hugo "rpi-hugo on Docker Hub") | [![](https://img.shields.io/docker/stars/elswork/rpi-hugo.svg)](https://hub.docker.com/r/elswork/rpi-hugo "rpi-hugo on Docker Hub") | [![](https://img.shields.io/docker/build/elswork/rpi-hugo.svg)](https://hub.docker.com/r/elswork/rpi-hugo "rpi-hugo on Docker Hub") | [![](https://images.microbadger.com/badges/image/elswork/rpi-hugo.svg)](https://microbadger.com/images/elswork/rpi-hugo "rpi-hugo on microbadger.com") |

## Build Instructions

Build for amd64 architecture

```bash
docker build -t elswork/rpi-hugo:amd64 .
```

Build for armv7l architecture

```bash
docker build -t elswork/rpi-hugo:armv7l .
```

## Usage Example

In order everyone could take full advantages of the usage of this docker container, .I'll describe my own real usage setup.
This guide asumes that you already have [created a site](https://gohugo.io/getting-started/quick-start/#step-2-create-a-new-site), [added a theme](https://gohugo.io/getting-started/quick-start/#step-3-add-a-theme) and [added some content](https://gohugo.io/getting-started/quick-start/#step-4-add-some-content).

### Build Site

```bash
docker run --rm -v /path/to/site:/src --name HugoBuild elswork/rpi-hugo --cleanDestinationDir
```

### Testing/Serving

```bash
docker run -p 1313:1313 -v /path/to/site:/src elswork/rpi-hugo server -b http://HostName.Or.IP/ --bind=0.0.0.0 -w
```