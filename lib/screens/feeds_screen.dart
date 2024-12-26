import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../services/api_service.dart';
import '../models/course.dart';
import '../widgets/course_tile.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({super.key});

  Future<List<Course>> fetchCourses() async {
    final api = ApiService();
    try {
      final response = await api.get('/courses');
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> coursesData = responseData['courses'];
        return coursesData.map((course) => Course.fromJson(course)).toList();
      } else {
        throw Exception('Failed to fetch courses: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching courses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Courses')),
      drawer: AppDrawer(), // Add the drawer here
      body: FutureBuilder<List<Course>>(
        future: fetchCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load courses: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final courses = snapshot.data!;
            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return CourseTile(course: courses[index]);
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
