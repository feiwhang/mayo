import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mayo/firebase/db_services.dart';
import 'package:mayo/utils/constants/color_const.dart';
import 'package:mayo/utils/constants/space_const.dart';
import 'package:mayo/utils/get_position.dart';
import 'package:mayo/widgets/cta.dart';

class CustomerDiscoverView extends StatefulWidget {
  const CustomerDiscoverView({Key? key}) : super(key: key);

  @override
  State<CustomerDiscoverView> createState() => _CustomerDiscoverViewState();
}

class _CustomerDiscoverViewState extends State<CustomerDiscoverView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.discover),
        backgroundColor: darkestYellowColor,
        shadowColor: Colors.transparent,
      ),
      body: FutureBuilder<Position>(
        future: getPosition(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DiscoverMap(position: snapshot.data!);
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

class DiscoverMap extends StatefulWidget {
  const DiscoverMap({Key? key, required this.position}) : super(key: key);
  final Position position;

  @override
  State<DiscoverMap> createState() => _DiscoverMapState();
}

class _DiscoverMapState extends State<DiscoverMap> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  Widget build(BuildContext context) {
    final CameraPosition startPosition = CameraPosition(
      target: LatLng(widget.position.latitude, widget.position.longitude),
      zoom: 14,
    );

    return GoogleMap(
      initialCameraPosition: startPosition,
      myLocationEnabled: true,
      zoomGesturesEnabled: true,
      markers: markers.values.toSet(),
      onMapCreated: (controller) async {
        List<Map<String, dynamic>> gyms = await getAllGymData();
        setState(() {
          for (var gym in gyms) {
            markers[MarkerId(gym['name'])] = Marker(
              markerId: MarkerId(gym['name']),
              position: LatLng(gym['lat'], gym['long']),
              // icon: BitmapDescriptor.,
              infoWindow: InfoWindow(
                title: gym['name'],
                snippet: gym['address'],
              ),
            );
          }
        });
      },
    );
  }
}
