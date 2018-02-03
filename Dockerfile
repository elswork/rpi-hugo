FROM alpine
LABEL mantainer="Eloy Lopez <elswork@gmail.com>"

ENV HUGO_VERSION=0.34
ENV OPERATING_SYSTEM=Linux
ENV ARCH=ARM
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
