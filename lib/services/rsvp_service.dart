// lib/services/rsvp_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RsvpService extends ChangeNotifier {
  static final RsvpService instance = RsvpService._internal();

  factory RsvpService() => instance;

  RsvpService._internal();

  SharedPreferences? _prefs;
  bool _isInitialized = false;

  // Maps eventId to RegistrationDetails
  Map<String, Map<String, dynamic>> _registrations = {};

  Map<String, Map<String, dynamic>> get registrations => _registrations;

  bool get isInitialized => _isInitialized;

  // Initialize shared preferences and load registrations
  Future<void> init() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    final String? storedData = _prefs?.getString('rsvp_registrations');
    if (storedData != null) {
      try {
        final Map<String, dynamic> decoded = json.decode(storedData);
        _registrations = decoded.map((key, value) => MapEntry(key, Map<String, dynamic>.from(value)));
      } catch (e) {
        debugPrint("Error decoding RSVP registrations: $e");
        _registrations = {};
      }
    }
    _isInitialized = true;
    notifyListeners();
  }

  bool isRegistered(String eventId) {
    return _registrations.containsKey(eventId);
  }

  Map<String, dynamic>? getRegistrationDetails(String eventId) {
    return _registrations[eventId];
  }

  Future<void> register(String eventId, Map<String, dynamic> registrationData) async {
    _registrations[eventId] = {
      ...registrationData,
      'registeredAt': DateTime.now().toIso8601String(),
    };
    await _save();
    notifyListeners();
  }

  Future<void> cancelRsvp(String eventId) async {
    _registrations.remove(eventId);
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    if (_prefs == null) return;
    await _prefs!.setString('rsvp_registrations', json.encode(_registrations));
  }
}
