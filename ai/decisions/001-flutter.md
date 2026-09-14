# ADR-001: Use Flutter for Mobile Application

## Status

Accepted

## Date

2026-09-14

## Decision

The mobile banking application will be developed using Flutter and Dart.

## Context

The application needs to support mobile banking functionality for credit union
members.

The application should provide:

- Android support
- iOS support
- A single shared codebase
- Consistent UI
- Good performance
- Strong access to native device capabilities
- Long-term maintainability

## Reasons

Flutter was selected because:

- It provides a single codebase for Android and iOS.
- Dart provides strong typing and modern language features.
- Flutter has a mature ecosystem.
- UI can be built consistently across platforms.
- The development team has Flutter experience.
- Flutter is suitable for financial applications where predictable UI behavior
  is important.

## Consequences

### Positive

- Shared business logic
- Shared UI components
- Faster feature development
- Consistent design
- Easier maintenance

### Negative

- Some platform-specific functionality requires native integration.
- Flutter SDK upgrades must be managed carefully.

## Rules

New mobile features must use Flutter/Dart unless a documented architectural
decision changes this.

Native Android/iOS code should only be introduced when Flutter cannot provide
the required capability efficiently.

## Supersedes

None