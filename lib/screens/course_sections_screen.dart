import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/section.dart';
import 'section_posts_screen.dart';

class CourseSectionsScreen extends StatelessWidget {
  final String courseId;
  final String token;

  const CourseSectionsScreen({super.key, required this.courseId, required this.token});

  Future<List<Section>> fetchSections() async {
    final api = ApiService();
    try {
      final response = await api.get('/courses/$courseId/sections');
      if (response.statusCode == 200) {
        // Assuming the API returns a list of sections
        final List<dynamic> sectionsData = response.body.split('\n'); // Example if plain text list
        return sectionsData
            .map((section) => Section(
                  id: section, // Replace with actual ID from API
                  name: "Section name here", // Replace with actual section name
                ))
            .toList();
      } else {
        throw Exception('Failed to fetch sections: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching sections: $e');
    }
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
            return Center(
              child: Text('Failed to load sections: ${snapshot.error}'),
            );
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
