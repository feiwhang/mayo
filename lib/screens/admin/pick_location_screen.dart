import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mayo/utils/constants/color_const.dart';

class PickLocationScreen extends StatelessWidget {
  const PickLocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.pickLocation),
        backgroundColor: darkestYellowColor,
        shadowColor: Colors.transparent,
      ),
    );
  }
}
