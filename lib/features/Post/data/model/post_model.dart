/// Post models matching the backend formatter output from:
///   backend/src/modules/basic_modules/post/post.formatter.ts
///   backend/src/modules/basic_modules/post/post.interface.ts

// ─── Post Model ───────────────────────────────────────────────────────────

class PostModel {
  final String id;
  final String title;
  final String body;
  final String category; // Market Update | Education | News | Announcement
  final String? coverImage; // URL from backend (null if no image)
  final int likes;
  final int commentsCount;
  final int sharesCount;
  final String status; // Published | Draft | Scheduled
  final DateTime? publishedAt;
  final String timeAgo;
  final String publishedLabel;
  // User-specific
  final bool isLiked;
  final PostAuthor author;

  const PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    this.coverImage,
    required this.likes,
    required this.commentsCount,
    required this.sharesCount,
    required this.status,
    this.publishedAt,
    required this.timeAgo,
    required this.publishedLabel,
    this.isLiked = false,
    this.author = const PostAuthor(),
  });

  PostModel copyWith({
    int? likes,
    int? commentsCount,
    int? sharesCount,
    bool? isLiked,
  }) {
    return PostModel(
      id: id,
      title: title,
      body: body,
      category: category,
      coverImage: coverImage,
      likes: likes ?? this.likes,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      status: status,
      publishedAt: publishedAt,
      timeAgo: timeAgo,
      publishedLabel: publishedLabel,
      isLiked: isLiked ?? this.isLiked,
      author: author,
    );
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      category: json['category'] as String? ?? '',
      coverImage: (json['coverImage'] as String?)?.isNotEmpty == true
          ? json['coverImage'] as String
          : null,
      likes: (json['likesCount'] as num?)?.toInt() ??
          (json['likes'] as num?)?.toInt() ??
          0,
      commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
      sharesCount: (json['sharesCount'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'Published',
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'].toString())
          : null,
      timeAgo: json['timeAgo'] as String? ?? '',
      publishedLabel: json['publishedLabel'] as String? ??
          (json['publishedAt'] != null
              ? _formatDate(
                  DateTime.tryParse(json['publishedAt'].toString()))
              : ''),
      isLiked: json['isLikedByMe'] as bool? ??
          json['isLiked'] as bool? ??
          false,
      author: PostAuthor.fromJson(
          json['author'] as Map<String, dynamic>?),
    );
  }

  static String _formatDate(DateTime? d) {
    if (d == null) return '';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}';
  }

  /// Truncated body for the feed card (max 120 chars)
  String get excerpt {
    if (body.length <= 120) return body;
    return '${body.substring(0, 120)}...';
  }
}

class PostAuthor {
  final String name;
  final String? avatarUrl;
  final String initials;
  final bool isVerified;

  const PostAuthor({
    this.name = 'Elite Trading',
    this.avatarUrl,
    this.initials = 'ET',
    this.isVerified = true,
  });

  factory PostAuthor.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PostAuthor();
    final avatar = json['avatarUrl'] as String?;
    return PostAuthor(
      name: json['name'] as String? ?? 'Elite Trading',
      avatarUrl: avatar?.isNotEmpty == true ? avatar : null,
      initials: json['initials'] as String? ?? 'ET',
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }
}

// ─── Comment Model ────────────────────────────────────────────────────────

class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String authorName;
  final String authorInitials;
  final String? authorAvatar;
  final String text;
  final int likes;
  final bool isLiked;
  final String timeAgo;
  final DateTime? createdAt;
  final bool isOwner;
  final bool canEdit;
  final bool canDelete;

  const CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.authorName,
    required this.authorInitials,
    this.authorAvatar,
    required this.text,
    required this.likes,
    this.isLiked = false,
    required this.timeAgo,
    this.createdAt,
    this.isOwner = false,
    this.canEdit = false,
    this.canDelete = false,
  });

  CommentModel copyWith({
    String? text,
    int? likes,
    bool? isLiked,
  }) {
    return CommentModel(
      id: id,
      postId: postId,
      userId: userId,
      authorName: authorName,
      authorInitials: authorInitials,
      authorAvatar: authorAvatar,
      text: text ?? this.text,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      timeAgo: timeAgo,
      createdAt: createdAt,
      isOwner: isOwner,
      canEdit: canEdit,
      canDelete: canDelete,
    );
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    final name = _extractName(json);
    final avatar = user?['avatarUrl'] as String? ??
        json['authorAvatar'] as String?;
    return CommentModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      postId: json['postId']?.toString() ?? '',
      userId: user?['id']?.toString() ??
          json['userId']?.toString() ??
          '',
      authorName: name,
      authorInitials:
          user?['initials'] as String? ?? _initials(name),
      authorAvatar: avatar?.isNotEmpty == true ? avatar : null,
      text: json['text'] as String? ?? '',
      likes: (json['likesCount'] as num?)?.toInt() ??
          (json['likes'] as num?)?.toInt() ??
          0,
      isLiked: json['isLikedByMe'] as bool? ??
          json['isLiked'] as bool? ??
          false,
      timeAgo: json['timeAgo'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      isOwner: json['isOwner'] as bool? ?? false,
      canEdit: json['canEdit'] as bool? ?? false,
      canDelete: json['canDelete'] as bool? ?? false,
    );
  }

  static String _extractName(Map<String, dynamic> json) {
    // Backend may populate user name inside a nested user field
    if (json['user'] is Map<String, dynamic>) {
      final u = json['user'] as Map<String, dynamic>;
      final directName = u['name'] as String? ?? '';
      if (directName.isNotEmpty) return directName;
      final first = u['firstName'] as String? ?? '';
      final last = u['lastName'] as String? ?? '';
      final full = '$first $last'.trim();
      if (full.isNotEmpty) return full;
    }
    return json['authorName'] as String? ?? 'User';
  }

  static String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

// ─── Result wrappers ──────────────────────────────────────────────────────

class PostListResult {
  final String access;
  final List<PostModel> posts;
  final int totalPosts;
  final Map<String, dynamic>? pagination;

  const PostListResult({
    required this.access,
    required this.posts,
    required this.totalPosts,
    this.pagination,
  });
}

class CommentListResult {
  final List<CommentModel> comments;
  final Map<String, dynamic>? pagination;

  const CommentListResult({required this.comments, this.pagination});
}

class ToggleLikeResult {
  final bool isLiked;
  final int likesCount;

  const ToggleLikeResult({required this.isLiked, required this.likesCount});
}
