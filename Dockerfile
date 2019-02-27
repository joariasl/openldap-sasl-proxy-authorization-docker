FROM ubuntu:16.04

LABEL maintainer="Jorge Arias <mail@jorgearias.cl>"

ENV OPENLDAP_VERSION 2.4.47

RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  groff-base \
  libdb-dev \
  libssl1.0.0 libssl-dev libiodbc2 libiodbc2-dev libsasl2-2 libsasl2-dev \
  sasl2-bin

RUN sed -i 's/MECHANISMS="pam"/MECHANISMS="ldap"/' /etc/default/saslauthd \
  && sed -i 's/START=no/START=yes/' /etc/default/saslauthd \
  && touch /etc/saslauthd.conf \
  && echo "mech_list: plain" >> /usr/lib/sasl2/slapd.conf \
  && echo "pwcheck_method: saslauthd" >> /usr/lib/sasl2/slapd.conf \
  && echo "saslauthd_path: /var/run/saslauthd/mux" >> /usr/lib/sasl2/slapd.conf

COPY assets/saslauthd.conf /etc/saslauthd.conf

RUN curl -LJO http://mirror.eu.oneandone.net/software/openldap/openldap-release/openldap-${OPENLDAP_VERSION}.tgz \
  && gunzip -c openldap-${OPENLDAP_VERSION}.tgz | tar xf - \
  && rm openldap-${OPENLDAP_VERSION}.tgz

WORKDIR /openldap-${OPENLDAP_VERSION}

RUN ./configure --enable-spasswd --with-cyrus-sasl --enable-memberof \
  && make depend \
  && make \
  && make install \
  && make clean

RUN mkdir /opt/openldap-init \
  && cp /usr/local/var/openldap-data/DB_CONFIG.example /opt/openldap-init/

COPY assets/slapd.conf /opt/openldap-init/slapd.conf

COPY assets/create.ldif /opt/openldap-init/create.ldif

WORKDIR /

EXPOSE 389

VOLUME ["/usr/local/var/openldap-data"]

COPY docker-entrypoint.sh /sbin/docker-entrypoint.sh

RUN chmod 755 /sbin/docker-entrypoint.sh

ENTRYPOINT ["/sbin/docker-entrypoint.sh"]
