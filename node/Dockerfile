FROM alpine:latest
RUN apk add geth

COPY genesis99.json /app/
COPY start.sh /app/

RUN chmod u+x /app/start.sh
WORKDIR /app
