FROM freeradius/freeradius-server:latest-3.2-alpine

RUN apk add --no-cache openssl

# Generate Dhparam
RUN rm -rf /etc/raddb/certs && \
 mkdir -p /etc/raddb/certs && \
 cd /etc/raddb/certs && \
 openssl dhparam -out dh.pem 2048

RUN mkdir -p /etc/raddb/template/

COPY freeradius/radiusd.conf clients.conf /etc/raddb/
COPY freeradius/mods/eap /etc/raddb/mods-available
COPY freeradius/mods/ldap.template /etc/raddb/template/

COPY freeradius/sites/site /etc/raddb/sites-available
COPY freeradius/sites/inner-tunnel /etc/raddb/sites-available
COPY freeradius/sites/proxy-inner-tunnel /etc/raddb/sites-available
COPY freeradius/users /etc/raddb/mods-config/files/authorize
COPY freeradius/entrypoint.sh /entrypoint.sh

RUN rm /etc/raddb/sites-enabled/* && \
    ln -s /etc/raddb/sites-available/site /etc/raddb/sites-enabled/site && \
    ln -s /etc/raddb/mods-available/ldap /etc/raddb/mods-enabled/ldap && \
    ln -s /etc/raddb/sites-available/inner-tunnel /etc/raddb/sites-enabled/inner-tunnel && \
    mkdir /tmp/radiusd
    #ln -s /etc/raddb/sites-available/proxy-inner-tunnel /etc/raddb/sites-enabled/proxy-inner-tunnel && \

WORKDIR /

EXPOSE 1812/udp

ENTRYPOINT ["/entrypoint.sh"]

CMD ["-d", "/etc/raddb", "-X", "-f"]
