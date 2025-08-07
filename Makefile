# Makefile for Oracle Database 19c setup on Mac M1
# Prerequisites:
# 1. Docker Desktop installed
# 2. Git installed
# 3. Oracle account (for downloading the database)

# Configuration
ORACLE_VERSION := 19.3.0
ORACLE_DB_ZIP := LINUX.ARM64_1919000_db_home.zip
ORACLE_DOCKER_REPO := oracle/docker-images
ORACLE_LOCAL_PATH := docker-images
ORACLE_PASSWORD ?= YourPass321
CONTAINER_NAME := oracle

.PHONY: all
all: check-prereqs clone-repo download-notice build-image start-all

.PHONY: check-prereqs
check-prereqs:
	@echo "Checking prerequisites..."
	@which docker >/dev/null 2>&1 || (echo "Docker is not installed. Please install Docker Desktop first." && exit 1)
	@which git >/dev/null 2>&1 || (echo "Git is not installed. Please install Git first." && exit 1)
	@docker info >/dev/null 2>&1 || (echo "Docker daemon is not running. Please start Docker Desktop." && exit 1)

.PHONY: clone-repo
clone-repo:
	@echo "Cloning Oracle Docker repository..."
	@if [ ! -d "$(ORACLE_LOCAL_PATH)" ]; then \
		git clone https://github.com/$(ORACLE_DOCKER_REPO).git; \
	else \
		echo "Repository already exists. Skipping clone."; \
	fi

.PHONY: download-notice
download-notice:
	@echo "==================================================================="
	@echo "IMPORTANT: Before proceeding, please download Oracle Database 19c:"
	@echo "1. Go to: https://www.oracle.com/database/technologies/oracle-database-software-downloads.html"
	@echo "2. Sign in with your Oracle account"
	@echo "3. Download 'Oracle Database 19c for LINUX ARM (aarch64)'"
	@echo "4. Place the downloaded $(ORACLE_DB_ZIP) file in:"
	@echo "   $(ORACLE_LOCAL_PATH)/OracleDatabase/SingleInstance/dockerfiles/$(ORACLE_VERSION)/"
	@echo "==================================================================="
	@read -p "Press Enter once you have completed these steps..." dummy

.PHONY: build-image
build-image:
	@echo "Building Oracle Database Docker image..."
	@cd $(ORACLE_LOCAL_PATH)/OracleDatabase/SingleInstance/dockerfiles && \
	./buildContainerImage.sh -v $(ORACLE_VERSION) -e



.PHONY: clean
clean:
	@echo "Cleaning up..."
	@docker stop $(CONTAINER_NAME) 2>/dev/null || true
	@docker rm $(CONTAINER_NAME) 2>/dev/null || true
	@echo "To remove the repository, run: rm -rf $(ORACLE_LOCAL_PATH)"

.PHONY: status
status:
	@echo "Checking Oracle Database container status..."
	@docker ps -f name=$(CONTAINER_NAME)
	@echo "\nContainer logs:"
	@docker logs $(CONTAINER_NAME) | tail -n 20

.PHONY: db
db:
	@echo "Starting Oracle Database using docker compose..."
	docker compose up -d oracle
	@echo "Database is starting up. You can check the logs with: docker compose logs -f oracle"

.PHONY: test-app
test-app:
	@echo "Starting test application..."
	docker compose up -d test_app
	@echo "Test application is starting up. You can check the logs with: docker compose logs -f test_app"

.PHONY: app-logs
app-logs:
	@echo "Showing test application logs..."
	docker compose logs -f test_app

.PHONY: start-all
start-all:
	@echo "Starting both database and test application..."
	docker compose up -d
	@echo "All services are starting up. Check status with: docker compose ps"
	@echo "Check logs with: docker compose logs -f"

.PHONY: stop-all
stop-all:
	@echo "Stopping all services..."
	docker compose down
	@echo "All services have been stopped." 