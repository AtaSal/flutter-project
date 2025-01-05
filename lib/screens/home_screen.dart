import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ppu_feed/main.dart';
import 'package:ppu_feed/models/course.dart';
import 'package:ppu_feed/screens/course_sections_screen.dart';
import '../widgets/app_drawer.dart';

import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  List<Course> cource = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _isLoading = true;
    getAll();
  }

  getAll() async {
    String token = shrePref!.getString("token") ?? "";
    final res = await http.get(
      Uri.parse("http://feeds.ppu.edu/api/v1/courses"),
      headers: {"Authorization": "$token"},
    );
    print(res.body);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body)['courses'] as List;
      setState(() {
      cource = data.map((e) => Course.fromJson(e)).toList();
        
        _isLoading=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          :  ListView.builder(
                  itemCount: cource.length,
                  itemBuilder: (context, index) {
                    final course = cource[index];
                    return Card(
                      child: ListTile(
                        title: Text(course.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('name: ${course.name}'),
                            Text('college: ${course.college}'),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseSectionsScreen(courseId: course.id,

                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
    );
  }
}
