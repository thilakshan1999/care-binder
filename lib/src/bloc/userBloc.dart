import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/enums/userRole.dart';
import '../models/user/userState.dart';

class UserBloc extends Cubit<UserState> {
  UserBloc() : super(UserState.initial()) {
    _init();
  }
  Future<void> _init() async {
    // async print
    await loadUserFromPref();
  }

  static const _prefKey = 'user_state';

  Future<void> setUserFromToken(String accessToken, String refreshToken) async {
    try {
      // Decode JWT payload (2nd part of token)
      final parts = accessToken.split('.');
      if (parts.length != 3) throw Exception("Invalid access token");

      final payload =
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final data = jsonDecode(payload);

      // Extract values from JWT claims
      final email = data['sub'] as String?;
      final name = data['username'] as String?;
      final roleString = data['role'] as String?;
      final role = _mapRole(roleString);

      if (email == null || name == null || role == null) {
        emit(UserState.initial());
        return;
      }

      final newState = UserState(
        accessToken: accessToken,
        refreshToken: refreshToken,
        email: email,
        name: name,
        role: role,
      );

      emit(newState);

      // Save to SharedPreferences
      final pref = await SharedPreferences.getInstance();
      pref.setString(
          _prefKey,
          jsonEncode({
            'accessToken': accessToken,
            'refreshToken': refreshToken,
            'email': email,
            'name': name,
            'role': role.toString().split('.').last,
          }));
    } catch (e) {
      emit(UserState.initial());
    }
  }

  Future<void> loadUserFromPref() async {
    final pref = await SharedPreferences.getInstance();
    final jsonString = pref.getString(_prefKey);
    if (jsonString == null) {
      emit(UserState.initial());
      return;
    }

    try {
      final data = jsonDecode(jsonString);
      final role = _mapRole(data['role'] as String?);

      if (data['accessToken'] == null ||
          data['refreshToken'] == null ||
          role == null) {
        emit(UserState.initial());
        return;
      }

      emit(UserState(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
        email: data['email'] as String?,
        name: data['name'] as String?,
        role: role,
      ));
    } catch (_) {
      emit(UserState.initial());
    }
  }

  Future<void> clear() async {
    emit(UserState.initial());
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKey);
  }

  UserRole? _mapRole(String? role) {
    if (role == null) return null;
    switch (role.toUpperCase()) {
      case "CAREGIVER":
        return UserRole.CAREGIVER;
      case "PATIENT":
        return UserRole.PATIENT;
    }
    return null;
  }
}
