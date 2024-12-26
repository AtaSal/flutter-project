import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/course.dart';

class CourseTile extends StatefulWidget {
  final Course course;

  const CourseTile({super.key, required this.course});

  @override
  _CourseTileState createState() => _CourseTileState();
}

class _CourseTileState extends State<CourseTile> {
  bool isSubscribed = false;

  @override
  void initState() {
    super.initState();
    isSubscribed = widget.course.isSubscribed;
  }

  Future<void> toggleSubscription() async {
    final api = ApiService();
    try {
      if (isSubscribed) {
        // Unsubscribe logic
        await api.post('/courses/${widget.course.id}/unsubscribe', {});
        setState(() {
          isSubscribed = false;
        });
      } else {
        // Subscribe logic
        await api.post('/courses/${widget.course.id}/subscribe', {});
        setState(() {
          isSubscribed = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update subscription: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.course.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Section: ${widget.course.section}'),
          Text('Lecturer: ${widget.course.lecturerName}'),
          Text('College: ${widget.course.college}'),
        ],
      ),
      trailing: IconButton(
        icon: Icon(
          isSubscribed ? Icons.check_box : Icons.check_box_outline_blank,
          color: isSubscribed ? Colors.green : Colors.grey,
        ),
        onPressed: toggleSubscription,
      ),
    );
  }
}
