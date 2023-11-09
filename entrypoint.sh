#!/bin/sh

set -e

echo $PA_PASSWORD > /tmp/pwd.txt

/usr/web_agents/apache24_agent/bin/agentadmin \
  --s "/usr/local/apache2/conf/httpd.conf" \
  "http://sp.siupc.cat:8080/openam" \
  "http://www.siupc.cat:80" "/" "apache_agent" "/tmp/pwd.txt" \
  --acceptLicence \
  --changeOwner

exec "$@"
