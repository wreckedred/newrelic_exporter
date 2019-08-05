####################################
# NewRelic K8s Prometheus Exporter #
####################################
FROM alpine:3.10 as alpine

RUN apk add -U --no-cache ca-certificates

FROM scratch
ENTRYPOINT []
EXPOSE 9112
WORKDIR /
COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY newrelic_exporter .
#COPY config.yml . #Needed for non K8s deployments
ENTRYPOINT ["./newrelic_exporter"]
