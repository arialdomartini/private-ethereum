docker run \
       --rm \
       --name solc \
       -ti \
       -v $(pwd):/src \
       --workdir /src \
       --entrypoint sh \
       ethereum/solc:stable-alpine
