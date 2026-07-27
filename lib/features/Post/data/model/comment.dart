class CommentModel {
  final String id;
  final String authorInitials;
  final String authorName;
  final String timeAgo;
  final String text;
  final int likes;

  const CommentModel({
    required this.id,
    required this.authorInitials,
    required this.authorName,
    required this.timeAgo,
    required this.text,
    required this.likes,
  });
}