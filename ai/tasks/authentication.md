# Task: Authentication

## Objective

Implement mobile member authentication.

## Requirements

- Mobile number input
- Password input
- Login API
- OTP verification
- Secure session storage
- Logout
- Authentication state

## API

POST /api/auth/login

POST /api/auth/verify-otp

POST /api/auth/logout

## Expected screens

- LoginPage
- OtpVerificationPage

## Expected BLoC

AuthBloc

Events:

- LoginRequested
- OtpVerificationRequested
- LogoutRequested

States:

- AuthInitial
- AuthLoading
- Authenticated
- Unauthenticated
- AuthError

## Acceptance criteria

- User can login
- Invalid credentials show an error
- OTP can be verified
- Authenticated user reaches dashboard
- Logout clears authentication state