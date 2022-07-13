import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final newGymProvider =
    StateNotifierProvider.autoDispose<NewGymNotifier, NewGym>((ref) {
  return NewGymNotifier();
});

class NewGym {
  XFile? imageFile;
  String? name;
  bool isOffical = false;
}

class NewGymNotifier extends StateNotifier<NewGym> {
  NewGymNotifier() : super(NewGym());

  get copyState {
    NewGym newState = NewGym();

    newState.imageFile = state.imageFile;

    return newState;
  }

  void setImageFile(XFile? newImageFile) {
    NewGym newState = copyState;

    newState.imageFile = newImageFile;

    state = newState;
  }

  void setName(String newName, bool isOffical) {
    NewGym newState = copyState;

    newState.name = newName;
    newState.isOffical = isOffical;

    state = newState;
  }
}
