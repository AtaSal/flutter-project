import 'package:flutter/material.dart';
import '../models/post.dart';
import '../screens/post_comments_screen.dart';

class PostTile extends StatelessWidget {
  final Post post;
  final String token;

  const PostTile({super.key, required this.post, required this.token});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(post.body),
      subtitle: Text('${post.datePosted.toLocal()} - ${post.likes} Likes'),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostCommentsScreen(postId: post.id, token: token),
          ),
        );
      },
    );
  }
}
