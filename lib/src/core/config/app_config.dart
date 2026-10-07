/// Centralized API & Environment Configuration for Remember Me
/// Uses compile-time `const String.fromEnvironment` for safe, production-grade key injection.
/// Zero secrets are committed to version control.
class AppConfig {
  AppConfig._();

  // --- WEATHER CONFIGURATION ---
  // Default: Open-Meteo (zero-API-key, public, free)
  static const String openMeteoBaseUrl =
      'https://api.open-meteo.com/v1/forecast';
  static const String weatherApiKey = String.fromEnvironment(
    'WEATHER_API_KEY',
    defaultValue: '',
  );

  // --- GEOCODING & NOMINATIM ---
  // Default: Public OpenStreetMap Nominatim endpoint (rate-limited, with custom User-Agent)
  static const String nominatimBaseUrl = 'https://nominatim.openstreetmap.org';
  static const String geocodingApiKey = String.fromEnvironment(
    'GEOCODING_API_KEY',
    defaultValue: '',
  );

  // --- ROUTING ENGINE ---
  // Default: Public OSRM routing endpoint for walking/driving/cycling estimates
  static const String osrmBaseUrl = 'https://router.project-osrm.org';
  static const String routesApiKey = String.fromEnvironment(
    'ROUTES_API_KEY',
    defaultValue: '',
  );

  // --- MAPS & TILES ---
  // Default: OpenStreetMap Tile Server
  static const String osmTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String mapsApiKey = String.fromEnvironment(
    'MAPS_API_KEY',
    defaultValue: '',
  );

  // --- PLACES DISCOVERY ---
  // Default: Overpass API for local amenity searching (pharmacies, groceries, gyms)
  static const String overpassBaseUrl =
      'https://overpass-api.de/api/interpreter';
  static const String placesApiKey = String.fromEnvironment(
    'PLACES_API_KEY',
    defaultValue: '',
  );

  // --- OPTIONAL CLOUD AI / GEMINI ---
  static const String aiApiKey = String.fromEnvironment(
    'AI_API_KEY',
    defaultValue: '',
  );

  // --- SENTRY DSN ---
  static const String sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: '',
  );

  // Helper flags
  static bool get hasCustomWeatherKey => weatherApiKey.isNotEmpty;
  static bool get hasCustomMapsKey => mapsApiKey.isNotEmpty;
  static bool get hasCustomAiKey => aiApiKey.isNotEmpty;
}
