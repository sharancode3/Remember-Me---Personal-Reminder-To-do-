# Maps And Phone Access

## Free Default

No subscription, API key, billing account, cloud AI, or paid service is required. OpenStreetMap supplies the street background. Reminders, focus state, places, and trails stay on-device. The active daily app does not use the old weather, health, routing, geocoding, or cloud-AI planning modules.

OSM public tiles need internet and are not an unlimited offline-download service. Attribution stays visible; bulk download/prefetch is not implemented. [Tile usage policy](https://operations.osmfoundation.org/policies/tiles/).

## Optional Google Maps

The basic Android Maps SDK map-display SKU currently has unlimited no-cost usage. Google requires a billing-enabled Cloud project and API key. If linking billing is unacceptable, keep OpenStreetMap; all daily features still work. No billing account was created or enabled by this work.

- [Maps SDK usage and billing](https://developers.google.com/maps/documentation/android-sdk/usage-and-billing)
- [Current Google pricing](https://developers.google.com/maps/billing-and-pricing/pricing)

Only Maps SDK for Android is integrated. Paid Roads, Places, Routes, Geocoding, Street View, and Map Tiles APIs are not used. Google is an alternative basemap with app-owned route/pins, not a Google tile overlay on OSM.

For an existing restricted Android key, add `maps.apiKey=YOUR_KEY` to ignored `android/local.properties`, or set `REMEMBER_ME_GOOGLE_MAPS_KEY` in the build environment. Rebuild the APK and select Google in Trail settings. The key is an Android client credential embedded in the APK, not a server secret. Restrict it in Cloud Console to Maps SDK for Android, package `com.example.remember_me`, and the signing certificate SHA-1. Current local builds use a debug certificate; configure release signing before distribution. Keep credentials out of source control.

## Android Permissions

- Notifications: requested when saving a reminder/arrival alert. Exact alarm access is requested for time reminders; denying it permits delayed delivery.
- Location: explicit recording consent and precise permission. A foreground notification remains while recording. Arrival alerts run only while this service runs. Reopen after reboot/force-stop.
- Accessibility: opt-in package-change detection and blocking overlays. No window contents or typed text are retrieved. Home, Settings, and Phone are safety exceptions. [Android AccessibilityService](https://developer.android.com/reference/android/accessibilityservice/AccessibilityService).
- Widget: launcher confirmation. Focus timer overlays use approved Accessibility, not hidden screen capture.

GPS filtering is a deterministic local estimator, not perfect GPS or an AI model. There are no cloud inference costs. See README for limitations and device checks.
