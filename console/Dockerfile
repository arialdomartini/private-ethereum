FROM alpine:latest
RUN apk add geth
COPY genesis99.json /app/
COPY console.sh /app/
RUN chmod u+x /app/console.sh
COPY sleep.sh /app/
RUN chmod u+x /app/sleep.sh
WORKDIR /app
ENTRYPOINT ["/app/sleep.sh"]
