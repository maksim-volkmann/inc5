FROM debian:stable

RUN		apt-get update
RUN		apt-get install -y redis \
		&& rm -rf /var/lib/apt/lists/*

COPY ./tools/redis.sh .

EXPOSE 6379
RUN chmod +x redis.sh
CMD ["./redis.sh"]
