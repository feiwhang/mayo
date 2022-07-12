// navbars
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

adminBottomNavLabels(BuildContext context) =>
    [AppLocalizations.of(context)!.home, AppLocalizations.of(context)!.profile];
final adminBottomNavIconData = [
  Icons.home_outlined,
  Icons.account_circle_outlined
];
final adminBottomNavActiveIconData = [Icons.home, Icons.account_circle];

userBottomNavLabels(BuildContext context) => [
      AppLocalizations.of(context)!.home,
      AppLocalizations.of(context)!.search,
      AppLocalizations.of(context)!.profile
    ];
final userBottomNavIconData = [
  Icons.home_outlined,
  Icons.search_outlined,
  Icons.account_circle_outlined
];
final userBottomNavActiveIconData = [
  Icons.home,
  Icons.search,
  Icons.account_circle
];
