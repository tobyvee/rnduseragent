FROM alpine:latest 

WORKDIR /app

COPY . .

# Update and install dependencies
RUN apk update
RUN apk add --no-cache bash git make jq curl

RUN make build

WORKDIR /app/dist

ENTRYPOINT [ "./latest" ]