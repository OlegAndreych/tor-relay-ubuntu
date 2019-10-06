Recources for this docker image are based (or just copied) from https://github.com/jessfraz/dockerfiles.  
Main reason for this is that original dockerfile produced an image with not recommended version of tor.  
This image based on ubuntu with tor version from tor package repository (https://2019.www.torproject.org/docs/debian.html.en#ubuntu).

 ### Environment variables

| Name                         | Description                                                                  | Default value |
| ---------------------------- |:----------------------------------------------------------------------------:| -------------:|
| **RELAY_TYPE**               | The type of relay (bridge, middle or exit)                                   | middle        |
| **RELAY_NICKNAME**           | The nickname of your relay                                                   | hacktheplanet |
| **CONTACT_GPG_FINGERPRINT**  | Your GPG ID or fingerprint                                                   | none          |
| **CONTACT_NAME**             | Your name                                                                    | none          |
| **CONTACT_EMAIL**            | Your contact email                                                           | none          |
| **RELAY_BANDWIDTH_RATE**     | Limit how much traffic will be allowed through your relay (must be > 20KB/s) | 100 KBytes    |
| **RELAY_BANDWIDTH_BURST**    | Allow temporary bursts up to a certain amount                                | 200 KBytes    |
| **RELAY_PORT**               | Semicolon delimited list of ports used for incoming Tor connections (ORPort) | 9001          |
| **ADDRESS**                  | External IP address/hostname                                                 | none          |

DataDirectory for the relay defined as a volume at `/home/tor/.tor`.