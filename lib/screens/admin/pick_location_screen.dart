import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mayo/firebase/db_services.dart';
import 'package:mayo/providers/new_gym_provider.dart';
import 'package:mayo/utils/constants/color_const.dart';
import 'package:mayo/utils/constants/space_const.dart';
import 'package:mayo/utils/get_position.dart';
import 'package:mayo/widgets/alert_dialogs.dart';
import 'package:mayo/widgets/cta.dart';

class PickLocationScreen extends StatefulWidget {
  const PickLocationScreen({Key? key}) : super(key: key);

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pickLocation),
        backgroundColor: darkestYellowColor,
        shadowColor: Colors.transparent,
      ),
      body: FutureBuilder<Position>(
        future: getPosition(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PickLocationMap(position: snapshot.data!);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Center(
              child: Column(
                children: [
                  Text(AppLocalizations.of(context)!.pleaseEnableLocation),
                  vSpaceM,
                  Cta(
                    label: AppLocalizations.of(context)!.refresh,
                    onPressed: () {
                      setState(() {});
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class PickLocationMap extends ConsumerWidget {
  const PickLocationMap({Key? key, required this.position}) : super(key: key);
  final Position position;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CameraPosition startPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14,
    );

    final NewGymNotifier newGymNotifier = ref.read(newGymProvider.notifier);
    NewGym newGym = ref.watch(newGymProvider);

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: startPosition,
          myLocationEnabled: true,
          onMapCreated: (controller) =>
              newGymNotifier.setCameraPosition(startPosition),
          zoomGesturesEnabled: true,
          onCameraMove: (CameraPosition newCameraPosition) =>
              newGymNotifier.setCameraPosition(newCameraPosition),
        ),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 48),
            child: Icon(
              Icons.place,
              color: darkestYellowColor,
              size: 48,
            ),
          ),
        ),
        Positioned(
          bottom: 48,
          left: 32,
          child: Cta(
            label: AppLocalizations.of(context)!.selectThisLocation,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => ConfirmDialog(
                  confirmTitle: AppLocalizations.of(context)!.confirmCreateGym,
                  confirmText:
                      "name: ${newGym.nameController.text}\naddress: ${newGym.addressController.text}\nlat: ${newGym.cameraPosition!.target.latitude}\nlong: ${newGym.cameraPosition!.target.longitude}",
                  onConfirmed: () {
                    Map<String, dynamic> gymData = {
                      'name': newGym.nameController.text,
                      'address': newGym.addressController.text,
                      'lat': newGym.cameraPosition!.target.latitude,
                      'long': newGym.cameraPosition!.target.longitude,
                      'imagePath': newGym.imageFile!.path,
                    };
                    if (newGym.descController.text.isNotEmpty) {
                      gymData['description'] = newGym.descController.text;
                    }

                    // close this confirm dialog first
                    Navigator.of(context).pop();

                    createNewGym(gymData);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
