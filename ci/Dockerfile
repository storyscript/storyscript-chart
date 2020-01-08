FROM        quay.io/helmpack/chart-releaser:v0.2.3 AS cr
FROM        alpine/helm:3.0.2
COPY        --from=cr /usr/local/bin/cr /usr/local/bin/
RUN         apk add --update git
ENTRYPOINT  /bin/sh
