FROM alpine:latest

RUN apk update && apk add --no-cache ca-certificates emacs git bash

COPY action.sh /action.sh

ENTRYPOINT ["/action.sh"]