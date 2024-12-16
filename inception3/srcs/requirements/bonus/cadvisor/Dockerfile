FROM debian:stable

# Install dependencies
RUN apt-get update && apt-get install -y \
	wget \
	ca-certificates \
	&& apt-get clean

# Set cAdvisor version and binary details via environment variables
ENV CADVISOR_VERSION="v0.49.2"
ENV CADVISOR_BINARY="cadvisor-${CADVISOR_VERSION}-linux-amd64"
ENV CADVISOR_URL="https://github.com/google/cadvisor/releases/download/${CADVISOR_VERSION}/${CADVISOR_BINARY}"

# Download the cAdvisor binary using the environment variables
RUN wget "${CADVISOR_URL}" -O /usr/local/bin/cadvisor && \
	chmod +x /usr/local/bin/cadvisor

# Port
EXPOSE 8080

# Run
CMD ["/usr/local/bin/cadvisor"]
