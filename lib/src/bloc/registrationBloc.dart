import 'package:care_sync/src/models/enums/userRole.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/userRegistration.dart';

class RegistrationBloc extends Cubit<UserRegistration> {
  RegistrationBloc() : super(UserRegistration());

  void setRole(UserRole role) {
    emit(state.copyWith(role: role));
  }

  void setName(String name) {
    emit(state.copyWith(name: name));
  }

  void setEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void setPassword(String password) {
    emit(state.copyWith(password: password));
  }

  void setDateOfBirth(DateTime dateOfBirth) {
    emit(state.copyWith(dateOfBirth: dateOfBirth));
  }

  void clear() {
    emit(UserRegistration());
  }
}
