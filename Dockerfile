ARG BASEIMAGE=alpine:3.15
FROM ${BASEIMAGE}

ARG OPERATING_SYSTEM=Linux
ARG ARCH=ARM
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG HUGO_VERSION=$VERSION

LABEL mantainer="Eloy Lopez <elswork@gmail.com>" \
    org.opencontainers.image.title="Hugo" \
    org.opencontainers.image.description="Multiarch Hugo Docker container" \
    org.opencontainers.image.vendor=Deft.Work \
    org.opencontainers.image.url=https://deft.work/hugo \
    org.opencontainers.image.source=https://github.com/DeftWork/rpi-hugo \
    org.opencontainers.image.version=$VERSION \ 
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.licenses=MIT

ADD https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_${OPERATING_SYSTEM}-${ARCH}.tar.gz /tmp
RUN tar -xf /tmp/hugo_${HUGO_VERSION}_${OPERATING_SYSTEM}-${ARCH}.tar.gz -C /tmp \
    && mkdir -p /usr/local/sbin \
    && mv /tmp/hugo /usr/local/sbin/hugo \
    && rm -rf /tmp/hugo_${HUGO_VERSION}_${OPERATING_SYSTEM}-${ARCH}

VOLUME /src
VOLUME /output

WORKDIR /src

ENTRYPOINT ["hugo"]

EXPOSE 1313
