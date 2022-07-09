import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayo/enums/user_role.dart';

final userDataProvider =
    StateNotifierProvider<UserDataNotifier, UserData?>((ref) {
  return UserDataNotifier();
});

class UserData {
  String? name;
  int? age;
  String? gender;
  UserRole? role;
}

class UserDataNotifier extends StateNotifier<UserData?> {
  UserDataNotifier() : super(null);

  void initUserData(String name, int age, String gender, UserRole role) {
    UserData newData = UserData();
    newData.name = name;
    newData.age = age;
    newData.gender = gender;
    newData.role = role;
    state = newData;
  }

  void resetUserData() {
    state = null;
  }
}
