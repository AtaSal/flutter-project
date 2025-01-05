import 'package:flutter/material.dart';
import '../models/comment.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;

  const CommentTile({super.key, required this.comment, });

  @override
  _CommentTileState createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.comment.body),
      subtitle: Text(
        '${widget.comment.datePosted.toLocal()} - ${widget.comment.author} ',
      ),
    
    );
  }
}
