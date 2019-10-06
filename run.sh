#!/bin/bash
set -e
set -o pipefail

for relaytype in bridge middle exit; do
	file="/etc/tor/torrc.${relaytype}"
	ports=$(echo $RELAY_PORT | tr ";" "\n")

	sed -i "s/RELAY_NICKNAME/${RELAY_NICKNAME}/g" "$file"
	sed -i "s/CONTACT_GPG_FINGERPRINT/${CONTACT_GPG_FINGERPRINT}/g" "$file"
	sed -i "s/CONTACT_NAME/${CONTACT_NAME}/g" "$file"
	sed -i "s/CONTACT_EMAIL/${CONTACT_EMAIL}/g" "$file"
	sed -i "s/RELAY_BANDWIDTH_RATE/${RELAY_BANDWIDTH_RATE}/g" "$file"
	sed -i "s/RELAY_BANDWIDTH_BURST/${RELAY_BANDWIDTH_BURST}/g" "$file"

	for port in $ports
	do
		sed -i "/## Required: what port to advertise for incoming Tor connections./a ORPort $port" "$file" 
	done

	if [ -n "${ADDRESS}" ]; then
		sed -i "/^#Address ADDRESS/s/#Address ADDRESS/Address ${ADDRESS}/g" "$file"
	fi
done

exec tor -f "/etc/tor/torrc.${RELAY_TYPE}" --DataDirectory "/home/tor/.tor"
