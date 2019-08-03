# newrelic_exporter

Exports New Relic applications metrics data as prometheus metrics.

### Configuration

You must add New Relic applications that you want to export metrics in the `config.yml` file:
```yaml
applications:
  - id: 12345678            #New Relic application ID
    name: My Application    #New Relic application name
```

### Running

```console
./newrelic_exporter --newrelic.api-key=${NEWRELIC_API_KEY} --config=config.yml
```

Or with docker:

```console
docker run -p 9112:9112 -v /path/to/my/config.yml:/config.yml -e "NEWRELIC_API_KEY=${NEWRELIC_API_KEY}" /path/to/newrelic_exporter
```

Or with Kubernetes:

Note: Build and push your own docker image
```console
sudo docker build . -t <DOCKER-USERNAME>/newrelic-exporter:0.0.3
sudo tag <TAG> <DOCKER-USERNAME>/newrelic-exporter:0.0.3
sudo docker tag <TAG> <DOCKER-USERNAME>/newrelic-exporter:0.0.3
sudo docker login --username=<DOCKER-USERNAME>
sudo docker push <DOCKER-USERNAME>/newrelic-exporter:0.0.3
```

```console
kubectl create -f deploy/manifests/newrelic-exporter.yml
```
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: newrelic-exporter
  namespace: default
  annotations:
    prometheus.io/scrape: 'true'
    prometheus.io/port: '9112'
spec:
  containers:
  - name: newrelic-exporter
    image: <DOCKER-USERNAME>/newrelic-exporter:0.0.3
    command: ["./newrelic_exporter", "--newrelic.api-key=<NEWRELIC_API_KEY>"]
    ports:
    - containerPort: 9112
```
Verify connectivity and metrics:

```console
curl http://<POD-IPADDRESS>:9112/metrics | grep newrelic
# TYPE newrelic_app_summary_apdex_score gauge
newrelic_app_summary_apdex_score{app="GuestBook-Go-NewRelic"} 0.88
# HELP newrelic_app_summary_error_rate Application rolling three-to-four-minute average for error rate
# TYPE newrelic_app_summary_error_rate gauge
newrelic_app_summary_error_rate{app="GuestBook-Go-NewRelic"} 0
# HELP newrelic_app_summary_response_time Application rolling three-to-four-minute average for response time
# TYPE newrelic_app_summary_response_time gauge
newrelic_app_summary_response_time{app="GuestBook-Go-NewRelic"} 4.18
# HELP newrelic_app_summary_throughput Application rolling three-to-four-minute average for throughput
# TYPE newrelic_app_summary_throughput gauge
newrelic_app_summary_throughput{app="GuestBook-Go-NewRelic"} 30
# HELP newrelic_instance_summary_apdex_score Application instance rolling three-to-four-minute average for apdex score
# TYPE newrelic_instance_summary_apdex_score gauge
newrelic_instance_summary_apdex_score{app="GuestBook-Go-NewRelic",instance="guestbook-2j6jk"} 0.82
newrelic_instance_summary_apdex_score{app="GuestBook-Go-NewRelic",instance="guestbook-5ztxl"} 0.8
newrelic_instance_summary_apdex_score{app="GuestBook-Go-NewRelic",instance="guestbook-fgmfg"} 0.88
# HELP newrelic_instance_summary_error_rate Application instance rolling three-to-four-minute average for error rate
# TYPE newrelic_instance_summary_error_rate gauge
newrelic_instance_summary_error_rate{app="GuestBook-Go-NewRelic",instance="guestbook-2j6jk"} 0
newrelic_instance_summary_error_rate{app="GuestBook-Go-NewRelic",instance="guestbook-5ztxl"} 0
newrelic_instance_summary_error_rate{app="GuestBook-Go-NewRelic",instance="guestbook-fgmfg"} 0
# HELP newrelic_instance_summary_response_time Application instance rolling three-to-four-minute average for response time
# TYPE newrelic_instance_summary_response_time gauge
newrelic_instance_summary_response_time{app="GuestBook-Go-NewRelic",instance="guestbook-2j6jk"} 3.66
newrelic_instance_summary_response_time{app="GuestBook-Go-NewRelic",instance="guestbook-5ztxl"} 3.43
newrelic_instance_summary_response_time{app="GuestBook-Go-NewRelic",instance="guestbook-fgmfg"} 4.35
# HELP newrelic_instance_summary_throughput Application instance rolling three-to-four-minute average for throughput
# TYPE newrelic_instance_summary_throughput gauge
newrelic_instance_summary_throughput{app="GuestBook-Go-NewRelic",instance="guestbook-2j6jk"} 0.367
newrelic_instance_summary_throughput{app="GuestBook-Go-NewRelic",instance="guestbook-5ztxl"} 0.167
newrelic_instance_summary_throughput{app="GuestBook-Go-NewRelic",instance="guestbook-fgmfg"} 30
# HELP newrelic_scrape_duration_seconds Time NewRelic scrape took in seconds
# TYPE newrelic_scrape_duration_seconds gauge
newrelic_scrape_duration_seconds 1.120504594
# HELP newrelic_up NewRelic API is up and accepting requests
# TYPE newrelic_up gauge
newrelic_up 1
```

### Flags

Name               | Description
-------------------|--------------------------------------------------------------------------
web.listen-address | Address to listen on for web interface and telemetry (default `:9112`)
web.telemetry-path | Path under which to expose metrics (default `/metrics`)
newrelic.api-key   | Your New Relic API key (required)
config             | Your configuration file path (default `config.yml`)
