# Car AI

India's largest AI-powered automobile marketplace.

Discover cars, compare variants, submit inquiries, and receive the best dealer quotations.

## Architecture

```
car-ai/
├── app/                          # Flutter mobile application
│   ├── lib/
│   │   ├── core/                 # Shared infrastructure
│   │   │   ├── constants/        # API URLs, app constants
│   │   │   ├── errors/           # Exception hierarchy
│   │   │   ├── network/          # Dio HTTP client with JWT interceptor
│   │   │   ├── router/           # GoRouter with shell navigation
│   │   │   ├── theme/            # Material 3 light/dark themes
│   │   │   └── types/            # Shared enums (FuelType, Transmission)
│   │   └── features/             # Feature-first modules
│   │       ├── auth/             # Login, register, JWT management
│   │       ├── brands/           # Brand listing
│   │       ├── cars/             # Catalog, search, filter, detail
│   │       ├── compare/          # Side-by-side variant comparison
│   │       ├── home/             # Landing page with shortcuts
│   │       └── inquiries/        # Submit and track inquiries
│   └── test/                     # Unit and widget tests
│
├── backend/                      # FastAPI REST API
│   ├── app/
│   │   ├── api/v1/               # Versioned endpoints
│   │   ├── core/                 # Config, database, security, deps
│   │   ├── models/               # SQLAlchemy ORM models
│   │   ├── schemas/              # Pydantic request/response schemas
│   │   ├── services/             # Business logic layer
│   │   └── repositories/         # Data access layer
│   ├── tests/                    # Pytest integration tests
│   └── seed_data.py              # Development seed script
│
└── car-ai/                       # Engineering handbook (source of truth)
    ├── vision.md                 # Product vision & strategic direction
    ├── architecture.md           # Clean Architecture guidelines
    ├── flutter.md                # Flutter framework decisions
    ├── backend.md                # Backend technology choices
    ├── testing.md                # 90% coverage requirement
    ├── security.md               # OWASP, RBAC, secrets management
    └── ...                       # Coding, UI, git, workflow standards
```

## Tech Stack

| Layer    | Technology                                     |
| -------- | ---------------------------------------------- |
| Frontend | Flutter 3.44, Riverpod, GoRouter, Freezed      |
| Backend  | FastAPI, SQLAlchemy 2.0, Alembic               |
| Database | PostgreSQL (async via asyncpg)                  |
| Cache    | Redis                                          |
| Auth     | JWT (access + refresh tokens), bcrypt           |

## Features

- **Car Search & Browse** — Filter by brand, body type, fuel, transmission, price
- **Variant Comparison** — Compare specifications side by side
- **Car Detail** — Full specs, variant list, colors, pricing
- **Inquiry System** — Submit dealer inquiries, track status
- **User Authentication** — Register, login, secure session management
- **Responsive UI** — Material 3 with automatic dark mode support

## Quick Start

### Backend

```bash
cd backend
pip install -r requirements.txt
cp .env.example .env          # Configure your database URL
alembic upgrade head           # Run migrations
python seed_data.py            # Load sample data
uvicorn app.main:app --reload  # http://localhost:8000/docs
```

### Flutter

```bash
cd app
flutter pub get
dart run build_runner build    # Generate Freezed + JSON code
flutter run                    # Launch on connected device
```

## API Endpoints

| Method | Endpoint                    | Auth     | Description            |
| ------ | --------------------------- | -------- | ---------------------- |
| POST   | `/api/v1/auth/register`     | No       | Create account         |
| POST   | `/api/v1/auth/login`        | No       | Sign in                |
| GET    | `/api/v1/brands/`           | No       | List all brands        |
| GET    | `/api/v1/cars/`             | No       | List cars (paginated)  |
| GET    | `/api/v1/cars/:id`          | No       | Car details + variants |
| POST   | `/api/v1/inquiries/`        | JWT      | Submit inquiry         |
| GET    | `/api/v1/inquiries/`        | JWT      | List user inquiries    |
| GET    | `/health`                   | No       | Health check           |

## Testing

```bash
# Backend
cd backend && pytest --cov=app

# Flutter
cd app && flutter test --coverage
```

Minimum coverage: **90%**

## Security

- Passwords hashed with bcrypt
- JWT tokens stored in platform secure storage (Keychain/Keystore)
- All inputs validated via Pydantic (backend) and form validators (Flutter)
- CORS and trusted host middleware configured
- User roles (customer/admin) ready for RBAC
- `.env` files excluded from version control

## Project Standards

This project follows the engineering handbook in `car-ai/`. Key principles:

- **Clean Architecture** — Presentation, Application, Domain, Data layers
- **Feature-first** — Self-contained modules, independently testable
- **No business logic in widgets** — All logic in providers/services
- **Small methods** — Max 50 lines per function, 150 per widget
- **Immutable models** — Freezed with JSON serialization
- **Composition over inheritance** — Reusable widgets throughout

## License

Private — All rights reserved.
