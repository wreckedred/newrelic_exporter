Example Deployment
==================

1. ConfigMaps allow you to decouple configuration artifacts from image content to keep containerized applications portable. 
  Modify the configMap `config.yml` with your New Relic application id and name. 
  Create configMap
`kubectl create -f config.yml` 
  Test with `kubectl describe cm newrelic-exporter-config`. The result should look like:
```console
Name:         newrelic-exporter-config
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
config.yml:
----
applications:
  - id: 12345678
    name: GuestBook-Go-NewRelic

Events:  <none>
```

2. Modify `newrelic-exporter.yml` and add your New Relic API key with a valid key 
`command: ["./newrelic_exporter", "--newrelic.api-key=<NEWRELIC_API_KEY>"]` 

Create the newrelic-exporter pod
```console
kubectl create -f newrelic-exporter.yml
```
Verify metrics are both obtained from New Relic and displayed in Prometheus:

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