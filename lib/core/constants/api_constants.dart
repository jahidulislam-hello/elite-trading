class ApiConstants {
  ApiConstants._();

  /// Backend base URL.
  /// • Android emulator  → http://10.0.2.2:2002
  /// • iOS simulator     → http://127.0.0.1:2002
  /// • Real device (LAN) → http://192.168.x.x:2002
  /// • Production        → https://your-domain.com
  static const String baseUrl = 'https://sabbir2002.ssh.bd';

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
