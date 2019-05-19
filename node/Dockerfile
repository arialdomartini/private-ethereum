FROM alpine:latest
RUN apk add geth

RUN mkdir -p /app/network99/ethash
RUN ln -s /app/network99/ethash root/.ethash

COPY genesis99.json /app/
COPY start.sh /app/

RUN chmod u+x /app/start.sh
WORKDIR /app
