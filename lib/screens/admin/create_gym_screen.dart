import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mayo/providers/new_gym_provider.dart';
import 'package:mayo/screens/admin/pick_location_screen.dart';
import 'package:mayo/utils/api_services.dart';
import 'package:mayo/utils/constants/color_const.dart';
import 'package:mayo/utils/constants/main_const.dart';
import 'package:mayo/utils/constants/space_const.dart';
import 'package:mayo/utils/constants/text_style_const.dart';
import 'package:mayo/widgets/alert_dialogs.dart';
import 'package:mayo/widgets/cta.dart';

class CreateGymScreen extends ConsumerWidget {
  const CreateGymScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          children: [
            const ImagePickerSection(),
            vSpaceM,
            const InfoFormSection(),
            vSpaceXL,
            Cta(
              label: AppLocalizations.of(context)!.cont,
              onPressed: () {
                // validate new gym form
                validateCreateGymForm(ref)
                    ? // ok
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PickLocationScreen()))
                    : showDialog(
                        context: navigatorKey.currentContext!,
                        builder: (BuildContext context) => ErrorDialog(
                          errTitle: AppLocalizations.of(context)!.sthWentWrong,
                          errText: AppLocalizations.of(context)!.errorBlank,
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  bool validateCreateGymForm(WidgetRef ref) {
    NewGym newGym = ref.watch(newGymProvider);

    if (newGym.imageFile == null ||
        newGym.nameController.text.isEmpty ||
        newGym.addressController.text.isEmpty) {
      return false;
    }

    return true;
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

class InfoFormSection extends ConsumerWidget {
  const InfoFormSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    NewGym newGym = ref.watch(newGymProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Form(
        child: Column(
          children: [
            TextFormField(
              decoration: roundedRectDecor(
                "${AppLocalizations.of(context)!.name} *",
                GestureDetector(
                  onTap: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (context) => SelectOfficalNameModal(
                            nameController: newGym.nameController));
                  },
                  child: const Icon(
                    Icons.more_vert,
                    color: normalTextColor,
                  ),
                ),
              ),
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
              maxLength: 255,
              maxLines: 1,
              controller: newGym.nameController,
              style: normalTextStyle(darkTextColor),
            ),
            vSpaceM,
            TextFormField(
              decoration: roundedRectDecor(
                AppLocalizations.of(context)!.description,
              ),
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
              maxLength: 255,
              maxLines: 5,
              controller: newGym.descController,
              style: normalTextStyle(darkTextColor),
            ),
            vSpaceM,
            TextFormField(
              decoration: roundedRectDecor(
                "${AppLocalizations.of(context)!.address} *",
              ),
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
              maxLength: 255,
              maxLines: 3,
              controller: newGym.addressController,
              style: normalTextStyle(darkTextColor),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectOfficalNameModal extends ConsumerWidget {
  const SelectOfficalNameModal({Key? key, required this.nameController})
      : super(key: key);
  final TextEditingController nameController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<String>>(
      future: getAllOfficalGymsName(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            height: 464,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    CupertinoButton(
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: normalTextStyle(normalTextColor),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(AppLocalizations.of(context)!.selectOffical,
                        style: subtitleTextStyle),
                    CupertinoButton(
                      child: Text(
                        AppLocalizations.of(context)!.done,
                        style: normalTextStyle(darkestYellowColor),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
                Expanded(
                  child: Material(
                    color: Colors.white,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: ListTile.divideTiles(
                        context: context,
                        tiles: List.generate(
                          snapshot.data!.length,
                          (index) => GestureDetector(
                            onTap: () {
                              nameController.text = snapshot.data![index];
                              Navigator.of(context).pop();
                            },
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              title: Text(snapshot.data![index]),
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                ),
                vSpaceL,
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
