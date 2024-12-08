import 'package:flutter/material.dart';
import '../models/post.dart';
import '../widgets/post_tile.dart';

class SectionPostsScreen extends StatelessWidget {
  final String sectionId;
  final String token;

  const SectionPostsScreen({super.key, required this.sectionId, required this.token});

  Future<List<Post>> fetchPosts() async {
    // Replace with actual API call to fetch posts
    return [
      Post(
        id: '1',
        body: 'Welcome to Section A!',
        datePosted: DateTime.now(),
        likes: 5,
        commentsCount: 2,
      ),
      Post(
        id: '2',
        body: 'Second announcement!',
        datePosted: DateTime.now(),
        likes: 3,
        commentsCount: 1,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Section Posts')),
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
