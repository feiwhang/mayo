import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayo/class/user_role.dart';

final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, int>((ref) {
  return RegisterFormNotifier();
});

class RegisterFormNotifier extends StateNotifier<RegisterForm> {
  RegisterFormNotifier() : super(RegisterForm());

  RegisterForm get copyRegisterForm {
    RegisterForm newRegisterForm = RegisterForm();
    newRegisterForm.role = state.role;
    newRegisterForm.nameController = state.nameController;
    newRegisterForm.ageController = state.ageController;
    newRegisterForm.role = state.role;
    return newRegisterForm;
  }

  void setRole(UserRole role) {
    RegisterForm newRegisterForm = copyRegisterForm;
    newRegisterForm.role = role;

    state = newRegisterForm;
  }
}

class RegisterForm {
  UserRole? role;
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  String? gender;
}
