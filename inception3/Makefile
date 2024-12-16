## Inception Makefile

# Define variables for directories
# DATA_DIR := /home/mvolkman/data
# DB_DIR := $(DATA_DIR)/db
# WP_DIR := $(DATA_DIR)/wp

default: build up

# create-directories:
# 	@echo "Creating required directories..."
# 	mkdir -p $(DB_DIR)
# 	mkdir -p $(WP_DIR)
# 	@echo "Directories created: $(DB_DIR), $(WP_DIR)"

build:
	# Check and create /home/mvolkman/data/db if it doesn't exist
	if [ ! -d "/home/mvolkman/data/db" ]; then \
		mkdir -p /home/mvolkman/data/db; \
		chmod 777 /home/mvolkman/data/db; \
	fi

	# Check and create /home/mvolkman/data/wp if it doesn't exist
	if [ ! -d "/home/mvolkman/data/wp" ]; then \
		mkdir -p /home/mvolkman/data/wp; \
		chmod 777 /home/mvolkman/data/wp; \
	fi

	# Navigate to srcs and build Docker containers
	cd srcs && docker compose build

up:
	# $(MAKE) create-directories
	cd srcs && docker compose up -d

down:
	cd srcs && docker compose down

re: fclean build up

clean:
	# Stop all running containers if any exist
	if [ -n "$$(docker ps -q)" ]; then \
		docker stop $$(docker ps -q); \
	fi

	# Remove all containers if any exist
	if [ -n "$$(docker ps -aq)" ]; then \
		docker rm $$(docker ps -aq); \
	fi

	# Remove specific Docker volumes
	docker volume rm db-volume wp-volume || true


cclean:
	docker system prune -a --volumes -f

fclean:
	# $(MAKE) clean
	if [ -d "/home/$(USER)/data" ]; then \
		sudo rm -rf /home/$(USER)/data; \
		echo "Removed /home/$(USER)/data"; \
	else \
		echo "Directory /home/$(USER)/data is empty"; \
	fi

