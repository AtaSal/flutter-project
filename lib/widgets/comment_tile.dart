import 'package:flutter/material.dart';
import '../models/comment.dart';
import '../services/api_service.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;
  final String token;

  const CommentTile({super.key, required this.comment, required this.token});

  @override
  _CommentTileState createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  int likes = 0;

  @override
  void initState() {
    super.initState();
    likes = widget.comment.likes;
  }

  Future<void> likeComment() async {
    final api = ApiService();
    try {
      await api.post('/comments/${widget.comment.id}/like', {});
      setState(() {
        likes += 1; // Increment likes locally
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to like comment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.comment.body),
      subtitle: Text(
        '${widget.comment.datePosted.toLocal()} - ${widget.comment.username} - $likes Likes',
      ),
      trailing: IconButton(
        icon: const Icon(Icons.thumb_up),
        onPressed: likeComment,
      ),
    );
  }
}
