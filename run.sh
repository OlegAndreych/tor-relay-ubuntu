#!/bin/bash
set -e
set -o pipefail

for relaytype in bridge middle exit; do
	file="/etc/tor/torrc.${relaytype}"
	ports=$(echo $RELAY_PORT | tr ";" "\n")
	ports_beginning='## Required: what port to advertise for incoming Tor connections.'
	ports_end='## If you want to listen on a port other than the one advertised in'

	sed -i "s/RELAY_NICKNAME/${RELAY_NICKNAME}/g" "$file"
	sed -i "s/CONTACT_GPG_FINGERPRINT/${CONTACT_GPG_FINGERPRINT}/g" "$file"
	sed -i "s/CONTACT_NAME/${CONTACT_NAME}/g" "$file"
	sed -i "s/CONTACT_EMAIL/${CONTACT_EMAIL}/g" "$file"
	sed -i "s/RELAY_BANDWIDTH_RATE/${RELAY_BANDWIDTH_RATE}/g" "$file"
	sed -i "s/RELAY_BANDWIDTH_BURST/${RELAY_BANDWIDTH_BURST}/g" "$file"

	sed -i "/$ports_beginning/,/$ports_end/{//!d}" "$file"

	for port in $ports
	do
		sed -i "/$ports_beginning/a ORPort $port" "$file" 
	done

	if [ -n "${ADDRESS}" ]; then
		sed -i "/^#Address ADDRESS/s/#Address ADDRESS/Address ${ADDRESS}/g" "$file"
	fi
done

cat "/etc/tor/torrc.${RELAY_TYPE}"
exec tor -f "/etc/tor/torrc.${RELAY_TYPE}" --DataDirectory "/home/tor/.tor"
