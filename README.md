# openldap-sasl-proxy-authorization-docker

## Example for build your own container with OpenLDAP Pass-Through proxy authentication with SASL from Dockerfile
```sh
docker build -t openldap --build-arg \
--build-arg LDAP_SERVERS="ldap://YOUR_MAIN_SERVER_IP:389/" \
--build-arg LDAP_SEARCH_BASE="MAIN_SERVER_SEARCH_BASE" \
--build-arg LDAP_FILTER="(sAMAccountName=%U)" \
--build-arg LDAP_BIND_DN="MAIN_SERVER_USER_BIND" \
--build-arg LDAP_PASSWORD="MAIN_SERVER_USER_PASSWORD" \
--build-arg LDAP_DN_BASE="MAIN_SERVER_DN_BASE" \
--build-arg LDAP_ORGANIZATION="ORGANIZATION_NAME_FOR_FIRST_OU" \
--build-arg LDAP_ROOT_DN="MANAGER_USER" \
--build-arg LDAP_ROOT_PW="TEXT_PLAIN_PASSWORD OR \{SSHA\}SSHA_GENERATED_CODE_PASSWORD" \
.
```
