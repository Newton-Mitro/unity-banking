# Security Requirements

## 1. Purpose

This document defines the security requirements for the Credit Union Mobile Banking application.

Security is a mandatory architectural requirement.

The application handles sensitive information including:

* Member identity
* Account information
* Financial balances
* Transaction history
* Loans
* Deposits
* Authentication credentials
* Financial transactions

The AI coding agent must never weaken security to simplify implementation.

---

# 2. Security Principle

The backend is the final authority.

Flutter must be treated as an untrusted client.

Never trust values provided by the mobile application for:

* Account ownership
* Member identity
* Account balance
* Available balance
* Permissions
* Transaction limits
* Loan eligibility
* Interest calculations
* Financial authorization

---

# 3. Authentication

Supported authentication mechanisms may include:

```text
Mobile number
Password
OTP
Biometric authentication
Device authentication
```

Authentication must ultimately be validated by the backend.

Flutter must not implement its own authentication authority.

---

# 4. Authorization

Authentication answers:

```text
"Who is this user?"
```

Authorization answers:

```text
"What is this user allowed to do?"
```

Authorization must be enforced by the backend.

The Flutter application may hide unavailable functionality for UX purposes, but hiding a button is not a security mechanism.

---

# 5. Member Isolation

A member must only be able to access resources they are authorized to access.

Example:

```http
GET /accounts/123
```

The backend must verify that account `123` belongs to, or is accessible by, the authenticated member.

Never rely on Flutter to enforce this rule.

---

# 6. Token Storage

Sensitive authentication credentials must not be stored in plain text.

Do not store access tokens or refresh tokens in:

```text
SharedPreferences
Plain text files
Unencrypted databases
Application logs
```

Use platform secure storage.

Recommended Flutter package:

```text
flutter_secure_storage
```

Sensitive credentials should be stored using the strongest appropriate platform-backed mechanism available.

---

# 7. Passwords

The mobile application must never store the user's password.

Do not:

```dart
SharedPreferences.setString('password', password);
```

Do not write passwords to logs.

Do not include passwords in analytics events.

Do not send passwords to any service other than the designated authentication endpoint.

---

# 8. OTP

OTP values must:

* Be short-lived
* Be single-use
* Have expiration
* Have attempt limits
* Never be logged
* Never be persisted unnecessarily

Never display OTP values in application logs.

Do not send OTP values to analytics or crash-reporting systems.

---

# 9. PIN

PIN values must never be stored in plain text.

Never log PIN values.

Never send PIN values to analytics.

Never place PIN values in:

```text
SharedPreferences
Local files
Debug logs
Crash reports
```

If a PIN is required for authentication, it must be handled through an appropriately secured authentication mechanism.

---

# 10. Biometric Authentication

Biometric authentication is an additional authentication mechanism.

It must not be treated as a replacement for backend authorization.

Biometric authentication should unlock a locally protected authentication mechanism rather than expose the user's password.

The application must handle:

* Biometric unavailable
* Biometric failure
* Biometric lockout
* Device credential fallback where appropriate
* User disabling biometric login

---

# 11. Network Security

All production API communication must use HTTPS.

Never use:

```text
http://
```

for production financial APIs.

Do not disable TLS certificate validation.

Never use:

```dart
badCertificateCallback = (_, __, ___) => true;
```

in production.

---

# 12. Certificate Pinning

Certificate pinning may be used where required by the organization's security architecture.

If certificate pinning is implemented:

* Define a rotation strategy.
* Avoid hardcoding a single certificate without a recovery strategy.
* Test certificate rotation.
* Ensure development and production configurations are separated.

Do not introduce certificate pinning casually without considering operational consequences.

---

# 13. Sensitive Data Logging

Never log:

```text
Password
OTP
PIN
Access Token
Refresh Token
Full Account Number
CVV
Card Security Code
Personal Identification Documents
Sensitive Member Information
```

Avoid logging complete API request or response bodies in production.

---

# 14. Debug Logging

Debug logging must be disabled or appropriately restricted in production.

Avoid:

```dart
print(response.data);
```

for financial APIs.

If structured logging is used, sensitive fields must be redacted.

Example:

```text
account_number = ****4582
```

instead of:

```text
account_number = 123456789012
```

---

# 15. Financial Transactions

Financial operations require additional protection.

Examples:

```text
Money transfer
Loan repayment
Bill payment
Beneficiary creation
Beneficiary modification
Deposit operations
Withdrawal operations
```

