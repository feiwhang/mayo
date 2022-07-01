import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mayo/utils/constants.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: mainGradient,
      ),
      child: SafeArea(
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "MAYO",
                style: titleTextStyle,
              ),
              Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.welcome,
                    style: headerTextStyle,
                  ),
                  vSpaceM,
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Colors.white70,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/icons/thailand.png', width: 28),
                        hSpaceS,
                        const Text(
                          "+66",
                          style: subtitleTextStyle,
                        ),
                        hSpaceM,
                        const Text(
                          "099 999 9999",
                          style: headerTextStyle,
                        )
                      ],
                    ),
                  ),
                  vSpaceM,
                  Text(
                    AppLocalizations.of(context)!.loginOrRegis,
                    style: normalTextStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
