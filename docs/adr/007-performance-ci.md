# 007. Isolate-Based Trail Decimation, 60fps Optimization, and GitHub Actions CI

## Context
Parsing and rendering dense trail datasets (10,000+ coordinates) on the main thread risks UI jank and dropped frames during navigation and live map updates.

## Decision
1. Offload trail JSON deserialization and gap adjacency linking to background isolates via Flutter `compute(parseAndProcessTrail, ...)`.
2. Implement iterative RDP decimation (`TrailDecimator`) using an explicit stack in Dart to reduce polyline vertex counts without stack overflows.
3. Establish GitHub Actions CI (`.github/workflows/ci.yml`) enforcing zero `flutter analyze` warnings, 100% passing Flutter test suites, and passing Gradle unit tests on every push.

## Consequences
Guaranteed 60fps UI responsiveness during trail inspection and automated regression prevention across Dart and Kotlin layers.
