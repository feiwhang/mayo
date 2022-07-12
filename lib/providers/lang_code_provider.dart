import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final langCodeProvider =
    StateNotifierProvider.autoDispose<LangCodeNotifier, String?>((ref) {
  return LangCodeNotifier();
});

class LangCodeNotifier extends StateNotifier<String?> {
  LangCodeNotifier() : super(null);

  void setLangCode(String? newCode) => state = newCode;

  Future<String?> setLangCodeFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString("langCode");

    return state;
  }
}
