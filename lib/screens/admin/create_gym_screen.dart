import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mayo/providers/new_gym_provider.dart';
import 'package:mayo/utils/constants/color_const.dart';
import 'package:mayo/utils/constants/space_const.dart';
import 'package:mayo/utils/constants/text_style_const.dart';

class CreateGymScreen extends StatelessWidget {
  const CreateGymScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightestGreyColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.createGym),
        backgroundColor: darkestYellowColor,
        shadowColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [ImagePickerSection()],
        ),
      ),
    );
  }
}

class ImagePickerSection extends ConsumerWidget {
  const ImagePickerSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ImagePicker picker = ImagePicker();
    NewGym newGym = ref.watch(newGymProvider);

    final NewGymNotifier newGymNotifier = ref.read(newGymProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${AppLocalizations.of(context)!.img} *",
            style: normalTextStyle(normalTextColor),
          ),
          vSpaceM,
          GestureDetector(
            onTap: () async {
              final XFile? newImageFile =
                  await picker.pickImage(source: ImageSource.gallery);

              newGymNotifier.setImageFile(newImageFile);
            },
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: newGym.imageFile == null
                  ? Container(
                      decoration: BoxDecoration(
                        color: lightYellowColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image,
                        color: darkYellowColor,
                        size: 36,
                      ),
                    )
                  : FutureBuilder<Uint8List>(
                      future: newGym.imageFile!.readAsBytes(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
