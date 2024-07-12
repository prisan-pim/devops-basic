FROM golang:alpine
ENV CGO_ENABLED=0
ENV GO111MODULE=on
WORKDIR $GOPATH/src/payment-service

COPY . .

RUN go mod download

RUN go build

ENTRYPOINT ["/go/src/payment-service/payment-service"]