# Flutter Architecture
Prefer `API Service → Model → Provider/State → Screen`. Widgets must not own authoritative business truth. Do not use UI-only authorization. Inspect consumers before changing shared components. Keep screen-specific requirements screen-scoped unless explicitly global.
