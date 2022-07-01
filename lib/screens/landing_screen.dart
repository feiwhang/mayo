import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mayo/screens/phonenum_screen.dart';
import 'package:mayo/utils/constants.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

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
              Text(
                "MAYO",
                style: titleTextStyle,
              ),
              Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.welcome,
                    style: headerTextStyle,
                  ),
                  vSpaceL,
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PhoneNumScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: Colors.white70,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/icons/thailand.png', width: 24),
                          hSpaceS,
                          Text(
                            "+66",
                            style: subtitleTextStyle,
                          ),
                          hSpaceM,
                          Text(
                            "099 999 9999",
                            style: headerTextStyle,
                          )
                        ],
                      ),
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