These operations must be validated by the backend.

---

# 16. Transaction Confirmation

Before executing a financial transaction, the application should show the user:

```text
Source
Destination
Amount
Currency
Fees
Description
```

where applicable.

Example:

```text
Confirm Transfer

From:
Savings ****4582

To:
Rahim ****6789

Amount:
৳5,000

Fee:
৳10

Total:
৳5,010
```

The user must explicitly confirm the transaction.

---

# 17. Transaction Authentication

High-risk operations may require:

```text
OTP
PIN
Biometric authentication
Device authentication
MFA
```

The exact requirement is determined by backend policy.

Flutter must never bypass a backend authentication requirement.

---

# 18. Transaction Idempotency

Financial operations must be protected against duplicate execution.

For supported APIs, use an idempotency key.

Example:

```http
Idempotency-Key: 4f6b7e8c-7e2a-4d4f-9c72-123456789abc
```

If the client retries after a timeout, the backend must recognize the original operation.

---

# 19. Transaction Integrity

The client must not calculate the authoritative:

```text
Balance
Available Balance
Interest
Fees
Loan Outstanding
Transaction Limit
```

The backend must calculate or verify these values.

---

# 20. Local Storage

Only store information locally when required.

Avoid unnecessary storage of:

* Transaction history
* Account balances
* Personal information
* Loan information
* Sensitive documents

If sensitive data must be cached, appropriate encryption and access controls must be used.

---

# 21. Cache

Cached financial data must have an expiration strategy.

The application must clearly distinguish between:

```text
Cached information
```

and:

```text
Current server information
```

Do not present stale cached balances as authoritative current balances.

---

# 22. Screenshots and Screen Recording

Sensitive screens should consider platform-specific screenshot protection where appropriate.

Potentially sensitive screens include:

```text
Account Details
Transaction Details
OTP
PIN
Security Settings
Personal Information
```

Do not automatically block screenshots throughout the entire application unless required by product/security policy.

---

# 23. Clipboard

Avoid copying sensitive information to the clipboard.

Never automatically copy:

```text
OTP
PIN
Password
Access Token
Refresh Token
```

If account numbers are copied, consider whether masking or explicit user confirmation is appropriate.

---

# 24. Deep Links

Deep links must be validated.

Never trust IDs or parameters received through deep links.

Example:

```text
mybank://transaction/123
```

The application must still request authorized data from the backend.

Never assume that possession of a deep link grants access.

---

# 25. Push Notifications

Push notifications must not expose sensitive financial information unnecessarily.

Avoid:

```text
Your account 123456789 has received ৳50,000.
```

Prefer:

```text
A new transaction was posted to your account.
```

The user can open the application to see details.

---

# 26. Screens and Background State

When the application moves to the background, sensitive information should be protected where appropriate.

Consider:

* Secure screen overlays
* Application blur
* Re-authentication for sensitive operations

Do not unnecessarily expose account information in the application switcher.

---

# 27. Session Management

The application must handle:

```text
Access token expiration
Refresh token expiration
Logout
Session timeout
Account blocking
Credential revocation
Device change
```

When the session becomes invalid:

```text
Clear authentication state
        ↓
Clear sensitive local credentials
        ↓
Return to authentication
```

---

# 28. Automatic Logout

Automatic logout may be triggered by:

* Explicit user logout
* Session expiration
* Refresh token failure
* Account deactivation
* Security policy
* Remote session invalidation

---

# 29. API Errors

Never expose internal backend errors to users.

Bad:

```text
SQLSTATE[42S22]: Column not found...
```

Good:

```text
We couldn't complete your request.
Please try again later.
```

Technical errors may be logged securely for developers, provided sensitive data is removed.

---

# 30. Error Information

Do not reveal unnecessary information about:

* Account existence
* Member existence
* Authentication state
* Internal system structure
* Database structure
* Security configuration

Error messages should avoid enabling enumeration attacks.

---

# 31. Brute Force Protection

Authentication and sensitive operations must be protected against brute-force attempts.

The backend should enforce:

```text
Rate limiting
Attempt limits
Temporary lockouts
OTP expiration
MFA
```

Flutter should display appropriate user-friendly messages.

---

# 32. Rooted or Compromised Devices

The application may detect:

* Rooted Android devices
* Jailbroken iOS devices
* Debuggable environments
* Emulator usage where appropriate

Detection should be treated as a risk signal rather than the sole security mechanism.

