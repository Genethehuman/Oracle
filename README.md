# 🚀 Oracle Database on Apple Silicon - Maximum Power

Complete solution for running Oracle Database 19c Enterprise Edition on Apple Silicon Macs (M1, M2, M3, M4+) using Docker.

## 📋 Prerequisites

- Docker and Docker Compose
- Make
- Git

## 🛠 Technologies

- Oracle Database 19.3.0 Enterprise Edition
- Python 3.11
- oracledb driver version 1.4.2
- Docker & Docker Compose

## 🏗 Project Structure

```
.
├── docker-compose.yml      # Docker containers configuration
├── Dockerfile             # Python application build
├── Makefile              # Make commands for management
├── requirements.txt      # Python dependencies
├── test_app.py          # Test application
└── README.md            # Documentation (you are here 👀)
```

## 🎯 Make Commands

| Command | Description |
|---------|-------------|
| `make db` | Starts Oracle Database only |
| `make test-app` | Starts the test Python application |
| `make app-logs` | Shows test application logs |
| `make start-all` | Starts everything (both database and application) |
| `make stop-all` | Stops all services |

## 🚀 Quick Start

1. Clone the repository:
```bash
git clone https://github.com/Genethehuman/Oracle.git
cd Oracle
```

2. Start everything with one command:
```bash
make start-all
```

3. Check application logs:
```bash
make app-logs
```

## 📝 Usage Examples

### Start Database Only
```bash
make db
```

### Start Test Application
```bash
make test-app
```

### View Logs
```bash
make app-logs
```

### Stop All Services
```bash
make stop-all
```

## 🔍 What Does the Test Application Do?

1. Waits for the database to be ready
2. Creates a test table
3. Inserts test data
4. Reads and displays the data

## ⚙️ Configuration & Customization

### 🔑 Database Settings

You can customize database settings by modifying these files:

#### **docker-compose.yml** - Main database configuration:
```yaml
services:
  oracle:
    environment:
      - ORACLE_PWD=YourPass321    # Change database password here
    ports:
      - "1521:1521"              # Change external port here (host:container)
```

#### **test_app.py** - Application connection settings:
```python
connection = oracledb.connect(
    user="system",                           # Database user
    password=os.getenv("ORACLE_PASSWORD", "YourPass321"),  # Password
    dsn="oracle:1521/ORCLPDB1"              # Host:Port/Service
)
```

#### **Makefile** - Default values:
```makefile
ORACLE_PASSWORD ?= YourPass321              # Default password
CONTAINER_NAME := oracle                    # Container name
```

### 🌐 Common Customizations

#### Change Database Password:
1. Update `ORACLE_PWD` in `docker-compose.yml`
2. Update `ORACLE_PASSWORD` in `docker-compose.yml` (test_app service)
3. Update password in `test_app.py` or use environment variable

#### Change Database Port:
1. Update port mapping in `docker-compose.yml`: `"1522:1521"`
2. Update connection string in `test_app.py`: `"oracle:1522/ORCLPDB1"`

#### Use Different Container Name:
1. Update `container_name` in `docker-compose.yml`
2. Update `CONTAINER_NAME` in `Makefile`

#### Connect from External Application:
```python
# Use this connection string in your apps:
connection_string = "system/YourPass321@localhost:1521/ORCLPDB1"
```

### 🔒 Security Notes

- **Default password**: `YourPass321` (change for production!)
- **Default port**: `1521` (standard Oracle port)
- **Service name**: `ORCLPDB1` (Oracle Pluggable Database)
- **Default user**: `system` (Oracle system user)

## 🤝 Contributing

If you want to help the project - make a fork and send a pull request! We welcome any help.

## 📜 License

MIT

## 👥 Authors

- [Gene Podrezov](https://github.com/Genethehuman)

## 🙏 Acknowledgments

- Big thanks to Oracle for the excellent database
- Thanks to the Python community for amazing tools
- Special thanks to all brothers who will use this code!


---
*Made with ❤️ by brothers for brothers* 