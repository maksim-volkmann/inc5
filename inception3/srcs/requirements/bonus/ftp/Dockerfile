FROM debian:stable

# Install vsftpd
RUN apt update && apt install -y vsftpd && apt clean

# Copy vsftpd configuration
COPY conf/vsftpd.conf /etc/vsftpd.conf

# Ensure secure_chroot_dir exists
RUN mkdir -p /var/run/vsftpd/empty && chmod 555 /var/run/vsftpd/empty

# Set ownership and permissions for /var/www/html
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html && chmod -R 775 /var/www/html

# Use script to handle secrets at runtime
COPY tools/ftp.sh /ftp.sh
RUN chmod +x /ftp.sh

EXPOSE 21 40000-40010

# Launch vsftpd
ENTRYPOINT ["/ftp.sh"]
