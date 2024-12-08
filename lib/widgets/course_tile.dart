import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseTile extends StatelessWidget {
  final Course course;
  final String token;

  const CourseTile({super.key, required this.course, required this.token});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(course.name),
      subtitle: Text('${course.college} - ${course.lecturer}'),
      trailing: IconButton(
        icon: Icon(course.isSubscribed ? Icons.unsubscribe : Icons.subscriptions),
        onPressed: () {
          // Implement subscribe/unsubscribe logic
        },
      ),
      onTap: () {
        // Navigate to CourseSectionsScreen
      },
    );
  }
}
