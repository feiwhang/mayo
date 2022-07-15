import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

final newGymProvider =
    StateNotifierProvider.autoDispose<NewGymNotifier, NewGym>((ref) {
  return NewGymNotifier();
});

class NewGym {
  XFile? imageFile;
  bool isOffical = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  CameraPosition? cameraPosition;
}

class NewGymNotifier extends StateNotifier<NewGym> {
  NewGymNotifier() : super(NewGym());

  get copyState {
    NewGym newState = NewGym();

    newState.imageFile = state.imageFile;
    newState.nameController.text = state.nameController.text;
    newState.descController.text = state.descController.text;
    newState.addressController.text = state.addressController.text;
    newState.cameraPosition = state.cameraPosition;

    return newState;
  }

  void setImageFile(XFile? newImageFile) {
    NewGym newState = copyState;

    newState.imageFile = newImageFile;

    state = newState;
  }

  void setCameraPosition(CameraPosition newCameraPosition) {
    NewGym newState = copyState;

    newState.cameraPosition = newCameraPosition;

    state = newState;
  }
}
