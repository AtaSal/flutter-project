import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ppu_feed/main.dart';
import 'package:ppu_feed/models/subscription.dart';

import '../widgets/course_tile.dart';
import 'package:http/http.dart' as http;

class SubScreen extends StatefulWidget {
  const SubScreen({super.key});

  @override
  State<SubScreen> createState() => _SubScreenState();
}

class _SubScreenState extends State<SubScreen> {
  List<Subscription> sub=[];
  bool _isLoading=false;
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
      Uri.parse("http://feeds.ppu.edu/api/v1/subscriptions"),
      headers: {"Authorization": "$token"},
    );
    print(res.body);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body)['subscriptions'] as List;
      setState(() {
      sub = data.map((e) => Subscription.fromJson(e)).toList();
        
        _isLoading=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('subscription course')),
      body: _isLoading?Center(child: CircularProgressIndicator(),): ListView.builder(
              itemCount: sub.length,
              itemBuilder: (context, index) {
                return CourseTile(course: sub[index]);
              },
            )
    );
  }
}
