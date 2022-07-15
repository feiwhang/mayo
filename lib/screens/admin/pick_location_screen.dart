import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mayo/providers/new_gym_provider.dart';
import 'package:mayo/utils/constants/color_const.dart';
import 'package:mayo/utils/constants/space_const.dart';
import 'package:mayo/utils/get_position.dart';
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
    final NewGymNotifier newGymNotifier = ref.read(newGymProvider.notifier);

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14,
          ),
          myLocationEnabled: true,
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
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
