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

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? '',
      body: json['body'] ?? '',
      datePosted: DateTime.parse(json['date_posted']),
      likes: json['likes'] ?? 0,
      username: json['username'] ?? '',
    );
  }
}
