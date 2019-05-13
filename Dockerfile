FROM alpine:latest
RUN apk add geth
COPY genesis99.json /app/
COPY start.sh /app/
WORKDIR /app
entrypoint ["/bin/sh"]
