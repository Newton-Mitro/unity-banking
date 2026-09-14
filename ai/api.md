# API Specification

## 1. Purpose

This document defines the API integration contract for the Credit Union Mobile Banking application.

The Flutter application communicates with the backend through secure REST APIs.

The API is the source of truth for:

* Authentication
* Member information
* Accounts
* Transactions
* Beneficiaries
* Money transfers
* Loans
* Deposits
* Payments
* Statements
* Notifications
* Profile management

The Flutter application must never implement financial business rules independently when those rules belong to the backend.

---

# 2. API Architecture

The application follows this communication flow:

```text
Flutter UI
    ↓
BLoC
    ↓
Use Case
    ↓
Repository
    ↓
Remote Data Source
    ↓
API Client
    ↓
REST API
    ↓
Backend Business Logic
    ↓
Database / Core Banking
```

The UI must never communicate directly with the API.

---

# 3. Base URL

Development:

```text
https://api-dev.example.com/api
```

Staging:

```text
https://api-staging.example.com/api
```

Production:

```text
https://api.example.com/api
```

The base URL must be configurable by environment.

Do not hardcode production URLs throughout the application.

---

# 4. HTTP Client

The application uses:

```text
Dio
```

The API client must be centralized.

Recommended structure:

```text
lib/core/network/

├── api_client.dart
├── api_endpoints.dart
├── api_interceptor.dart
├── api_response.dart
└── api_exception.dart
```

Do not instantiate `Dio` directly inside:

* Widgets
* Pages
* BLoCs
* Cubits
* Use Cases
* Entities
* Models

---

# 5. HTTP Methods

Use standard HTTP methods.

```text
GET       Retrieve resources
POST      Create or execute operations
PUT       Replace a resource
PATCH     Partially update a resource
DELETE    Delete a resource
```

Financial operations should generally use `POST`.

Example:

```http
POST /transfers
```

---

# 6. Authentication

## Login

```http
POST /auth/login
```

Request:

```json
{
  "mobile": "01700000000",
  "password": "********"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "requires_otp": true,
    "verification_id": "verification-id"
  }
}
```

The backend determines whether additional authentication is required.

---

# 7. OTP Verification

```http
POST /auth/verify-otp
```

Request:

```json
{
  "verification_id": "verification-id",
  "otp": "123456"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "access_token": "access-token",
    "refresh_token": "refresh-token",
    "expires_in": 900,
    "user": {
      "id": 1001,
      "member_number": "M-10001",
      "name": "John Doe"
    }
  }
}
```

OTP values must never be logged.

Tokens must never be logged.

---

# 8. Refresh Token

```http
POST /auth/refresh
```

Request:

```json
{
  "refresh_token": "refresh-token"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "access_token": "new-access-token",
    "expires_in": 900
  }
}
```

The refresh token must be stored using secure platform storage.

---

# 9. Logout

```http
POST /auth/logout
```

The backend should invalidate the appropriate session/token.

The Flutter application must clear local authentication state after successful logout.

---

# 10. Current Member

```http
GET /auth/me
```

Response:

```json
{
  "success": true,
  "data": {
    "id": 1001,
    "member_number": "M-10001",
    "name": "John Doe",
    "mobile": "01700000000",
    "email": "member@example.com",
    "status": "active"
  }
}
```

The member returned by this endpoint is determined by the authenticated session.

The client must not provide a member ID to retrieve the current user's identity.

---

# 11. Accounts

## List Accounts

```http
GET /accounts
```

