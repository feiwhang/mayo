import 'package:flutter_riverpod/flutter_riverpod.dart';

final verificationCodeErrorTextProvider = StateNotifierProvider.autoDispose<
    VerificationCodeErrorTextNotifier, String?>((ref) {
  return VerificationCodeErrorTextNotifier();
});

class VerificationCodeErrorTextNotifier extends StateNotifier<String?> {
  VerificationCodeErrorTextNotifier() : super(null);

  bool validateVerificationCode(String codeText, String errorText) {
    final codeRegex = RegExp(r"^\d{6}$");

    String code = codeText.replaceAll(' ', '');
    bool hasMatch = codeRegex.hasMatch(code);

    state = hasMatch ? null : errorText;

    return hasMatch;
  }
}
