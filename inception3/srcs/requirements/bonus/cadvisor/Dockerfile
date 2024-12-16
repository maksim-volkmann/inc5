FROM debian:stable

# Install necessary dependencies
RUN apt update -y && apt install -y wget ca-certificates && apt clean

# Set the cAdvisor version
ENV CADVISOR_VERSION v0.49.2
ENV CADVISOR_BINARY cadvisor-${CADVISOR_VERSION}-linux-amd64

# Download the specific cAdvisor binary for Linux AMD64
RUN wget https://github.com/google/cadvisor/releases/download/${CADVISOR_VERSION}/${CADVISOR_BINARY} -O /usr/local/bin/cadvisor && \
    chmod +x /usr/local/bin/cadvisor

# Expose the default cAdvisor port
EXPOSE 8080

# Start cAdvisor
CMD ["/usr/local/bin/cadvisor"]