Response:

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "account_number": "****4582",
      "name": "Savings Account",
      "type": "savings",
      "balance": 52450.00,
      "available_balance": 52450.00,
      "currency": "BDT",
      "status": "active"
    }
  ]
}
```

---

## Account Details

```http
GET /accounts/{accountId}
```

Example:

```http
GET /accounts/1
```

The backend must verify that the authenticated member has access to the account.

---

# 12. Account Balance

```http
GET /accounts/{accountId}/balance
```

Response:

```json
{
  "success": true,
  "data": {
    "account_id": 1,
    "balance": 52450.00,
    "available_balance": 52450.00,
    "currency": "BDT"
  }
}
```

The Flutter application must not calculate the authoritative balance from locally cached transactions.

The backend is the source of truth.

---

# 13. Transactions

## List Transactions

```http
GET /accounts/{accountId}/transactions
```

Supported query parameters:

```text
from
to
type
status
page
per_page
search
```

Example:

```http
GET /accounts/1/transactions?from=2026-09-01&to=2026-09-14&page=1&per_page=20
```

Response:

```json
{
  "success": true,
  "data": [
    {
      "id": 10001,
      "reference": "TRX-20260914-00001",
      "type": "debit",
      "amount": 2500.00,
      "currency": "BDT",
      "description": "Electricity Bill",
      "status": "completed",
      "created_at": "2026-09-14T10:30:00+06:00"
    }
  ],
  "meta": {
    "current_page": 1,
    "per_page": 20,
    "total": 1
  }
}
```

---

# 14. Transaction Details

```http
GET /transactions/{transactionId}
```

Response:

```json
{
  "success": true,
  "data": {
    "id": 10001,
    "reference": "TRX-20260914-00001",
    "type": "debit",
    "amount": 2500.00,
    "currency": "BDT",
    "description": "Electricity Bill",
    "status": "completed",
    "created_at": "2026-09-14T10:30:00+06:00"
  }
}
```

---

# 15. Beneficiaries

## List Beneficiaries

```http
GET /beneficiaries
```

---

## Add Beneficiary

```http
POST /beneficiaries
```

Request:

```json
{
  "account_number": "123456789",
  "name": "Rahim",
  "nickname": "Brother"
}
```

The backend must validate the beneficiary.

Additional authentication may be required.

---

## Verify Beneficiary

```http
POST /beneficiaries/verify
```

Request:

```json
{
  "account_number": "123456789"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "valid": true,
    "name": "Rahim",
    "masked_account_number": "****6789"
  }
}
```

---

## Delete Beneficiary

```http
DELETE /beneficiaries/{beneficiaryId}
```

---

# 16. Money Transfer

Money transfer consists of separate validation and execution steps.

```text
Validate
   ↓
Display Confirmation
   ↓
Authenticate
   ↓
Execute
```

---

## Validate Transfer

```http
POST /transfers/validate
```

Request:

```json
{
  "source_account_id": 1,
  "beneficiary_id": 20,
  "amount": 5000.00,
  "description": "Personal transfer"
}
```

The backend must validate:

* Source account ownership
* Account status
* Beneficiary status
* Available balance
* Minimum amount
* Maximum amount
* Daily transaction limit
* Member eligibility
* Transfer restrictions

Response:

```json
{
  "success": true,
  "data": {
    "valid": true,
    "source_account": "****4582",
    "beneficiary": "Rahim",
    "amount": 5000.00,
    "currency": "BDT",
    "requires_mfa": true
  }
}
```

---

## Create Transfer

```http
POST /transfers
```

Request:

```json
{
  "validation_token": "validation-token",
  "source_account_id": 1,
  "beneficiary_id": 20,
  "amount": 5000.00,
  "description": "Personal transfer",
  "authentication_code": "******"
}
```

The exact authentication mechanism is determined by the backend.

Response:

```json
{
  "success": true,
  "data": {
    "transaction_id": 50001,
    "reference": "TRX-20260914-00001",
    "status": "completed",
    "amount": 5000.00,
    "currency": "BDT"
  }
}
```

---

# 17. Idempotency

Financial operations must support idempotency.

The Flutter application should generate a unique idempotency key for operations where required.

Example HTTP header:

```http
Idempotency-Key: 4f6b7e8c-7e2a-4d4f-9c72-123456789abc
```

If the same request is retried because of a network failure, the backend must not create duplicate transactions.

---

# 18. Loans

## List Loans

```http
GET /loans
```

Response:

```json
{
  "success": true,
  "data": [
    {
      "id": 10,
      "loan_number": "LN-2026-00125",
      "product": "General Loan",
      "principal": 500000.00,
      "outstanding": 327500.00,
      "interest_rate": 10.5,
      "next_due_date": "2026-10-05",
      "next_due_amount": 18500.00,
      "status": "active"
    }
  ]
}
```

---

## Loan Details

```http
GET /loans/{loanId}
```

---

## Loan Repayment Schedule

```http
GET /loans/{loanId}/schedule
```

---

## Validate Loan Payment

```http
POST /loans/{loanId}/payments/validate
```

Request:

```json
{
  "amount": 18500.00,
  "source_account_id": 1
}
```

---

## Make Loan Payment

```http
POST /loans/{loanId}/payments
```

Request:

```json
{
  "validation_token": "validation-token",
  "source_account_id": 1,
  "amount": 18500.00
}
```

The backend must perform all financial validation.

---

# 19. Deposits

## List Deposits

```http
GET /deposits
```

Supported types may include:

```text
savings
share
fixed_deposit
recurring_deposit
```

---

## Deposit Details

```http
GET /deposits/{depositId}
```

---

# 20. Bill Payments

## Supported Billers

```http
GET /billers
```

---

## Validate Bill Payment

```http
POST /bill-payments/validate
```

Request:

```json
{
  "biller_id": 10,
  "account_id": 1,
  "customer_number": "123456789",
  "amount": 2500.00
}
```

---

## Execute Bill Payment

```http
POST /bill-payments
```

The backend must validate the bill payment before execution.

---

# 21. Statements

## Generate Statement

```http
POST /statements/generate
```

Request:

```json
{
  "account_id": 1,
  "from": "2026-08-01",
  "to": "2026-08-31",
  "format": "pdf"
}
```

Supported formats:

```text
pdf
csv
```

---

## Statement Download

The API may return a secure temporary download URL.

The URL must:

* Be HTTPS
* Be short-lived
* Require appropriate authorization where applicable
* Not expose permanent credentials

---

# 22. Notifications

## List Notifications

```http
GET /notifications
```

---

## Mark Notification as Read

```http
PATCH /notifications/{notificationId}/read
```

---

# 23. Profile

## Get Profile

```http
GET /profile
```

## Update Profile

```http
PATCH /profile
```

Only fields explicitly allowed by the backend may be changed.

---

# 24. Pagination

Paginated endpoints should return:

```json
{
  "data": [],
  "meta": {
    "current_page": 1,
    "per_page": 20,
    "total": 100,
    "last_page": 5
  }
}
```

The Flutter application should support pagination for large datasets.

---

# 25. API Response Format

Successful response:

```json
{
  "success": true,
  "data": {}
}
```

Successful paginated response:

```json
{
  "success": true,
  "data": [],
  "meta": {}
}
```

Failed response:

```json
{
  "success": false,
  "message": "Unable to complete the request.",
  "errors": {}
}
```

---

# 26. HTTP Status Codes

Use standard HTTP status codes.

```text
200 OK
201 Created
204 No Content

