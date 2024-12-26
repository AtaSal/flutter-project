import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/comment.dart';
import '../widgets/comment_tile.dart';

class PostCommentsScreen extends StatefulWidget {
  final String postId;
  final String token;

  const PostCommentsScreen({super.key, required this.postId, required this.token});

  @override
  _PostCommentsScreenState createState() => _PostCommentsScreenState();
}

class _PostCommentsScreenState extends State<PostCommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  late Future<List<Comment>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _commentsFuture = fetchComments();
  }

  Future<List<Comment>> fetchComments() async {
    final api = ApiService();
    try {
      final response = await api.get('/posts/${widget.postId}/comments');
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> commentsData = responseData['comments'];
        return commentsData
            .map((comment) => Comment.fromJson(comment))
            .toList()
            ..sort((a, b) => b.datePosted.compareTo(a.datePosted)); // Most recent first
      } else {
        throw Exception('Failed to fetch comments: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching comments: $e');
    }
  }

  Future<void> submitComment(String commentText) async {
    final api = ApiService();
    try {
      // Post the comment
      await api.post('/posts/${widget.postId}/comments', {'body': commentText});

      // Refresh comments after successful submission
      setState(() {
        _commentsFuture = fetchComments();
      });

      // Clear the input field
      _commentController.clear();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comment added successfully!')),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit comment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Comments')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Comment>>(
              future: _commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Failed to load comments: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  final comments = snapshot.data!;
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return CommentTile(comment: comments[index], token: widget.token);
                    },
                  );
                } else {
                  return const Center(child: Text('No comments available.'));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      labelText: 'Add a comment',
                      hintText: 'Type your comment here...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final commentText = _commentController.text.trim();
                    if (commentText.isNotEmpty) {
                      submitComment(commentText);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Comment cannot be empty')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
