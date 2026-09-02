/// Normalizes the `access` field returned by the app endpoints.
///
/// The backend sends the full [UserAccessContext] object
/// (backend/src/utils/subscriptionAccess.ts), e.g.
/// `{ plan, hasActiveAccess, canViewTodaySignals, ... }`, while the UI only
/// needs a simple level to decide between the full and locked states.
String parseAccessLevel(dynamic raw) {
  if (raw is String) {
    return raw.isEmpty ? 'full' : raw;
  }
  if (raw is Map) {
    return raw['hasActiveAccess'] == true ? 'full' : 'limited';
  }
  return 'full';
}
