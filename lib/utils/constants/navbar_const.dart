// navbars
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

adminBottomNavLabels(BuildContext context) => [
      AppLocalizations.of(context)!.home,
      AppLocalizations.of(context)!.myGym,
      AppLocalizations.of(context)!.profile
    ];
final adminBottomNavIconData = [
  Icons.home_outlined,
  Icons.fitness_center_outlined,
  Icons.account_circle_outlined
];
final adminBottomNavActiveIconData = [
  Icons.home,
  Icons.fitness_center,
  Icons.account_circle
];

userBottomNavLabels(BuildContext context) => [
      AppLocalizations.of(context)!.discover,
      AppLocalizations.of(context)!.myGym,
      AppLocalizations.of(context)!.profile
    ];
final userBottomNavIconData = [
  Icons.map_outlined,
  Icons.fitness_center_outlined,
  Icons.account_circle_outlined
];
final userBottomNavActiveIconData = [
  Icons.map,
  Icons.fitness_center,
  Icons.account_circle
];
