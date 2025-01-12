import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ppu_feed/main.dart';
import 'package:ppu_feed/widgets/comment_card.dart';
import '../models/comment.dart';
import '../widgets/comment_tile.dart';
import 'package:http/http.dart' as http;

class PostCommentsScreen extends StatefulWidget {
  final int postId;
  final int courceId;
  final int sectionId;

  const PostCommentsScreen(
      {super.key,
      required this.courceId,
      required this.sectionId,
      required this.postId});

  @override
  _PostCommentsScreenState createState() => _PostCommentsScreenState();
}

class _PostCommentsScreenState extends State<PostCommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  List<Comment> _comments = [];
  bool _isLoading = true;

  Future<void> _fetchComments() async {
    String token = shrePref!.getString("token") ?? "";

    final url =
        'http://feeds.ppu.edu/api/v1/courses/${widget.courceId}/sections/${widget.sectionId}/posts/${widget.postId}/comments';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _comments = (responseData['comments'] as List)
              .map((data) => Comment.fromJson(data))
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> submitComment(String commentText) async {
    try {
      String token = shrePref!.getString("token") ?? "";

      await http.post(
        Uri.parse(
            "http://feeds.ppu.edu/api/v1/courses/${widget.courceId}/sections/${widget.sectionId}/posts/${widget.postId}/comments"),
        body: {"body": commentText},
        headers: {
          'Authorization': token,
        },
      );

      _fetchComments();

      _commentController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment added successfully!')),
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
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: ListView.builder(
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return CommentCard(
                                  comment: _comments[index],
                                  courceId: widget.courceId,
                                  sectionId: widget.sectionId,
                                  postId: widget.postId);
                            },
                          ));
                        },
                        child: CommentTile(comment: _comments[index]));
                  },
                )),
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
                        const SnackBar(
                            content: Text('Comment cannot be empty')),
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
