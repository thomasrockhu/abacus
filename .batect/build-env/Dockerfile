FROM golang:1.15.2-buster

ARG GOLANGCI_LINT_VERSION=1.30.0

RUN cd /usr/local/bin && curl --fail --location --show-error https://github.com/golangci/golangci-lint/releases/download/v$GOLANGCI_LINT_VERSION/golangci-lint-$GOLANGCI_LINT_VERSION-linux-amd64.tar.gz | tar --strip-components=1 --wildcards -xzf - */golangci-lint
