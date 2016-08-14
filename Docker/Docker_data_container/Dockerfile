FROM busybox
## /data/db is for MongoDB

RUN mkdir -p /data/db
RUN chmod -R 777    /data/db
RUN mkdir -p /data/db

# /var/lib/mysql is for MySQL
RUN mkdir -p        /var/lib/mysql/
RUN chmod -R 777    /var/lib/mysql/

VOLUME ["/var/lib/mysql" , "/data/db" , "/data"]

CMD ["true"]