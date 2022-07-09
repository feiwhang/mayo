import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayo/utils/constants/main_const.dart';

final phoneNumErrorTextProvider =
    StateNotifierProvider.autoDispose<PhoneNumErrorTextNotifier, String?>(
        (ref) {
  return PhoneNumErrorTextNotifier();
});

class PhoneNumErrorTextNotifier extends StateNotifier<String?> {
  PhoneNumErrorTextNotifier() : super(null);

  bool validatePhoneNum(String phoneText, String errorText) {
    final phoneNumRegex = RegExp(thaiPhoneNumRegex);

    String phoneNum = phoneText.replaceAll(' ', '');
    bool hasMatch = phoneNumRegex.hasMatch(phoneNum);

    state = hasMatch ? null : errorText;

    return hasMatch;
  }
}
