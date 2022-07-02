import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mayo/utils/constants.dart';
import 'package:mayo/widgets/keyboard_dismissable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PhoneVerificationScreen extends StatelessWidget {
  const PhoneVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissable(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          iconTheme: const IconThemeData(color: normalTextColor, size: 18),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          color: Colors.white,
          child: SafeArea(
            child: SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(AppLocalizations.of(context)!.logOrRe,
                          style: titleTextStyle),
                      vSpaceS,
                      Text(AppLocalizations.of(context)!.toSendPhone,
                          style: subtitleTextStyle),
                      vSpaceXL,
                    ],
                  ),
                  Container(
                    width: 228,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: const ShapeDecoration(
                      shape: StadiumBorder(),
                      gradient: mainGradientH,
                    ),
                    child: MaterialButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: const StadiumBorder(),
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Text(
                        AppLocalizations.of(context)!.sendBySMS,
                        style: subtitleTextStyle,
                      ),
                      onPressed: () {},
                    ),
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
