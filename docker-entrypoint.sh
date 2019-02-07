#!/bin/bash

LDAP_SERVERS=${LDAP_SERVERS:-'ldap://ad.example.com:389/'}
LDAP_SEARCH_BASE=${LDAP_SEARCH_BASE:-'CN=DomainUsers,DC=example,DC=com'}
LDAP_TIMEOUT=${LDAP_TIMEOUT:-'10'}
LDAP_FILTER=${LDAP_FILTER:-'(sAMAccountName=%U)'}
LDAP_BIND_DN=${LDAP_BIND_DN:-'CN=Administrator,CN=Users,DC=example,DC=com'}
LDAP_PASSWORD=${LDAP_PASSWORD:-'ADpassword'}

sed -i -E 's|^(ldap_servers:[[:blank:]]*).*|\1'"$LDAP_SERVERS"'|' /etc/saslauthd.conf \
  && sed -i -E 's/^(ldap_search_base:[[:blank:]]*).*/\1'"$LDAP_SEARCH_BASE"'/' /etc/saslauthd.conf \
  && sed -i -E 's/^(ldap_timeout:[[:blank:]]*).*/\1'"$LDAP_TIMEOUT"'/' /etc/saslauthd.conf \
  && sed -i -E 's/^(ldap_filter:[[:blank:]]*).*/\1'"$LDAP_FILTER"'/' /etc/saslauthd.conf \
  && sed -i -E 's/^(ldap_bind_dn:[[:blank:]]*).*/\1'"$LDAP_BIND_DN"'/' /etc/saslauthd.conf \
  && sed -i -E 's/^(ldap_password:[[:blank:]]*).*/\1'"$LDAP_PASSWORD"'/' /etc/saslauthd.conf

service saslauthd start
/usr/local/libexec/slapd -d 1024
