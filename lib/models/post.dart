class Post {
  final String id;
  final String body;
  final DateTime datePosted;
  final int likes;
  final int commentsCount;

  Post({
    required this.id,
    required this.body,
    required this.datePosted,
    required this.likes,
    required this.commentsCount,
  });
}
