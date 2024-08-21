FROM alpine

RUN apk --no-cache add nodejs npm

RUN adduser -D -u 1000 app

WORKDIR /app

RUN chown 1000:1000 /app

USER 1000:1000

COPY --chown=1000:1000 ./package-lock.json ./package.json ./

RUN npm i

COPY ./main.js ./

ENTRYPOINT [ "/usr/bin/node" ]
CMD [ "/app/main.js" ]
