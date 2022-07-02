import 'package:flutter_riverpod/flutter_riverpod.dart';

final phoneNumErrorTextProvider =
    StateNotifierProvider.autoDispose<PhoneNumErrorTextNotifier, String?>(
        (ref) {
  return PhoneNumErrorTextNotifier();
});

class PhoneNumErrorTextNotifier extends StateNotifier<String?> {
  PhoneNumErrorTextNotifier() : super(null);

  bool validatePhoneNum(String phoneText, String errorText) {
    final phoneNumRegex = RegExp(r"^0[6,8,9][0-9]{8}$");

    String phoneNum = phoneText.replaceAll(' ', '');
    bool hasMatch = phoneNumRegex.hasMatch(phoneNum);

    state = hasMatch ? null : errorText;

    return hasMatch;
  }
}
