FROM ubuntu:20.04
RUN apt update \
  && apt upgrade -y

RUN apt install -y bind9 bind9-utils \
  && rm -r /var/lib/apt/lists/*

#-- Create system user
RUN useradd -M -l -r -s /usr/sbin/nologin named

#-- Create directories
RUN mkdir /var/named
RUN chown named:named /var/named
RUN mkdir /run/named
RUN chown named:named /run/named


#-- ports exposed
EXPOSE 53/tcp
EXPOSE 53/udp

#-- volume for configuration and data
VOLUME /var/named

#-- copy entrypoint and set permissions
COPY --chown=named:named entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
