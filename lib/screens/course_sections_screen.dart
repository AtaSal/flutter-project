import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ppu_feed/main.dart';
import 'package:ppu_feed/models/subscription.dart';
import '../models/section.dart';
import 'section_posts_screen.dart';
import 'package:http/http.dart' as http;

class CourseSectionsScreen extends StatefulWidget {
  final int courseId;

  const CourseSectionsScreen({
    super.key,
    required this.courseId,
  });

  @override
  State<CourseSectionsScreen> createState() => _CourseSectionsScreenState();
}

class _CourseSectionsScreenState extends State<CourseSectionsScreen> {
  List<Section> _sections = [];
  List<Subscription> _sub = [];
  final List<int> _subSection = [];
  bool _isLoading = false;

  Future<void> _fetchCoursesSection() async {
    String token = shrePref!.getString("token") ?? "";

    final url =
        'http://feeds.ppu.edu/api/v1/courses/${widget.courseId}/sections';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        print(response.body);

        final responseData = json.decode(response.body)["sections"] as List;
        setState(() {
          _sections = responseData
              .map(
                (e) => Section.fromJson(e),
              )
              .toList();
        });
      } else {}
    } catch (error) {}
  }

  _fetchSubscribed() async {
    String token = shrePref!.getString("token") ?? "";

    try {
      const url = 'http://feeds.ppu.edu/api/v1/subscriptions';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final res = responseData['subscriptions'] as List;
        _sub = res.map((data) => Subscription.fromJson(data)).toList();
        for (var element in _sub) {
            if (element.course == _sections[0].course) {
              _subSection.add(element.sectionid);
            }
          }
        print(_subSection);
        setState(() {
          for (var element in _sections) {
              if (_subSection.contains(element.id)) {
                element.isSub = true;
              }
            }
        });
      } else {}
    } catch (error) {}
  }

  Future<void> _subscribeToCourse(int courseId, int section) async {
    String token = shrePref!.getString("token") ?? "";

    final url =
        'http://feeds.ppu.edu/api/v1/courses/$courseId/sections/$section/subscribe';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subscribed successfully')),
      );
      setState(() {
        for (var element in _sections) {
            if (element.id == section) {
              element.isSub = true;
            }
          }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to subscribe')),
      );
    }
  }

  Future<void> _unsubscribeFromCourse(
      int courseId, int section, int subId) async {
    String token = shrePref!.getString("token") ?? "";

    final url =
        'http://feeds.ppu.edu/api/v1/courses/$courseId/sections/$section/subscribe/$subId';
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unsubscribed successfully')),
      );
      setState(() {
        for (var element in _sections) {
            if (element.id == section) {
              element.isSub = false;
            }
          }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to unsubscribe')),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;
    getData();
    setState(() {
      _isLoading = false;
    });
  }

  getData() async {
    await _fetchCoursesSection();
    await _fetchSubscribed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Course Sections')),
        body:_isLoading?const Center(child: CircularProgressIndicator(),): ListView.builder(
          itemCount: _sections.length,
          itemBuilder: (context, index) {
            final section = _sections[index];
            int subid = 0;
            for (var element in _sub) {
                if (element.sectionid == section.id) {
                  subid = element.id;
                }
              }
            return ListTile(
              title: Text("${section.course} ${section.name}"),
              subtitle: Text(section.lecturer),
              trailing: IconButton(
                  onPressed: () {
                    if (section.isSub) {
                      _unsubscribeFromCourse(section.id, section.id, subid);
                    } else {
                      _subscribeToCourse(widget.courseId, section.id);
                    }
                  },
                  icon: Icon(section.isSub
                      ? Icons.favorite
                      : Icons.favorite_border_sharp)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SectionPostsScreen(
                      courceId: widget.courseId,
                      sectionId: section.id,

                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}
