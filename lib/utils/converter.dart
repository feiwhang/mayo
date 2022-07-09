import 'package:mayo/enums/user_role.dart';

String textToFirebasePhoneNum(String phoneNum) {
  return '+66 ${phoneNum.substring(1)}';
}

String firebasePhoneNumToText(String firebasePhoneNum) {
  return '0${firebasePhoneNum.substring(3)}';
}

UserRole userRoleFromString(String userRoleText) {
  return UserRole.values.firstWhere((element) => element.name == userRoleText);
}
