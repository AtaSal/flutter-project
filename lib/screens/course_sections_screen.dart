import 'package:flutter/material.dart';
import '../models/section.dart';
import 'section_posts_screen.dart';

class CourseSectionsScreen extends StatelessWidget {
  final String courseId;
  final String token;

  const CourseSectionsScreen({super.key, required this.courseId, required this.token});

  Future<List<Section>> fetchSections() async {
    // Replace with an actual API call to fetch sections
    return [
      Section(id: '1', name: 'Section A'),
      Section(id: '2', name: 'Section B'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Sections')),
      body: FutureBuilder<List<Section>>(
        future: fetchSections(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load sections.'));
          } else if (snapshot.hasData) {
            final sections = snapshot.data!;
            return ListView.builder(
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final section = sections[index];
                return ListTile(
                  title: Text(section.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SectionPostsScreen(
                          sectionId: section.id,
                          token: token,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No sections available.'));
          }
        },
      ),
    );
  }
}
