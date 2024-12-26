import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ppu_feed_app/models/course.dart';
import 'package:ppu_feed_app/main.dart';

class CourceProvider extends ChangeNotifier {
  List<Course> cource = [];
  String token = shrePref!.getString("token") ?? "";

  Future<void> logout() async {
    // Clear token and notify listeners
    shrePref!.remove("token");
    token = "";
    notifyListeners();
  }

  Future<bool> getAllCource() async {
    try {
      final res = await http.get(
        Uri.parse("http://feeds.ppu.edu/api/v1/courses"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['courses'] as List;
        cource = data.map((e) => Course.fromJson(e)).toList();
        notifyListeners();
        return true;
      } else {
        throw Exception('Failed to fetch courses: ${res.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching courses: $e');
    }
  }

  Future<List<Course>> getSubscribedCourses() async {
    try {
      final res = await http.get(
        Uri.parse("http://feeds.ppu.edu/api/v1/subscribed-courses"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['courses'] as List;
        return data.map((e) => Course.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch subscribed courses: ${res.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching subscribed courses: $e');
    }
  }

  Future<void> subscribeToCourse(int courseId) async {
    try {
      final res = await http.post(
        Uri.parse("http://feeds.ppu.edu/api/v1/courses/$courseId/subscribe"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        notifyListeners();
      } else {
        throw Exception('Failed to subscribe to course: ${res.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error subscribing to course: $e');
    }
  }

  Future<void> unsubscribeFromCourse(int courseId) async {
    try {
      final res = await http.post(
        Uri.parse("http://feeds.ppu.edu/api/v1/courses/$courseId/unsubscribe"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        notifyListeners();
      } else {
        throw Exception('Failed to unsubscribe from course: ${res.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error unsubscribing from course: $e');
    }
  }
}
