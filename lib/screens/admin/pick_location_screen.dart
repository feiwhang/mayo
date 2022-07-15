import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
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
            return Center(
              child: Text(
                  "${snapshot.data!.latitude.toString()}, ${snapshot.data!.longitude.toString()}"),
            );
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
