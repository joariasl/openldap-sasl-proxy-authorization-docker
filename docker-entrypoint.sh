#!/bin/bash

LDAP_DN_BASE=${LDAP_DN_BASE:-'dc=my-domain,dc=com'}
LDAP_ORGANIZATION=${LDAP_ORGANIZATION:-'Example'}
LDAP_ROOT_DN=${LDAP_ROOT_DN:-'cn=Manager,dc=my-domain,dc=com'}
LDAP_DATABASE=${LDAP_DATABASE:-'hdb'}
LDAP_ROOT_PW=${LDAP_ROOT_PW:-'secret'}

LDAP_SERVERS=${LDAP_SERVERS:-'ldap://ad.example.com:389/'}
LDAP_SEARCH_BASE=${LDAP_SEARCH_BASE:-'CN=DomainUsers,DC=example,DC=com'}
LDAP_TIMEOUT=${LDAP_TIMEOUT:-'10'}
LDAP_FILTER=${LDAP_FILTER:-'(sAMAccountName=%U)'}
LDAP_BIND_DN=${LDAP_BIND_DN:-'CN=Administrator,CN=Users,DC=example,DC=com'}
LDAP_PASSWORD=${LDAP_PASSWORD:-'ADpassword'}

cp /opt/openldap-init/slapd.conf /usr/local/etc/openldap/slapd.conf

sed -i -E 's/^(suffix[[:blank:]]*).*/\1"'"$LDAP_DN_BASE"'"/' /usr/local/etc/openldap/slapd.conf \
  && sed -i -E 's/^(rootdn[[:blank:]]*).*/\1"'"$LDAP_ROOT_DN"'"/' /usr/local/etc/openldap/slapd.conf \
  && sed -i -E 's/^(database[[:blank:]]*).*/\1'"$LDAP_DATABASE"'/' /usr/local/etc/openldap/slapd.conf \
  && sed -i -E 's/^(rootpw[[:blank:]]*).*/\1'"$LDAP_ROOT_PW"'/' /usr/local/etc/openldap/slapd.conf

sed -i -E 's|^(ldap_servers:[[:blank:]]*).*|\1'"$LDAP_SERVERS"'|' /etc/saslauthd.conf \
  && sed -i -E 's/^(ldap_search_base:[[:blank:]]*).*/\1'"$LDAP_SEARCH_BASE"'/' /etc/saslauthd.conf \
  && sed -i -E 's/^(ldap_timeout:[[:blank:]]*).*/\1'"$LDAP_TIMEOUT"'/' /etc/saslauthd.conf \
  && sed -i -E 's/^(ldap_filter:[[:blank:]]*).*/\1'"$LDAP_FILTER"'/' /etc/saslauthd.conf \
  && sed -i -E 's/^(ldap_bind_dn:[[:blank:]]*).*/\1'"$LDAP_BIND_DN"'/' /etc/saslauthd.conf \
  && sed -i -E 's/^(ldap_password:[[:blank:]]*).*/\1'"$LDAP_PASSWORD"'/' /etc/saslauthd.conf

# If initial configuration and database does not exists in volumes
slaptest -f /usr/local/var/openldap-data/DB_CONFIG
if [ $? != 0 ]
then
  echo "Creating initial database..."
  cp /opt/openldap-init/DB_CONFIG.example /usr/local/var/openldap-data/DB_CONFIG

  sed -i -E 's/^(dn:[[:blank:]]*).*/\1'"$LDAP_DN_BASE"'/' /opt/openldap-init/create.ldif \
    && sed -i -E 's/^(o:[[:blank:]]*).*/\1'"$LDAP_ORGANIZATION"'/' /opt/openldap-init/create.ldif

  slapadd -l /opt/openldap-init/create.ldif
fi

service saslauthd start
/usr/local/libexec/slapd -d 1024
