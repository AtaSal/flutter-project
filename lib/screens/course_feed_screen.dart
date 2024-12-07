import 'package:flutter/material.dart';
import '../models/post.dart';
import '../widgets/post_tile.dart';

class CourseFeedScreen extends StatelessWidget {
  final String courseId;
  final String token;

  const CourseFeedScreen({super.key, required this.courseId, required this.token});

  Future<List<Post>> fetchPosts() async {
    // Mock API response
    return [
      Post(
        id: '1',
        body: 'Welcome to the course!',
        datePosted: DateTime.now(),
        commentsCount: 5,
        lecturer: 'Dr. Smith',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Feed')),
      body: FutureBuilder<List<Post>>(
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load posts.'));
          } else if (snapshot.hasData) {
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostTile(post: posts[index], token: token);
              },
            );
          } else {
            return const Center(child: Text('No posts available.'));
          }
        },
      ),
    );
  }
}
