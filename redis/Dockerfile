FROM redis

COPY healthcheck.sh /usr/local/bin/

# Add our own redis.conf, comment out bind + have "protected-mode no", so that it accepts connections from outside
COPY redis.conf /usr/local/etc/redis/redis.conf

CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]

HEALTHCHECK CMD ["healthcheck.sh"]

EXPOSE 6379