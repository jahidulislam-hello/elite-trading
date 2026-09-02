import '../../core/constants/api_endpoints.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../../core/services/api_service.dart';

enum ManagementType { privacy, terms, about }

extension ManagementTypeX on ManagementType {
  String get path {
    switch (this) {
      case ManagementType.privacy:
        return ApiEndpoints.managementPrivacy;
      case ManagementType.terms:
        return ApiEndpoints.managementTerms;
      case ManagementType.about:
        return ApiEndpoints.managementAbout;
    }
  }

  String get title {
    switch (this) {
      case ManagementType.privacy:
        return 'Privacy Policy';
      case ManagementType.terms:
        return 'Terms & Conditions';
      case ManagementType.about:
        return 'About Elite Trading';
    }
  }
}

/// Fetches public management content (privacy / terms / about).
class ManagementService {
  final ApiService _api;

  ManagementService({ApiService? apiService})
      : _api = apiService ?? ApiService();

  /// GET /api/v1/management/:type
  /// Returns the HTML `description` string from `data`.
  Future<String> getDescription(ManagementType type) async {
    final response = await _api.get(type.path);
    _assertSuccess(response.data, 'Failed to load ${type.title}.');

    final data = response.data['data'];
    if (data is Map<String, dynamic>) {
      final description = data['description'] as String?;
      if (description != null && description.trim().isNotEmpty) {
        return description;
      }
    }

    throw ServerException('${type.title} content is empty.', null);
  }

  void _assertSuccess(dynamic responseData, String fallback) {
    if (responseData is Map<String, dynamic>) {
      if (responseData['success'] == false) {
        final msg = responseData['message'] as String?;
        throw ServerException(
            msg?.isNotEmpty == true ? msg! : fallback, null);
      }
    }
  }
}
