import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mayo/firebase/db_services.dart';
import 'package:mayo/utils/constants/color_const.dart';
import 'package:mayo/utils/constants/main_const.dart';
import 'package:mayo/utils/constants/space_const.dart';
import 'package:mayo/utils/constants/text_style_const.dart';
import 'package:mayo/widgets/cta.dart';

class CustomerMyGymView extends ConsumerWidget {
  const CustomerMyGymView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: FutureBuilder<Map<String, dynamic>?>(
        future: getUserGymInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CustomerGym(gymData: snapshot.data!);
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
                  Cta(
                    label: AppLocalizations.of(context)!.joinGym,
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => const JoinGymModal(),
                      );
                    },
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

class CustomerGym extends StatelessWidget {
  const CustomerGym({Key? key, required this.gymData}) : super(key: key);
  final Map<String, dynamic> gymData;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class JoinGymModal extends StatefulWidget {
  const JoinGymModal({Key? key}) : super(key: key);

  @override
  State<JoinGymModal> createState() => _JoinGymModalState();
}

class _JoinGymModalState extends State<JoinGymModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              CupertinoButton(
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: normalTextStyle(normalTextColor),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              Text(AppLocalizations.of(context)!.joinGym,
                  style: subtitleTextStyle),
              CupertinoButton(
                child: Text(
                  AppLocalizations.of(context)!.done,
                  style: normalTextStyle(darkestYellowColor),
                ),
                onPressed: () {},
              )
            ],
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Material(
              child: TextField(
                decoration: roundedRectDecor(
                  "Gym ID *",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
