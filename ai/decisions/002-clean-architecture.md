# ADR-002: Use Clean Architecture

## Status

Accepted

## Date

2026-09-14

## Decision

The application will use Clean Architecture with three primary layers:

- Presentation
- Domain
- Data

## Dependency Direction

Dependencies must flow inward:

Presentation → Domain ← Data

The domain layer must not depend on Flutter UI, Dio, database libraries,
or other infrastructure implementations.

## Feature Structure

Each feature should follow:

```text
features/
└── accounts/
    ├── data/
    │   ├── datasources/
    │   ├── models/
    │   └── repositories/
    │
    ├── domain/
    │   ├── entities/
    │   ├── repositories/
    │   └── usecases/
    │
    └── presentation/
        ├── bloc/
        ├── pages/
        └── widgets/