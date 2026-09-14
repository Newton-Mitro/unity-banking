# Domain Model

## Member

Fields:

- id
- member_number
- name
- mobile
- email
- status

## Account

Fields:

- id
- member_id
- account_number
- account_type
- balance
- available_balance
- status

## Transaction

Fields:

- id
- account_id
- transaction_number
- type
- amount
- balance_after
- description
- status
- created_at

## Loan

Fields:

- id
- member_id
- loan_number
- principal
- interest_rate
- outstanding
- next_due_date
- next_due_amount
- status