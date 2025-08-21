import 'package:care_sync/src/models/enums/userRole.dart';

class UserState {
  final String? accessToken;
  final String? refreshToken;
  final String? email;
  final String? name;
  final UserRole? role;

  const UserState({
    this.accessToken,
    this.refreshToken,
    this.email,
    this.name,
    this.role,
  });

  /// Initial state = user not logged in
  factory UserState.initial() => const UserState();

  /// Helper to check if user is logged in
  bool get isLoggedIn => accessToken != null && accessToken!.isNotEmpty;

  UserState copyWith({
    String? accessToken,
    String? refreshToken,
    String? email,
    String? name,
    UserRole? role,
  }) {
    return UserState(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }

  List<Object?> get props => [accessToken, refreshToken, email, name, role];
}
