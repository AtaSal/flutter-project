class Post {
  final String id;
  final String body;
  final DateTime datePosted;
  final int commentsCount;
  final String lecturer;

  Post({
    required this.id,
    required this.body,
    required this.datePosted,
    required this.commentsCount,
    required this.lecturer,
  });
}
