class Comment {
  final String id;
  final String body;
  final DateTime datePosted;
  final int likes;
  final String username;

  Comment({
    required this.id,
    required this.body,
    required this.datePosted,
    required this.likes,
    required this.username,
  });
}
