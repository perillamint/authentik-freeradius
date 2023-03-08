#!/bin/sh

cat /etc/raddb/template/ldap.template | \
sed "s/__LDAP_ADM_IDENTITY__/${LDAP_ADM_IDENTITY}/g" | \
sed "s/__LDAP_ADM_PASSWORD__/${LDAP_ADM_PASSWORD}/g" | \
sed "s/__LDAP_BASE_DN__/${LDAP_BASE_DN}/g" > /etc/raddb/mods-available/ldap

exec /opt/sbin/radiusd $*