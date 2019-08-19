# run a tor relay in a container
#
# Bridge relay:
#	docker run -d \
#		--restart always \
#		-v /etc/localtime:/etc/localtime:ro \
#		-p 9001:9001 \
# 		--name tor-relay \
# 		jess/tor-relay -f /etc/tor/torrc.bridge
#
# Exit relay:
# 	docker run -d \
#		--restart always \
#		-v /etc/localtime:/etc/localtime:ro \
#		-p 9001:9001 \
# 		--name tor-relay \
# 		jess/tor-relay -f /etc/tor/torrc.exit
#
FROM ubuntu:latest
LABEL maintainer "Oleg Andreych <kjiec4@gmail.com>"

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y curl gpg
RUN echo "deb https://deb.torproject.org/torproject.org bionic main" >> /etc/apt/sources.list
RUN curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import
RUN gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -
RUN apt-get update
RUN apt-get install -y tor deb.torproject.org-keyring

# default port to used for incoming Tor connections
# can be changed by changing 'ORPort' in torrc
EXPOSE 9001

# copy in our torrc files
COPY torrc.bridge /etc/tor/torrc.bridge
COPY torrc.middle /etc/tor/torrc.middle
COPY torrc.exit /etc/tor/torrc.exit

# copy the run script
COPY run.sh /run.sh
RUN chmod ugo+rx /run.sh

# default environment variables
ENV RELAY_NICKNAME hacktheplanet
ENV RELAY_TYPE middle
ENV RELAY_BANDWIDTH_RATE 100 KBytes
ENV RELAY_BANDWIDTH_BURST 200 KBytes
ENV RELAY_PORT 9001

RUN groupadd -g 1000 tor && useradd -m -d /home/tor -g 1000 tor

# make sure files are owned by tor user
RUN chown -R tor /etc/tor

RUN mkdir /home/tor/.tor
RUN chown -R tor /home/tor/.tor

VOLUME ["/home/tor/.tor"]

USER tor

ENTRYPOINT [ "/run.sh" ]
