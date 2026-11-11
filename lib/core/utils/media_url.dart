import 'package:elite_trading/core/constants/api_constants.dart';

/// Turns a relative media path (e.g. `/images/foo.jpg`) into an absolute URL.
///
/// Absolute `http`/`https` URLs are returned unchanged. Null or blank input
/// yields an empty string.
String resolveMediaUrl(String? path) {
  final value = path?.trim() ?? '';
  if (value.isEmpty) return '';

  final lower = value.toLowerCase();
  if (lower.startsWith('http://') || lower.startsWith('https://')) {
    return value;
  }

  final base = ApiConstants.baseUrl.replaceAll(RegExp(r'/$'), '');
  final relative = value.startsWith('/') ? value : '/$value';
  return '$base$relative';
}
