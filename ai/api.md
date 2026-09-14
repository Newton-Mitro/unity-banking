# API Specification

## 1. Base

Base URL:

```text
https://api.example.com/api
```

All requests use HTTPS.

## 2. Authentication

Login
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