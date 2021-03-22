FROM alpine:latest

RUN apk add --no-cache emacs git bash

COPY action.sh /action.sh

ENTRYPOINT ["/action.sh"]