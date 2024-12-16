FROM debian:stable

RUN apt update && apt install -y nginx openssl curl && apt clean

# Generate SSL Certificate
RUN mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt \
	-subj "/C=DE/ST=Baden-Württemberg/L=Heilbronn/O=42/OU=Student/CN=cats.42.fr"

# Port
EXPOSE 443

# Copy website content to container
COPY web/ /var/www/html/

# Copy NGINX default config
COPY ./conf/default /etc/nginx/sites-available/default

CMD ["nginx", "-g", "daemon off;"]
