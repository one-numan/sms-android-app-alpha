# Offline and Cache
SQLite/local cache is a client representation, not a competing source of truth. Backend is authoritative when connected. Cache must have freshness semantics, safe synchronization, session isolation and logout protection. Never silently present stale protected data as current.
