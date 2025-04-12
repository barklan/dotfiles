#!/bin/bash

set -e

sleep 3

until ping -c 1 one.one.one.one
do
  sleep 1
done

systemd-run --unit=cliphist-watch --collect --user wl-paste --watch cliphist store

setsid telegram-desktop -startintray >/dev/null 2>&1 &
