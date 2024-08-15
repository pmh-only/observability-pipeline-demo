FROM alpine

RUN apk add go

COPY main.go /main.go

RUN CGO_ENABLED=0 GOOS=linux go build -o main /main.go

FROM scratch

COPY --from=0 /main /main

ENTRYPOINT [ "/main" ]
