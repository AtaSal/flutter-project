import 'package:flutter/material.dart';
import '../models/comment.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;
  final String token;

  const CommentTile({super.key, required this.comment, required this.token});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(comment.body),
      subtitle: Text('${comment.datePosted.toLocal()} - ${comment.likes} Likes - ${comment.user}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.thumb_up),
            onPressed: () {
              // Implement "like" logic
            },
          ),
        ],
      ),
    );
  }
}
