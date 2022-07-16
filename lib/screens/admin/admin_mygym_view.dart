import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mayo/firebase/db_services.dart';
import 'package:mayo/screens/admin/create_gym_screen.dart';
import 'package:mayo/utils/constants/color_const.dart';
import 'package:mayo/utils/constants/space_const.dart';
import 'package:mayo/utils/constants/text_style_const.dart';
import 'package:mayo/widgets/cta.dart';
import 'package:mayo/widgets/shadow_container.dart';

class AdminMyGymView extends StatelessWidget {
  const AdminMyGymView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<Map<String, dynamic>?>(
        future: getAdminGymInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyGym(gymData: snapshot.data!);
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

class MyGym extends StatelessWidget {
  const MyGym({Key? key, required this.gymData}) : super(key: key);
  final Map<String, dynamic> gymData;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                gymData['imageUrl'],
                loadingBuilder: (context, child, loadingProgress) =>
                    Expanded(child: child),
                fit: BoxFit.cover,
              ),
            ),
            vSpaceM,
            ShadowContainer(
              child: ListTile(
                minLeadingWidth: 0,
                contentPadding: EdgeInsets.zero,
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        gymData['name'],
                        style: headerTextStyle(darkTextColor),
                      ),
                      hSpaceS,
                      gymData['isOffical']
                          ? const Icon(
                              Icons.check_circle,
                              color: darkGreenColor,
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                subtitle: Text(
                  gymData['description'] ??
                      AppLocalizations.of(context)!.noDescription,
                  style: normalTextStyle(normalTextColor),
                ),
              ),
            ),
            vSpaceM,
            ShadowContainer(
              child: ListTile(
                minLeadingWidth: 0,
                contentPadding: EdgeInsets.zero,
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.schedule,
                        style: headerTextStyle(darkTextColor),
                      ),
                      const Icon(
                        Icons.add_circle,
                        color: darkestYellowColor,
                        size: 32,
                      )
                    ],
                  ),
                ),
                subtitle: gymData.containsKey('schedules')
                    ? Wrap(
                        children: List.generate(
                          (gymData['schedules'] as Map).length,
                          (index) => Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              gradient: mainGradientH,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Text((gymData['schedules'] as Map)
                                .keys
                                .elementAt(index)),
                          ),
                        ),
                      )
                    : Text(
                        AppLocalizations.of(context)!.noSchedule,
                        style: normalTextStyle(normalTextColor),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