Backend security must remain authoritative.

---

# 33. Environment Separation

Maintain separate environments:

```text
Development
Staging
Production
```

Do not allow development configuration to accidentally connect to production.

Do not commit production credentials.

---

# 34. Secrets

Never commit:

```text
API keys
Private keys
Passwords
Tokens
Production credentials
Signing secrets
Encryption keys
```

Do not hardcode secrets in Dart source code.

Do not commit secret `.env` files.

---

# 35. Application Configuration

Non-secret configuration may be environment-specific.

Examples:

```text
API Base URL
Environment Name
Feature Flags
Logging Level
Timeout Values
```

Secrets must be provided through secure deployment/configuration mechanisms.

---

# 36. Dependency Security

Before adding a package:

1. Check whether existing project dependencies already provide the functionality.
2. Verify package maintenance.
3. Check compatibility.
4. Check licensing.
5. Review security implications.
6. Avoid unnecessary dependencies.

The AI agent must not add a package simply because it is convenient.

---

# 37. WebView Security

If WebViews are required:

* Only load trusted URLs.
* Validate navigation.
* Avoid arbitrary URL loading.
* Do not expose unnecessary JavaScript bridges.
* Do not inject sensitive credentials into pages.
* Handle external navigation carefully.

Payment-related WebViews must follow the payment provider's security requirements.

---

# 38. File Security

Downloaded statements and documents may contain sensitive information.

The application should:

* Use secure HTTPS downloads.
* Avoid permanent public URLs.
* Use temporary download URLs where supported.
* Store files appropriately.
* Avoid exposing sensitive files unnecessarily.

---

# 39. Analytics

Analytics must not contain sensitive financial information.

Do not send:

```text
Account Number
Transaction Amount
Loan Balance
Member ID
OTP
PIN
Password
Access Token
```

Use anonymized or non-sensitive event information where analytics are required.

---

# 40. Crash Reporting

Crash reports must be reviewed for sensitive information.

Never attach:

```text
Passwords
Tokens
OTP
PIN
Financial request bodies
Financial response bodies
```

---

# 41. Code Obfuscation

Production builds should use appropriate Flutter/Dart release build protections.

Where appropriate:

```text
Release mode
Code obfuscation
Symbol management
```

Obfuscation is not a replacement for backend security.

---

# 42. Backend Authority

The following must always be enforced server-side:

```text
Authentication
Authorization
Account ownership
Transaction limits
Balance validation
Loan eligibility
Interest calculation
Fees
Transaction execution
MFA requirements
```

Client-side validation exists for user experience, not security.

---

# 43. AI Coding Agent Security Rules

The AI coding agent must follow these rules.

## Never

* Disable authentication to make a feature work.
* Disable authorization checks.
* Disable TLS verification.
* Hardcode credentials.
* Commit secrets.
* Log sensitive information.
* Bypass transaction confirmation.
* Trust client-provided balances.
* Trust client-provided permissions.
* Modify security controls without approval.
* Remove security checks without understanding their purpose.

## Before changing security-sensitive code

The agent must:

1. Identify the security boundary.
2. Explain the intended change.
3. Check existing security architecture.
4. Make the smallest safe change.
5. Add or update tests.
6. Report any remaining security concerns.

---

# 44. Security Testing

Security-sensitive features should include tests for:

```text
Unauthorized access
Unauthorized account access
Invalid token
Expired token
Invalid OTP
Expired OTP
Repeated OTP attempts
Insufficient balance
Transaction limit
Duplicate transaction
Invalid beneficiary
Session expiration
Logout
```

---

# 45. Financial Operation Testing

At minimum, test:

```text
Successful transaction
Insufficient balance
Invalid account
Blocked account
Invalid beneficiary
Exceeded transaction limit
Duplicate request
Network timeout
Server timeout
Authentication expiration
Repeated request
```

---

# 46. Security Incident Handling

If a security issue is discovered:

```text
STOP implementation
        ↓
Document the issue
        ↓
Identify affected boundary
        ↓
Assess impact
        ↓
Propose remediation
        ↓
Implement approved fix
        ↓
Add regression tests
```

The AI coding agent must not silently work around a security issue.

---

# 47. Security Priority

When requirements conflict, prioritize:

```text
1. Member security
2. Financial integrity
3. Authentication
4. Authorization
5. Data privacy
6. Regulatory requirements
7. Application correctness
8. User experience
9. Development convenience
```

Security must never be sacrificed for development speed.
