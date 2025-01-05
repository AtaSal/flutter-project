import 'package:flutter/material.dart';
import 'package:ppu_feed/models/subscription.dart';
import '../models/course.dart';

class CourseTile extends StatefulWidget {
  final Subscription course;

  const CourseTile({super.key, required this.course});

  @override
  _CourseTileState createState() => _CourseTileState();
}

class _CourseTileState extends State<CourseTile> {
  bool isSubscribed = false;

  @override
  void initState() {
    super.initState();
    isSubscribed = true;
  }



  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.course.course),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Section: ${widget.course.section}'),
            Text('Lecturer: ${widget.course.lecturer}'),
            Text('College: IT'),
          ],
        ),
      
      ),
    );
  }
}
