ARG BASEIMAGE=alpine:latest
FROM ${BASEIMAGE}

ARG HUGO_VERSION=0.62.0
ARG OPERATING_SYSTEM=Linux
ARG ARCH=ARM
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL mantainer="Eloy Lopez <elswork@gmail.com>" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name=$BASEIMAGE \
    org.label-schema.description="Hugo for amd64 and arm32v7" \
    org.label-schema.url="https://deft.work" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/DeftWork/rpi-hugo" \
    org.label-schema.vendor="Deft Work" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0"

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
