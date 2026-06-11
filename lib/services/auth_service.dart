import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUser {
  final String id;
  final String name;
  final String email;
  final String role; // 'student' or 'staff'

  AppUser({required this.id, required this.name, required this.email, required this.role});

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'email': email, 'role': role};

  factory AppUser.fromMap(Map<String, dynamic> map) => AppUser(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        role: map['role'],
      );

  bool get isStaff => role == 'staff';
}

class AuthService extends ChangeNotifier {
  static final AuthService instance = AuthService._internal();
  factory AuthService() => instance;
  AuthService._internal();

  SharedPreferences? _prefs;
  AppUser? _currentUser;
  // email -> {password, user data}
  Map<String, Map<String, dynamic>> _users = {};

  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // Load users
    final usersJson = _prefs?.getString('users');
    if (usersJson != null) {
      final decoded = json.decode(usersJson) as Map<String, dynamic>;
      _users = decoded.map((k, v) => MapEntry(k, Map<String, dynamic>.from(v)));
    }
    // Load current session
    final sessionJson = _prefs?.getString('current_user');
    if (sessionJson != null) {
      _currentUser = AppUser.fromMap(json.decode(sessionJson));
    }
    notifyListeners();
  }

  // Returns null on success, error message on failure
  Future<String?> signUp(String name, String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (_users.containsKey(normalizedEmail)) return 'An account with this email already exists';
    final role = normalizedEmail.endsWith('@alueducation.com') ? 'staff' : 'student';
    final user = AppUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      email: normalizedEmail,
      role: role,
    );
    _users[normalizedEmail] = {'password': password, 'user': user.toMap()};
    await _saveUsers();
    await _setSession(user);
    return null;
  }

  // Returns null on success, error message on failure
  Future<String?> login(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    final userData = _users[normalizedEmail];
    if (userData == null) return 'No account found with this email';
    if (userData['password'] != password) return 'Incorrect password';
    final user = AppUser.fromMap(Map<String, dynamic>.from(userData['user']));
    await _setSession(user);
    return null;
  }

  Future<void> logout() async {
    _currentUser = null;
    await _prefs?.remove('current_user');
    notifyListeners();
  }

  Future<void> _setSession(AppUser user) async {
    _currentUser = user;
    await _prefs?.setString('current_user', json.encode(user.toMap()));
    notifyListeners();
  }

  Future<void> _saveUsers() async {
    await _prefs?.setString('users', json.encode(_users));
  }
}
