import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mayo/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          gradient: mainGradientV,
        ),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: SafeArea(
            child: SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "MAYO",
                    style: titleTextStyle,
                  ),
                  Column(
                    children: [
                      const CircularProgressIndicator(
                        color: normalTextColor,
                        strokeWidth: 2,
                      ),
                      vSpaceM,
                      Text(
                        AppLocalizations.of(context)!.loadingUserData,
                        style: normalTextStyle(darkTextColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
