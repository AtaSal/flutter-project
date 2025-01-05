import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ppu_feed/main.dart';
import 'package:ppu_feed/models/comment.dart';
import 'package:http/http.dart' as http;

class CommentCard extends StatefulWidget {
  final Comment comment;
  final int courceId;
  final int sectionId;
  final int postId;
  const CommentCard(
      {Key? key,
      required this.comment,
      required this.courceId,
      required this.sectionId,
      required this.postId})
      : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool _isLoading = false;
  bool isLike = false;
  int likeCount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;
    getData(widget.comment.id);
  }

  _getLikeCount(int commentId) async {
    String token = shrePref!.getString("token") ?? "";

    final url =
        'http://feeds.ppu.edu/api/v1/courses/${widget.courceId}/sections/${widget.sectionId}/posts/${widget.postId}/comments/$commentId/likes';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(responseData);
      setState(() {
        likeCount = responseData["likes_count"] ?? 0;
      });
    }
  }

  _getIsLike(int commentId) async {
    String token = shrePref!.getString("token") ?? "";

    final url =
        'http://feeds.ppu.edu/api/v1/courses/${widget.courceId}/sections/${widget.sectionId}/posts/${widget.postId}/comments/$commentId/like';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        isLike = responseData["liked"] as bool;
      });
    }
  }

  getData(int commentId) async {
    await _getLikeCount(commentId);
    await _getIsLike(commentId);
    setState(() {
      _isLoading = false;
    });
  }

  taggleLike(int commentId) async {
    String token = shrePref!.getString("token") ?? "";

    final url =
        'http://feeds.ppu.edu/api/v1/courses/${widget.courceId}/sections/${widget.sectionId}/posts/${widget.postId}/comments/$commentId/like';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        if (isLike) {
          likeCount--;
        } else {
          likeCount++;
        }

        isLike = !isLike;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Comment comment = widget.comment;

    return Scaffold(
      appBar: AppBar(title: Text("comments details"),),
      body: Center(
        child: Card(
          child: Column(
            children: [
              ListTile(
                title: Text(comment.body),
                subtitle:
                    Text(comment.datePosted.toString() + " " + comment.author),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _isLoading
                      ? CircularProgressIndicator()
                      : Row(
                          children: [
                            Text(likeCount.toString()),
                            IconButton(
                                onPressed: () {
                                  taggleLike(comment.id);
                                },
                                icon: Icon(isLike
                                    ? Icons.favorite
                                    : Icons.favorite_border))
                          ],
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
