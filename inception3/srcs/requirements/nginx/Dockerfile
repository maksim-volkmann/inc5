FROM debian:stable

RUN apt update && apt install -y nginx openssl curl && apt clean

# Generate SSL
RUN mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt \
	-subj "/C=DE/ST=Baden-Wurttemberg/L=Heilbronn/O=42/OU=Student/CN=mvolkman.42.fr"

EXPOSE 443

# Copy NGINX default config
COPY ./conf/default /etc/nginx/sites-available/default

CMD ["nginx", "-g", "daemon off;"]
