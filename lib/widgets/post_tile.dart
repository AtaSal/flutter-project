import 'package:flutter/material.dart';
import '../models/post.dart';
import '../screens/post_comments_screen.dart';

class PostTile extends StatelessWidget {
  final Post post;
  final int sectionId;
  final int courceId;

  const PostTile({super.key, required this.post,required this.courceId, required this.sectionId });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(post.body),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Posted on: ${post.datePosted.toString()}'),
          Text('Lecturer: ${post.author}'),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostCommentsScreen(postId: post.id, courceId:courceId,sectionId: sectionId,),
          ),
        );
      },
    );
  }
}
