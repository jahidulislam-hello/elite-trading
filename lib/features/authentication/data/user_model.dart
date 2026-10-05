/// Dart model matching the backend [IUser] interface.
///
/// Backend source: backend/src/modules/basic_modules/user/user.interface.ts
class UserModel {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? name;
  final String email;
  final String? phone;
  final String? address;
  final UserImage? image;
  final String role;
  final String? status;
  final bool isDeleted;
  final String subscriptionStatus;
  final String? subscriptionType;
  final DateTime? subscriptionEndDate;
  final DateTime? freeTrialEndDate;
  final bool hasUsedFreeAccess;

  const UserModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.name,
    required this.email,
    this.phone,
    this.address,
    this.image,
    required this.role,
    this.status,
    required this.isDeleted,
    required this.subscriptionStatus,
    this.subscriptionType,
    this.subscriptionEndDate,
    this.freeTrialEndDate,
    required this.hasUsedFreeAccess,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      image: json['image'] is Map<String, dynamic>
          ? UserImage.fromJson(json['image'] as Map<String, dynamic>)
          : (json['image'] is String && (json['image'] as String).isNotEmpty)
              ? UserImage(
                  publicFileURL: json['image'] as String,
                  path: json['image'] as String,
                )
              : null,
      role: json['role'] as String? ?? 'user',
      status: json['status'] as String?,
      isDeleted: json['isDeleted'] as bool? ?? false,
      subscriptionStatus: json['subscriptionStatus'] as String? ?? 'none',
      subscriptionType: json['subscriptionType'] as String?,
      subscriptionEndDate: json['subscriptionEndDate'] != null
          ? DateTime.tryParse(json['subscriptionEndDate'].toString())
          : null,
      freeTrialEndDate: json['freeTrialEndDate'] != null
          ? DateTime.tryParse(json['freeTrialEndDate'].toString())
          : null,
      hasUsedFreeAccess: json['hasUsedFreeAccess'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'image': image?.toJson(),
      'role': role,
      'status': status,
      'isDeleted': isDeleted,
      'subscriptionStatus': subscriptionStatus,
      'subscriptionType': subscriptionType,
      'subscriptionEndDate': subscriptionEndDate?.toIso8601String(),
      'freeTrialEndDate': freeTrialEndDate?.toIso8601String(),
      'hasUsedFreeAccess': hasUsedFreeAccess,
    };
  }

  /// Display name helper – returns full name, or email prefix as fallback.
  String get displayName {
    if (name != null && name!.isNotEmpty) return name!;
    if (firstName != null && firstName!.isNotEmpty) {
      return '${firstName!} ${lastName ?? ''}'.trim();
    }
    return email.split('@').first;
  }

  /// Whether the user currently has active access (not expired).
  bool get isSubscriptionActive {
    if (role.toLowerCase() == 'admin') return true;
    final now = DateTime.now();
    final sStatus = subscriptionStatus.toLowerCase();
    if (sStatus == 'active') {
      if (subscriptionEndDate == null) return true;
      return subscriptionEndDate!.isAfter(now);
    }
    if (sStatus == 'trial') {
      final end = freeTrialEndDate ?? subscriptionEndDate;
      if (end == null) return true;
      return end.isAfter(now);
    }
    return false;
  }

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? name,
    String? email,
    String? phone,
    String? address,
    UserImage? image,
    String? role,
    String? status,
    bool? isDeleted,
    String? subscriptionStatus,
    String? subscriptionType,
    DateTime? subscriptionEndDate,
    DateTime? freeTrialEndDate,
    bool? hasUsedFreeAccess,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      image: image ?? this.image,
      role: role ?? this.role,
      status: status ?? this.status,
      isDeleted: isDeleted ?? this.isDeleted,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      subscriptionEndDate: subscriptionEndDate ?? this.subscriptionEndDate,
      freeTrialEndDate: freeTrialEndDate ?? this.freeTrialEndDate,
      hasUsedFreeAccess: hasUsedFreeAccess ?? this.hasUsedFreeAccess,
    );
  }
}

class UserImage {
  final String publicFileURL;
  final String path;

  const UserImage({required this.publicFileURL, required this.path});

  factory UserImage.fromJson(Map<String, dynamic> json) {
    return UserImage(
      publicFileURL: json['publicFileURL'] as String? ?? '',
      path: json['path'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'publicFileURL': publicFileURL,
        'path': path,
      };
}
