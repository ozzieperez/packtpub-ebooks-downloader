FROM python:2-alpine

ENV TZ=Europe/London

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.build-date="unknown" \
      org.label-schema.version="unknown" \
      org.label-schema.name="packtpub-library-downloader" \
      org.label-schema.description="python alpine container with latest packtpub library downloader." \
      maintainer="2951486+adam-moss@users.noreply.github.com"

HEALTHCHECK CMD [ "exit 0" ]

COPY downloader.py /opt/packtpub-library-downloader/

RUN apk add --no-cache tzdata=2016d-r0 \
                       py-requests=2.9.1-r0 \
                       py-lxml=3.6.0-r0 && \
    ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && \
    echo "$TZ" > /etc/timezone && \
    chmod +x /opt/packtpub-library-downloader/downloader.py

ENV PATH=$PATH:/opt/packtpub-library-downloader

RUN addgroup -g 1000 -S packtpub-library-downloader && \
    adduser -u 1000 -S packtpub-library-downloader -G packtpub-library-downloader

USER packtpub-library-downloader

ENTRYPOINT [ "downloader.py" ]
CMD [ "--help" ]
