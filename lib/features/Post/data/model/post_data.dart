class PostModel {
  final String id;
  final String tag; // Market Update, Education
  final String imageAsset;
  final String authorName;
  final bool isVerified;
  final String timeAgo;
  final String title;
  final String description;
  final int likes;
  final int comments;
  final int shares;

  const PostModel({
    required this.id,
    required this.tag,
    required this.imageAsset,
    required this.authorName,
    required this.isVerified,
    required this.timeAgo,
    required this.title,
    required this.description,
    required this.likes,
    required this.comments,
    required this.shares,
  });
}