import 'package:flutter/material.dart';
import '../models/comment.dart';
import '../widgets/comment_tile.dart';

class CommentsFeedScreen extends StatelessWidget {
  final String postId;
  final String token;

  const CommentsFeedScreen({super.key, required this.postId, required this.token});

  Future<List<Comment>> fetchComments() async {
    // Mock API response
    return [
      Comment(
        id: '1',
        body: 'Great post!',
        datePosted: DateTime.now(),
        likes: 3,
        user: 'User A',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comments')),
      body: FutureBuilder<List<Comment>>(
        future: fetchComments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load comments.'));
          } else if (snapshot.hasData) {
            final comments = snapshot.data!;
            return ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return CommentTile(comment: comments[index], token: token);
              },
            );
          } else {
            return const Center(child: Text('No comments available.'));
          }
        },
      ),
    );
  }
}
