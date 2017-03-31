#!/bin/bash


ROUTER_IP="$1"
IFACE="$2"
SESSION_KEY="$3"

if [ -z "${ROUTER_IP}" -o -z "${IFACE}" -o -z "${SESSION_KEY}" ]; then
  echo Usage: $0 ip iface session_key
  echo $0 192.168.1.1 ppp0.1 session_key
  exit 1;
fi

COOKIE=`/usr/bin/http -hf --ignore-stdin POST "http://${ROUTER_IP}/login-login.cgi" sessionKey="${SESSION_KEY}" pass="." |grep -i set-cookie|cut -d":" -f2|cut -c'2-'|tr -d '\r'`
DATA_TRAFFIC=`/usr/bin/http --ignore-stdin GET "http://${ROUTER_IP}/statswan.cmd" Cookie:"${COOKIE}"`
DATA_INFO=`/usr/bin/http --ignore-stdin GET "http://${ROUTER_IP}/info.html" Cookie:"${COOKIE}"`
/usr/bin/http --ignore-stdin GET http://${ROUTER_IP}/logout.cmd Cookie:"${COOKIE}" >/dev/null

/bin/echo "${DATA_TRAFFIC}" | grep -A2 "${IFACE}" | tail -n1 | cut -d">" -f2 | cut -d"<" -f1
/bin/echo "${DATA_TRAFFIC}" | grep -A10 "${IFACE}" | tail -n1 | cut -d">" -f2 | cut -d"<" -f1
/bin/echo "${DATA_INFO}" | grep -A1 "Uptime" | tail -n1 | cut -d">" -f2 | cut -d"<" -f1
/bin/date
