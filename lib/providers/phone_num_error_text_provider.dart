import 'package:flutter_riverpod/flutter_riverpod.dart';

final phoneNumErrorTextProvider =
    StateNotifierProvider<PhoneNumErrorTextNotifier, String?>((ref) {
  return PhoneNumErrorTextNotifier();
});

class PhoneNumErrorTextNotifier extends StateNotifier<String?> {
  PhoneNumErrorTextNotifier() : super(null);

  bool validatePhoneNum(String phoneNum, String errorText) {
    final phoneNumRegex = RegExp(r"^0[6,8,9][0-9]{8}$");
    bool hasMatch = phoneNumRegex.hasMatch(phoneNum);

    state = hasMatch ? null : errorText;

    return hasMatch;
  }
}
