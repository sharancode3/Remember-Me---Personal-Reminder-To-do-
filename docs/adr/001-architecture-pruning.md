# 001. Prune Dormant Architecture A in Favor of Architecture B

## Context
The repository contained two divergent architectures: a dormant 4-engine Neo-Brutalist planner (Architecture A) and the active "Daily App" (Architecture B). Architecture A caused 62 analyzer warnings and heavy dead-code baggage.

## Decision
Branch `archive/arch-a` preserves Architecture A. On `main`, delete all dormant engines, unused schemas, and Neo-Brutalist screens. Retain `natural_language_parser.dart`, `reminder_recurrence.dart`, and `backup_service.dart`.

## Consequences
Builds and analyzer pass cleanly. Mental overhead is eliminated. Production focus is exclusively on the 4 pillars of the Daily App.
