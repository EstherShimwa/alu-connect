import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpportunityPost {
  final String id;
  final String title;
  final String category;
  final String description;
  final String date;
  final String location;
  final String organizer;
  final String postedBy; // user id
  final String postedByName;
  String status; // 'pending', 'approved', 'rejected'
  String rejectionNote;

  OpportunityPost({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.date,
    required this.location,
    required this.organizer,
    required this.postedBy,
    required this.postedByName,
    this.status = 'pending',
    this.rejectionNote = '',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'category': category,
        'description': description,
        'date': date,
        'location': location,
        'organizer': organizer,
        'postedBy': postedBy,
        'postedByName': postedByName,
        'status': status,
        'rejectionNote': rejectionNote,
      };

  factory OpportunityPost.fromMap(Map<String, dynamic> map) => OpportunityPost(
        id: map['id'],
        title: map['title'],
        category: map['category'],
        description: map['description'],
        date: map['date'],
        location: map['location'],
        organizer: map['organizer'],
        postedBy: map['postedBy'],
        postedByName: map['postedByName'],
        status: map['status'] ?? 'pending',
        rejectionNote: map['rejectionNote'] ?? '',
      );

  Map<String, String> toFeedMap() => {
        'id': id,
        'title': title,
        'category': category,
        'description': description,
        'date': date,
        'location': location,
        'organizer': organizer,
      };
}

class PostService extends ChangeNotifier {
  static final PostService instance = PostService._internal();
  factory PostService() => instance;
  PostService._internal();

  SharedPreferences? _prefs;
  List<OpportunityPost> _posts = [];

  List<OpportunityPost> get allPosts => _posts;
  List<OpportunityPost> get approvedPosts => _posts.where((p) => p.status == 'approved').toList();
  List<OpportunityPost> get pendingPosts => _posts.where((p) => p.status == 'pending').toList();

  List<OpportunityPost> myPosts(String userId) =>
      _posts.where((p) => p.postedBy == userId).toList();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final json_ = _prefs?.getString('opportunity_posts');
    if (json_ != null) {
      final list = json.decode(json_) as List<dynamic>;
      _posts = list.map((e) => OpportunityPost.fromMap(Map<String, dynamic>.from(e))).toList();
    }
    notifyListeners();
  }

  Future<void> submitPost(OpportunityPost post) async {
    _posts.add(post);
    await _save();
    notifyListeners();
  }

  Future<void> approvePost(String postId) async {
    final post = _posts.firstWhere((p) => p.id == postId);
    post.status = 'approved';
    await _save();
    notifyListeners();
  }

  Future<void> rejectPost(String postId, String note) async {
    final post = _posts.firstWhere((p) => p.id == postId);
    post.status = 'rejected';
    post.rejectionNote = note;
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    await _prefs?.setString('opportunity_posts', json.encode(_posts.map((p) => p.toMap()).toList()));
  }
}
