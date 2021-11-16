FROM dpage/pgadmin4

COPY --chown=pgadmin:pgadmin ./docker/pgadmin4/servers.json /pgadmin4/servers.json
COPY --chown=pgadmin:pgadmin SQL/ /var/lib/pgadmin/storage/admin_example.com/