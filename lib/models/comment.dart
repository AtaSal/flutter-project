class Comment {
  final String id;
  final String body;
  final DateTime datePosted;
  final int likes;
  final String user;

  Comment({
    required this.id,
    required this.body,
    required this.datePosted,
    required this.likes,
    required this.user,
  });
}
