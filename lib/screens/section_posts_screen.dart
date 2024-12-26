import 'dart:convert'; // Required for JSON decoding
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/post.dart';
import '../widgets/post_tile.dart';

class SectionPostsScreen extends StatelessWidget {
  final String sectionId;
  final String token;

  const SectionPostsScreen({super.key, required this.sectionId, required this.token});

  Future<List<Post>> fetchPosts() async {
    final api = ApiService();
    try {
      final response = await api.get('/sections/$sectionId/posts');
      if (response.statusCode == 200) {
        // Parse the response body into a map
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Extract the "posts" list from the response
        final List<dynamic> postsData = responseData['posts'];

        // Convert each post into a Post object and sort them by date
        return postsData
            .map((post) => Post.fromJson(post))
            .toList()
            ..sort((a, b) => b.datePosted.compareTo(a.datePosted));
      } else {
        throw Exception('Failed to fetch posts: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Posts')),
      body: FutureBuilder<List<Post>>(
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load posts: ${snapshot.error}'),
            );
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
