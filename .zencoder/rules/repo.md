---
description: Repository Information Overview
alwaysApply: true
---

# Repository Information Overview

## Repository Summary
Full-stack e-commerce application with Spring Boot backend and React frontend. Backend API runs on port 5000 with PostgreSQL database and JWT authentication. Frontend runs on port 5173 with Vite dev server.

## Repository Structure

### Main Repository Components
- **ecom-backend**: Spring Boot 3.4.3 REST API backend with PostgreSQL integration
- **ecom-frontend**: React 19 + Vite 6 frontend with Redux, Material-UI, and Tailwind CSS

---

## Projects

### ecom-backend (Spring Boot Backend)

**Configuration File**: `ecom-backend/pom.xml`

#### Language & Runtime
**Language**: Java 21  
**Build System**: Maven 3  
**Framework**: Spring Boot 3.4.3  
**Package Manager**: Maven

#### Dependencies
**Main**:
- Spring Boot Starter Web
- Spring Boot Data JPA
- Spring Boot Security with JWT (JJWT 0.12.3)
- PostgreSQL Driver
- H2 Database
- Lombok
- ModelMapper 3.2.2

**Development**:
- Spring Boot Test
- Spring Security Test
- Spring Boot DevTools

#### Build & Installation
```bash
cd ecom-backend
mvn clean install
mvn spring-boot:run
```

**Entry Point**: `ecom-backend/src/main/java/com/jianquanwang/ecommerce/EcommerceApplication.java`

**Configuration**: `ecom-backend/src/main/resources/application.properties`
- Server Port: 5000
- Database: PostgreSQL (localhost:5432/ecommerce)
- JWT configured with secret and expiration

#### Testing
**Framework**: Spring Boot Test (JUnit)  
**Test Location**: `ecom-backend/src/test/java/com/jianquanwang/ecommerce/`  
**Run**: `mvn test`

---

### ecom-frontend (React Frontend)

**Configuration File**: `ecom-frontend/package.json`

#### Language & Runtime
**Language**: JavaScript (ES Module)  
**Framework**: React 19.0.0  
**Build Tool**: Vite 6.2.0  
**Package Manager**: npm

#### Dependencies
**Main**:
- React 19.0.0 & React DOM 19.0.0
- Redux Toolkit 2.6.1 & React Redux 9.2.0
- Material-UI 7.0.1
- Axios 1.8.4
- React Router DOM
- Tailwind CSS 4.1.2
- React Hot Toast 2.5.2
- React Icons 5.5.0

**Development**:
- Vite 6.2.0
- ESLint 9.21.0
- Tailwind CSS integration
- TypeScript types for React

#### Build & Installation
```bash
cd ecom-frontend
npm install
npm run dev
npm run build
npm run lint
```

**Entry Point**: `ecom-frontend/src/main.jsx`  
**Main Component**: `ecom-frontend/src/App.jsx`  
**Redux Store**: `src/store/reducers/store.js`  
**Backend URL**: Configured in `.env` as `VITE_BACK_END_URL=http://localhost:5000`

#### Build Configuration
**Vite Config**: `ecom-frontend/vite.config.js`
- React plugin with JSX transformation
- Tailwind CSS plugin
- Fast HMR support

---

## Development Workflow

### Start Application Stack
```bash
# Terminal 1: Backend
cd ecom-backend && mvn spring-boot:run    # Runs on port 5000

# Terminal 2: Frontend
cd ecom-frontend && npm run dev           # Runs on port 5173
```

### Database Setup
- PostgreSQL on localhost:5432
- Database: ecommerce
- Credentials in `application.properties`

### Production Build
```bash
cd ecom-backend && mvn clean install
cd ecom-frontend && npm run build
```
