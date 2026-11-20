# VENORA – Luxury E-Commerce Website

A luxury e-commerce web application for jewelry and watches, built using modern web technologies and containerized with Docker.

## About The Project

VENORA is an online shopping platform designed to provide an elegant and seamless shopping experience for luxury jewelry and watches.

The application consists of three main components: a frontend interface, a PHP backend, and a MySQL database. Docker and Docker Compose are used to containerize, build, and manage all application services.

## Technologies Used

- HTML5
- CSS3
- JavaScript
- PHP 8.2
- MySQL 8.0
- Nginx
- Apache
- Docker
- Docker Compose

## Features

- User Registration and Login
- Product Collections
- Product Browsing
- Shopping Cart
- Order Management
- MySQL Database Integration
- Frontend and Backend Communication
- Containerized Application Services

## Docker Architecture

The application consists of three main services:

1. **Frontend:** Nginx container serving the website files.
2. **Backend:** PHP 8.2 with Apache handling application logic and API requests.
3. **Database:** MySQL 8.0 storing application data.

### Docker Concepts Implemented

- **Separate Dockerfiles:** Independent Dockerfiles for building application services.
- **Docker Compose:** Orchestrates all services using a single command.
- **Named Volumes:** Provides persistent storage for MySQL database data.
- **Bind Mounts:** Shares project files between the host machine and containers.
- **Container Networking:** Enables communication between application services.
- **Database Healthcheck:** Checks database readiness before dependent services start.

## Project Structure

```text
VENORA-Ecommerce-Docker/
│
├── frontend/
│   ├── Dockerfile
│   ├── css/
│   ├── js/
│   └── images/
│
├── backend/
│   ├── Dockerfile
│   ├── config/
│   └── api/
│
├── database/
│   ├── Dockerfile
│   └── init.sql
│
├── docker-compose.yml
└── README.md
```

## Getting Started

### Prerequisites

Make sure you have installed:

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Git](https://git-scm.com/)

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/Mariam-Kamal2006/VENORA-Ecommerce-Docker.git
```

**2. Navigate to the project directory**

```bash
cd VENORA-Ecommerce-Docker
```

**3. Create your environment file**

Create a new file named `.env` in the root directory of the project, at the same level as `docker-compose.yml`.

On Windows PowerShell:

```powershell
New-Item -Path .env -ItemType File
```

**4. Configure environment variables**

Open the `.env` file and add the following configuration:

```env
MYSQL_ROOT_PASSWORD=your_root_password
MYSQL_DATABASE=venora
MYSQL_USER=venora_user
MYSQL_PASSWORD=your_password
```

Replace the example values with your own database credentials.

Make sure the variable names match those defined in `docker-compose.yml`.

**5. Build and start all services**

```bash
docker compose up --build -d
```

**6. Verify running containers**

```bash
docker compose ps
```

**7. Open the application**

Open your browser and visit:

http://localhost:8080

## Managing Docker Containers

**Stop and remove containers:**

```bash
docker compose down
```

**Stop containers without removing them:**

```bash
docker compose stop
```

**View application logs:**

```bash
docker compose logs -f
```

**Rebuild and restart all services:**

```bash
docker compose up --build -d
```

## Database Persistence

Docker Named Volumes are used to preserve MySQL database data even when containers are stopped or recreated.

**Important:** Removing the named volume will permanently delete the stored database data.

To remove containers and their associated volumes:

```bash
docker compose down -v
```

## Future Improvements

- Online Payment Integration
- Product Search and Filtering
- Admin Dashboard
- Enhanced Security
- Improved User Experience

## Author

Developed as an e-commerce and Docker learning project.

---

**VENORA – Elegance in Every Detail.**
