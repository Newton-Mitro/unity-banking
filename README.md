"Implement .ai/tasks/authentication.md."


8. The commands you give the agent

You don't need complicated commands.

Start a feature
```agsl
Read .ai/instructions.md and .ai/tasks/accounts.md.

Inspect the existing project first.

Implement the accounts feature following the project's
architecture and coding conventions.

Do not modify unrelated features.
```
Fix something
```agsl
Investigate why the login BLoC is not emitting Authenticated.

Read the relevant AI instructions and inspect the existing
authentication implementation.

Fix the root cause.

Run analyzer and relevant tests afterward.
```

Build a screen
```agsl
Implement the DashboardPage according to .ai/features.md
and .ai/design.md.

Reuse existing components.

Do not introduce a new UI library.
```

Refactor
```agsl
Review the accounts feature against .ai/architecture.md.

Identify violations of Clean Architecture.

Refactor only where necessary.

Do not change application behavior.
```

12. Your actual prompt can then be tiny
13. ```agsl
Read the .ai project documentation first.

I want to implement the account transaction history feature.

Inspect the existing codebase and identify the patterns used by
the authentication and accounts features.

Create a task plan first.

Then implement the feature.

Run formatter, analyzer and tests when finished.
```