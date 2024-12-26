class Post {
  final String id;
  final String body;
  final DateTime datePosted;
  final int likes;
  final int commentsCount;
  final String lecturerName;

  Post({
    required this.id,
    required this.body,
    required this.datePosted,
    required this.likes,
    required this.commentsCount,
    required this.lecturerName,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? '',
      body: json['body'] ?? '',
      datePosted: DateTime.parse(json['date_posted']),
      likes: json['likes'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      lecturerName: json['lecturer_name'] ?? '',
    );
  }
}