400 Bad Request
401 Unauthenticated
403 Forbidden
404 Not Found
409 Conflict
422 Validation Error
429 Too Many Requests

500 Internal Server Error
502 Bad Gateway
503 Service Unavailable
```

---

# 27. Authentication Headers

Authenticated requests use:

```http
Authorization: Bearer {access_token}
```

The API client is responsible for adding the authorization header.

Do not manually add authorization headers in individual screens.

---

# 28. Timeout

The API client should define:

```text
connect timeout
receive timeout
send timeout
```

Timeout values must be centralized and configurable.

---

# 29. Network Failure Handling

The application should distinguish between:

```text
No Internet
Connection Timeout
Server Unavailable
Authentication Expired
Validation Error
Permission Error
Unknown Server Error
```

Do not show raw Dio exceptions to users.

---

# 30. Authentication Expiration

When the API returns:

```http
401 Unauthorized
```

the API client should attempt token refresh when appropriate.

If token refresh fails:

```text
Clear authentication state
    ↓
Navigate to Login
```

Do not repeatedly retry an invalid authentication session.

---

# 31. API Models

API response models belong in the data layer.

Example:

```text
AccountModel
TransactionModel
LoanModel
BeneficiaryModel
TransferModel
```

Domain entities must remain independent from API response models.

---

# 32. Repository Rules

Repositories expose domain-oriented operations.

Example:

```dart
abstract class AccountRepository {
  Future<Result<List<Account>>> getAccounts();

  Future<Result<AccountBalance>> getBalance(
    AccountId accountId,
  );
}
```

The domain layer must not depend directly on Dio.

---

# 33. API Endpoint Rules

All endpoints must be defined centrally.

Example:

```dart
class ApiEndpoints {
  static const login = '/auth/login';
  static const accounts = '/accounts';
  static const beneficiaries = '/beneficiaries';
  static const transfers = '/transfers';
}
```

Do not scatter endpoint strings throughout the project.

---

# 34. Financial Data Rules

The Flutter application must never be the authoritative source for:

* Account balance
* Available balance
* Loan outstanding
* Interest calculation
* Transaction limits
* Transfer eligibility
* Loan repayment calculation

These values must come from the backend.

---

# 35. API Development Rule

When implementing a new feature:

1. Read this document.
2. Check whether an endpoint already exists.
3. Reuse existing API patterns.
4. Add models.
5. Add remote data source methods.
6. Add repository implementation.
7. Add use case.
8. Connect to BLoC.
9. Add UI.
10. Add tests.

Do not bypass the architecture.
