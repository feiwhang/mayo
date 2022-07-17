import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

String timeToText(TimeOfDay time) {
  return DateFormat.Hm().format(getDateTime(time));
}

DateTime getDateTime(TimeOfDay t) {
  final dt = DateTime.now();
  return DateTime(dt.year, dt.month, dt.day, t.hour, t.minute);
}
