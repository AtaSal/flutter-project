import 'package:flutter/material.dart';
import '../models/post.dart';
import '../screens/comments_feed_screen.dart';

class PostTile extends StatelessWidget {
  final Post post;
  final String token;

  const PostTile({super.key, required this.post, required this.token});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(post.body),
      subtitle: Text('${post.datePosted.toLocal()} - ${post.commentsCount} Comments'),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommentsFeedScreen(postId: post.id, token: token),
          ),
        );
      },
    );
  }
}
