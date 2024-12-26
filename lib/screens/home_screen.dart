import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../provider/cource_provider.dart';
import 'section_posts_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: AppDrawer(), // Add the drawer here
      body: Consumer<CourceProvider>(
        builder: (context, value, child) {
          return FutureBuilder(
            future: value.getSubscribedCourses(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Failed to load subscribed courses: ${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                final courses = snapshot.data!;
                return ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return ListTile(
                      title: Text(course.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Section: ${course.section}'),
                          Text('Lecturer: ${course.lecturerName}'),
                          Text('College: ${course.college}'),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SectionPostsScreen(
                              sectionId: course.id.toString(),
                              token: value.token,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('No subscribed courses available.'),
                );
              }
            },
          );
        },
      ),
    );
  }
}
