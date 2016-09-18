FROM grafana/grafana:latest

MAINTAINER Rachid Zarouali <xinity77@gmail.com>

#copy specific dashboards
COPY dashboard/OpenCloudMonitor /var/lib/grafana/dashboards/
