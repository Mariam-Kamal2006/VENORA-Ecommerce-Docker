# VENORA – Luxury E-Commerce Website

A luxury e-commerce web application for jewelry and watches, developed using modern web technologies and containerized with Docker.

## About The Project

VENORA is an online shopping platform designed to provide an elegant shopping experience for luxury jewelry and watches.

The project includes a frontend interface, a PHP backend, and a MySQL database. Docker and Docker Compose are used to containerize and manage the application services.

## Technologies Used

- HTML5
- CSS3
- JavaScript
- PHP 8.2
- MySQL 8.0
- Docker
- Docker Compose
- Nginx
- Apache

## Features

- User Registration and Login
- Product Collections
- Product Browsing
- Shopping Cart
- Order Management
- MySQL Database Integration
- Containerized Application Services

## Docker Architecture

The application consists of three main services:

1. **Frontend:** Nginx container serving the website.
2. **Backend:** PHP 8.2 with Apache handling application logic and API requests.
3. **Database:** MySQL 8.0 storing application data.

### Docker Concepts Implemented

- Separate Dockerfiles for application services.
- Docker Compose for multi-container orchestration.
- Named Volumes for persistent database storage.
- Bind Mounts for sharing project files with containers.
- Container networking for communication between services.
- Database Healthcheck for service readiness.

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
├── .env.example
├── .gitignore
└── README.md
```

## Getting Started

### Prerequisites

- Docker Desktop
- Git

### Installation

1. Clone the repository:

```bash
git clone YOUR_REPOSITORY_URL
```

2. Navigate to the project directory:

```bash
cd VENORA-Ecommerce-Docker
```

3. Create your environment file:

On Windows PowerShell:

```powershell
Copy-Item .env.example .env
```

4. Open `.env` and configure your database credentials.

5. Build and start all services:

```bash
docker compose up --build -d
```

6. Open the application:

```text
http://localhost:8080
```

### Stop the Application

```bash
docker compose down
```

## Database Persistence

Docker Named Volumes are used to preserve MySQL data even when containers are stopped or recreated.

**Note:** Removing the named volume will delete the stored database data.

## Future Improvements

- Online Payment Integration
- Product Search and Filtering
- Admin Dashboard
- Improved Security
- Enhanced User Experience

## Author

Developed as an e-commerce and Docker learning project.

---

**VENORA – Elegance in Every Detail.**
