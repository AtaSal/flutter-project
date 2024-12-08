import 'package:flutter/material.dart';
import '../models/course.dart';
import '../widgets/course_tile.dart';

class FeedsScreen extends StatelessWidget {
  final String token;

  const FeedsScreen({super.key, required this.token});

  Future<List<Course>> fetchCourses() async {
    // Replace with actual API call to fetch courses
    return [
      Course(id: '1', name: 'Math 101', lecturer: 'Dr. Smith', college: 'Science', isSubscribed: false),
      Course(id: '2', name: 'Physics 102', lecturer: 'Dr. Jane', college: 'Engineering', isSubscribed: true),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Courses')),
      body: FutureBuilder<List<Course>>(
        future: fetchCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load courses.'));
          } else if (snapshot.hasData) {
            final courses = snapshot.data!;
            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return CourseTile(course: courses[index], token: token);
              },
            );
          } else {
            return const Center(child: Text('No courses available.'));
          }
        },
      ),
    );
  }
}
