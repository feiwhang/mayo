import 'package:flutter_riverpod/flutter_riverpod.dart';

final registerDataProvider = StateNotifierProvider.autoDispose<
    RegisterDataNotifier, Map<String, String>>((ref) {
  return RegisterDataNotifier();
});

class RegisterDataNotifier extends StateNotifier<Map<String, String>> {
  RegisterDataNotifier() : super({});

  void setRegsiterData(Map<String, String> newData) => state = newData;
}
