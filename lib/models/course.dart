class Course {
  final int id;
  final String name;
  final String section;
  final String lecturerName;
  final String college;
  final bool isSubscribed;

  Course({
    required this.id,
    required this.name,
    required this.section,
    required this.lecturerName,
    required this.college,
    required this.isSubscribed,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      section: json['section'] ?? '',
      lecturerName: json['lecturer_name'] ?? '',
      college: json['college'] ?? '',
      isSubscribed: json['is_subscribed'] ?? false,
    );
  }
}
