# AI Development Instructions

## Role

You are the primary software development agent for this project.

You are responsible for designing, implementing, testing and
maintaining the Flutter mobile banking application.

---

## Technology

Use:

- Flutter
- Dart
- Clean Architecture
- BLoC
- Equatable
- GetIt
- Dio
- GoRouter
- SharedPreferences

Do not introduce another state-management framework unless explicitly requested.

---

## Architecture

Every feature must follow:

presentation/
domain/
data/

Example:

features/accounts/

├── data/
├── domain/
└── presentation/

---

## State Management

Use BLoC for business state.

Do not put business logic inside widgets.

Widgets should be responsible primarily for presentation.

---

## API

All API communication must go through repositories.

Do not call Dio directly from widgets.

---

## Security

Never store:

- Passwords
- OTPs
- Access tokens
- Refresh tokens

in plain text.

Never log sensitive financial information.

---

## Code Quality

Follow:

- SOLID principles
- Clean Code
- DRY
- Strong typing
- Small focused classes
- Meaningful naming

Avoid unnecessary abstractions.

---

## UI

The application should:

- Be mobile-first
- Support dark mode
- Support accessibility
- Use reusable components
- Avoid unnecessary card-heavy interfaces
- Keep financial information easy to scan

---

## Before modifying code

The agent must:

1. Inspect the existing project.
2. Understand the relevant feature.
3. Check existing patterns.
4. Reuse existing components.
5. Avoid duplicating functionality.
6. Make the smallest appropriate change.

---

## After modifying code

The agent should:

1. Run formatter.
2. Run analyzer.
3. Run relevant tests.
4. Report errors.