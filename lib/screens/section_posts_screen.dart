import 'dart:convert'; // Required for JSON decoding
import 'package:flutter/material.dart';
import 'package:ppu_feed/main.dart';
import '../models/post.dart';
import '../widgets/post_tile.dart';
import 'package:http/http.dart' as http;

class SectionPostsScreen extends StatefulWidget {
  final int sectionId;
  final int courceId;

  const SectionPostsScreen(
      {super.key, required this.courceId, required this.sectionId});

  @override
  State<SectionPostsScreen> createState() => _SectionPostsScreenState();
}

class _SectionPostsScreenState extends State<SectionPostsScreen> {
  List<Post> _posts = [];
  bool _isLoading = true;
  final TextEditingController _postController=TextEditingController();
  
  Future<void> submitPost(String post) async {
    try {
      String token = shrePref!.getString("token") ?? "";

      await http.post(
        Uri.parse(
            "http://feeds.ppu.edu/api/v1/courses/${widget.courceId}/sections/${widget.sectionId}/posts"),
        body: {"body": post},
        headers: {
          'Authorization': '$token',
        },
      );

    _fetchCoursePosts();

      _postController.clear();

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


  Future<void> _fetchCoursePosts() async {
    String token = shrePref!.getString("token") ?? "";

    final url =
        'http://feeds.ppu.edu/api/v1/courses/${widget.courceId}/sections/${widget.sectionId}/posts';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _posts = (responseData['posts'] as List)
              .map((data) => Post.fromJson(data))
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
    // TODO: implement initState
    super.initState();
    _fetchCoursePosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Course Posts')),
        body: Column(
          children: [
            Card(
              child: Column(
                children: [
                  Text("add new post"),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _postController,
                          decoration: const InputDecoration(
                            labelText: 'Add a post',
                            hintText: 'Type your post here...',
                          ),
                        ),
                      ),
                        IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final commentText = _postController.text.trim();
                    if (commentText.isNotEmpty) {
                      submitPost(commentText);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Comment cannot be empty')),
                      );
                    }
                  },
                ),
                    ],
                  )
                ],
              ),
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                  child: ListView.builder(
                    reverse: true,
                      itemCount: _posts.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: PostTile(
                          post: _posts[index],
                          courceId: widget.courceId,
                          sectionId: widget.sectionId,
                        ));
                      },
                    ),
                )
          ],
        ));
  }
}
