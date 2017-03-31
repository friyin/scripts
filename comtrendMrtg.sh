#!/bin/sh


ROUTER_IP="$1"
IFACE="$2"
SESSION_KEY="$3"

if [ -z "${ROUTER_IP}" -o -z "${IFACE}" -o -z "${SESSION_KEY}" ]; then
  echo Usage: $0 ip iface session_key
  echo $0 192.168.1.1 ppp0.1 session_key
  exit 1;
fi

COOKIE=`http -hf POST "http://${ROUTER_IP}/login-login.cgi" sessionKey="${SESSION_KEY}" pass="" |grep -i set-cookie|cut -d":" -f2|cut -c'2-'|tr -d '\r'`
DATA_TRAFFIC=`http GET "http://${ROUTER_IP}/statswan.cmd" Cookie:"${COOKIE}"`
DATA_INFO=`http GET "http://${ROUTER_IP}/info.html" Cookie:"${COOKIE}"`

echo "${DATA_TRAFFIC}" | grep -A2 "${IFACE}" | tail -n1 | cut -d">" -f2 | cut -d"<" -f1
echo "${DATA_TRAFFIC}" | grep -A10 "${IFACE}" | tail -n1 | cut -d">" -f2 | cut -d"<" -f1
echo "${DATA_INFO}" | grep -A1 "Uptime" | tail -n1 | cut -d">" -f2 | cut -d"<" -f1
echo "Router"
