# 005. Map Stack, Vector Tiles, Google View Toggle, and 150MB Tile Cache

## Context
Raw Google Maps tile scraping violates terms and risks API bans. The app requires free vector tiles with a Google-like aesthetic, ambient offline caching, and an opt-in native Google platform view.

## Decision
1. Adopt OpenFreeMap Bright vector style with MapLibre GL and styled OSM tiles as primary map, with 150MB ambient LRU tile caching.
2. Maintain native Google Maps platform view as an opt-in toggle (`_google`) when an API key is provided, mirroring polylines, gap dashes, and place markers identically.
3. Add persistent attribution (`© OpenStreetMap contributors · OpenFreeMap`) without blocking interactive controls.

## Consequences
Zero terms-of-service exposure, offline map usability during airplane mode, and identical visual parity across map providers.
