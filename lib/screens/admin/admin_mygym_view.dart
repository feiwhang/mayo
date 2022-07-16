import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mayo/firebase/db_services.dart';
import 'package:mayo/screens/admin/create_gym_screen.dart';
import 'package:mayo/utils/constants/color_const.dart';
import 'package:mayo/utils/constants/space_const.dart';
import 'package:mayo/utils/constants/text_style_const.dart';
import 'package:mayo/widgets/cta.dart';

class AdminMyGymView extends StatelessWidget {
  const AdminMyGymView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<Map?>(
        future: getAdminGymInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map? gymData = snapshot.data!;
            return Center(
              child: Text(gymData["name"]),
            );
          }
          // loading gym from db
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  Text(AppLocalizations.of(context)!.loadingGym)
                ],
              ),
            );
          } else {
            // no gym
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.noGym,
                    style: headerTextStyle(darkRedColor),
                  ),
                  vSpaceXL,
                  Cta(label: AppLocalizations.of(context)!.joinGym),
                  vSpaceM,
                  Text(
                    AppLocalizations.of(context)!.or,
                    style: normalTextStyle(normalTextColor),
                  ),
                  vSpaceM,
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const CreateGymScreen()));
                    },
                    child: Text(
                      AppLocalizations.of(context)!.createGym,
                      style:
                          const TextStyle(decoration: TextDecoration.underline),
                    ),
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
