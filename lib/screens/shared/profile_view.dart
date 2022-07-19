import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayo/firebase/auth_services.dart';
import 'package:mayo/providers/lang_code_provider.dart';
import 'package:mayo/providers/user_data_provider.dart';
import 'package:mayo/utils/constants/color_const.dart';
import 'package:mayo/utils/constants/text_style_const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mayo/widgets/alert_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserData? userData = ref.watch(userDataProvider);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        centerTitle: false,
        shadowColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.welcome,
              style: normalTextStyle(normalTextColor),
            ),
            Text(
              userData!.name ?? "",
              style: headerTextStyle(darkTextColor),
            )
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: mainGradientH,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () => logout(ref),
              style: TextButton.styleFrom(
                primary: darkRedColor,
                backgroundColor: darkRedColor,
              ),
              child: Text(
                AppLocalizations.of(context)!.signOut,
                style: normalTextStyle(Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 8)
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(AppLocalizations.of(context)!.changeLang,
                style: normalTextStyle(darkTextColor)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                langTextButton("English", "en", ref, context),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: VerticalDivider(
                    color: normalTextColor,
                    thickness: 1,
                  ),
                ),
                langTextButton("ไทย", "th", ref, context),
              ],
            ),
            minLeadingWidth: 0,
          )
        ],
      ),
    );
  }

  Widget langTextButton(
      String langText, String langCode, WidgetRef ref, BuildContext context) {
    late Timer timer;

    final String? langCodeProviderValue = ref.watch(langCodeProvider);

    return TextButton(
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();

        // check if already that langCode
        String? currentLangCode = prefs.getString("langCode");
        if (currentLangCode == langCode) return;

        prefs.setString("langCode", langCode);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            timer = Timer(const Duration(seconds: 1), () {
              Navigator.of(context).pop();
            });
            return LoadingDialog(
                loadingText: AppLocalizations.of(context)!.changingLang);
          },
          barrierDismissible: false,
        ).then((value) {
          timer.isActive ? timer.cancel() : null;
        });

        // change lang on the provider
        final LangCodeNotifier langCodeNotifier =
            ref.read(langCodeProvider.notifier);
        langCodeNotifier.setLangCode(langCode);
      },
      style: TextButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        primary: Colors.transparent,
        backgroundColor: langCodeProviderValue == langCode
            ? darkestYellowColor
            : Colors.transparent,
      ),
      child: Text(
        langText,
        style: normalTextStyle(
            langCodeProviderValue == langCode ? Colors.white : normalTextColor),
      ),
    );
  }
}
