import 'package:flutter_riverpod/flutter_riverpod.dart';

final navBarIndexProvider =
    StateNotifierProvider.autoDispose<NavBarIndexNotifier, int>((ref) {
  return NavBarIndexNotifier();
});

class NavBarIndexNotifier extends StateNotifier<int> {
  NavBarIndexNotifier() : super(0);

  void setIndex(int index) => state = index;
}
