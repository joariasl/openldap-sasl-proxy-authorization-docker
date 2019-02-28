# openldap-sasl-proxy-authorization-docker

## Running with SASL configuration
```
docker run -d --name openldap -p 389:389 \
-e LDAP_DN_BASE=dc=my-domain,dc=com \
-e LDAP_ORGANIZATION=Example \
-e LDAP_ROOT_DN=cn=Manager,dc=my-domain,dc=com \
-e LDAP_DATABASE=hdb \
-e LDAP_ROOT_PW=secret \
-e LDAP_SERVERS='ldap://ad.example.com:389/' \
-e LDAP_SEARCH_BASE='CN=DomainUsers,DC=example,DC=com' \
-e LDAP_TIMEOUT=10 \
-e LDAP_FILTER='(sAMAccountName=%U)' \
-e LDAP_BIND_DN='CN=Administrator,CN=Users,DC=example,DC=com' \
-e LDAP_PASSWORD='ADpassword' \
openldap
```

## Using volumes
```
docker run -d --name openldap -p 389:389 \
-e LDAP_DN_BASE=dc=my-domain,dc=com \
-e LDAP_ORGANIZATION=Example \
-e LDAP_ROOT_DN=cn=Manager,dc=my-domain,dc=com \
-e LDAP_DATABASE=hdb \
-e LDAP_ROOT_PW=secret \
-e LDAP_SERVERS='ldap://ad.example.com:389/' \
-e LDAP_SEARCH_BASE='CN=DomainUsers,DC=example,DC=com' \
-e LDAP_TIMEOUT=10 \
-e LDAP_FILTER='(sAMAccountName=%U)' \
-e LDAP_BIND_DN='CN=Administrator,CN=Users,DC=example,DC=com' \
-e LDAP_PASSWORD='ADpassword' \
-v openldap-conf:/usr/local/etc/openldap \
-v openldap-data:/usr/local/var/openldap-data \
openldap
```
