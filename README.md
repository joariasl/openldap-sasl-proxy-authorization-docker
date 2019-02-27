# openldap-sasl-proxy-authorization-docker

## Example for build your own container with OpenLDAP Pass-Through proxy authentication with SASL from Dockerfile
```sh
docker build -t openldap \
--build-arg LDAP_DN_BASE="MAIN_SERVER_DN_BASE" \
--build-arg LDAP_ORGANIZATION="ORGANIZATION_NAME_FOR_FIRST_OU" \
--build-arg LDAP_ROOT_DN="MANAGER_USER" \
--build-arg LDAP_ROOT_PW="TEXT_PLAIN_PASSWORD OR \{SSHA\}SSHA_GENERATED_CODE_PASSWORD" \
.
```

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
