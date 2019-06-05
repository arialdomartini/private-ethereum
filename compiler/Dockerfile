FROM ethereum/solc:stable-alpine
RUN apk add jq

COPY sleep.sh /app/
RUN chmod u+x /app/sleep.sh

WORKDIR /src
ENTRYPOINT ["/app/sleep.sh"]

