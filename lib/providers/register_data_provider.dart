import 'package:flutter_riverpod/flutter_riverpod.dart';

final registerDataProvider = StateNotifierProvider.autoDispose<
    RegisterDataNotifier, Map<String, dynamic>>((ref) {
  return RegisterDataNotifier();
});

class RegisterDataNotifier extends StateNotifier<Map<String, dynamic>> {
  RegisterDataNotifier() : super({});

  void setRegsiterData(Map<String, dynamic> newData) => state = newData;
}
