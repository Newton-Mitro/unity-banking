# Mobile Banking Design System

## 1. Design Goals

The application should feel:

- Professional
- Trustworthy
- Simple
- Fast
- Modern
- Mobile-first
- Accessible

The UI should prioritize financial information and common banking actions.

Avoid unnecessary decoration and excessive card-based layouts.

---

## 2. Design Principles

### Clarity

Important information must be immediately visible.

Examples:

- Available balance
- Account number
- Loan outstanding
- Next payment
- Transaction amount
- Transaction status

### Consistency

Use the same:

- Buttons
- Inputs
- Spacing
- Typography
- Status indicators
- Bottom sheets
- Dialogs
- Error messages

throughout the application.

### Progressive Disclosure

Do not display every piece of information at once.

Show important information first.

Allow users to open detailed information when needed.

---

# 3. Theme

The application supports:

- Light mode
- Dark mode

Do not use pure black as the dark-mode background.

Use theme-aware colors instead of hardcoded colors.

---

# 4. Color Tokens

## Primary

```text
primary
primaryContainer
onPrimary
onPrimaryContainer
positive
negative
warning
info
```

# 5. Typography
Use a consistent typography hierarchy.

```text
Display
Headline
Title
Body
Label
Caption
```
Financial amounts should have strong visual hierarchy.

# 6. Spacing
Use a consistent spacing scale.

```text
6. Spacing

Use a consistent spacing scale.
```
Prefer multiples of 4.
Avoid arbitrary spacing values unless necessary.

# 7. Border Radius
Use consistent radius tokens.

```text
small   = 8
medium  = 12
large   = 16
xlarge  = 20
```
Do not create random corner-radius values throughout the application.

# 8. Buttons
Primary actions should use the primary button.
Destructive actions must be visually distinguishable.

# 9. Forms
Inputs must provide:

- Label
- Placeholder where appropriate
- Validation message
- Error state
- Loading state where necessary
- 
Validation errors should appear close to the relevant field.
Do not rely only on SnackBars for form validation.

# 10. Account UI
An account summary should contain:

```text
Account Name
Account Number
Available Balance
Current Balance
Account Status
```

# 11. Transaction UI
Transactions should clearly communicate:

- Date
- Description
- Transaction type
- Amount
- Status

# 12. Loading
Prefer skeletons or localized loading indicators.
Avoid blocking the entire screen when only one component is loading.

# 14. Error States
Errors should be:

- Human-readable
- Actionable
- Non-technical

Do not expose:

- Stack traces
- API URLs
- SQL errors
- Internal exception names

# 15. Navigation
Use GoRouter.
Primary navigation should expose the most frequently used features.
Do not create excessive navigation levels.

# 16. Accessibility
The application should support:

- Dynamic text sizing
- Screen readers
- Sufficient contrast
- Semantic labels
- Large touch targets

Never communicate important information through color alone.

# 17. Security UX
Sensitive information should be masked by default where appropriate.

# 18. Confirmation UI
Financial operations must show a confirmation screen or bottom sheet before execution.

# 19. Responsive Behavior
The primary target is mobile.

Design for:
- Small Android phones
- Large Android phones
- iPhone-sized screens
- Tablets where practical

Avoid fixed widths.

Prefer:
- Expanded
- Flexible
- LayoutBuilder
- SafeArea
- SingleChildScrollView

# 20. Component Reuse
Before creating a new component:

- Search existing components.
- Reuse an existing component if possible.
- Extend an existing component if appropriate.
- Create a new component only when necessary.

Do not duplicate UI implementations.

