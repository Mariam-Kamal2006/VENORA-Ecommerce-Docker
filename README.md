# VENORA – Luxury E-Commerce Website

A luxury e-commerce web application for jewelry and watches, developed using modern web technologies and containerized with Docker.

## About The Project

*VENORA* is an online shopping platform designed to provide an elegant shopping experience for luxury jewelry and watches.

The project includes a frontend interface, a PHP backend, and a MySQL database. Docker and Docker Compose are used to containerize and manage the application services seamlessly.

## Technologies Used

* *Frontend:* HTML5, CSS3, JavaScript, Nginx
* *Backend:* PHP 8.2, Apache
* *Database:* MySQL 8.0
* *DevOps & Containerization:* Docker, Docker Compose

## Features

* User Registration and Login
* Product Collections & Browsing
* Shopping Cart & Order Management
* MySQL Database Integration
* Fully Containerized Multi-Service Architecture

## Docker Architecture

The application consists of three main services:

1. *Frontend:* Nginx container serving the static website and assets.
2. *Backend:* PHP 8.2 with Apache handling application logic and API requests.
3. *Database:* MySQL 8.0 storing persistent application data.

### Docker Concepts Implemented

* Separate Dockerfile configurations for application services.
* Docker Compose for multi-container orchestration.
* Named Volumes for persistent database storage.
* Bind Mounts for sharing project files with containers.
* Custom container networking for internal communication between services.
* Database Healthcheck to ensure service readiness before backend startup.

## Project Structure

text
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

Getting Started
Prerequisites
 * Docker Desktop
 * Git
Installation
 * Clone the repository:
   git clone [https://github.com/Mariam-Kamal2006/VENORA-Ecommerce-Docker.git](https://github.com/Mariam-Kamal2006/VENORA-Ecommerce-Docker.git)

 * Navigate to the project directory:
   cd VENORA-Ecommerce-Docker

 * Create a .env file in the root directory and configure your environment variables (matching the variables defined in docker-compose.yml), for example:
   MYSQL_ROOT_PASSWORD=your_root_password
MYSQL_DATABASE=venora_db
MYSQL_USER=venora_user
MYSQL_PASSWORD=your_password

 * Build and start all services:
   docker compose up --build -d

 * Open the application in your browser:
   http://localhost:8081

Stop the Application
docker compose down

Database Persistence
Docker Named Volumes are used to preserve MySQL data even when containers are stopped or recreated.
> Note: Running docker compose down -v will remove the named volume and delete the stored database data.
> 
Future Improvements
 * Online Payment Integration
 * Advanced Product Search and Filtering
 * Admin Dashboard
 * Enhanced Security & Authentication
 * Improved User Experience
Author
Developed by Mariam Kamal as a full-stack e-commerce and Docker containerization project.
VENORA – Elegance in Every Detail.
