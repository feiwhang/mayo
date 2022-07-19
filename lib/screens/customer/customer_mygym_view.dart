import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mayo/firebase/db_services.dart';
import 'package:mayo/utils/constants/color_const.dart';
import 'package:mayo/utils/constants/main_const.dart';
import 'package:mayo/utils/constants/space_const.dart';
import 'package:mayo/utils/constants/text_style_const.dart';
import 'package:mayo/utils/converter.dart';
import 'package:mayo/widgets/alert_dialogs.dart';
import 'package:mayo/widgets/cta.dart';
import 'package:mayo/widgets/shadow_container.dart';

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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                gymData['imageUrl'],
                loadingBuilder: (context, child, loadingProgress) => child,
                fit: BoxFit.cover,
              ),
            ),
            vSpaceM,
            Row(
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
            vSpaceM,
            const TodayReserved(),
            vSpaceM,
            TodaySchedule(gymData: gymData),
          ],
        ),
      ),
    );
  }
}

class JoinGymModal extends StatefulWidget {
  const JoinGymModal({Key? key}) : super(key: key);

  @override
  State<JoinGymModal> createState() => _JoinGymModalState();
}

class _JoinGymModalState extends State<JoinGymModal> {
  final TextEditingController gymIdController = TextEditingController();

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
                onPressed: () {
                  if (gymIdController.text.isEmpty) {
                    showDialog(
                      context: navigatorKey.currentContext!,
                      builder: (BuildContext context) => ErrorDialog(
                        errTitle: AppLocalizations.of(context)!.sthWentWrong,
                        errText: AppLocalizations.of(context)!.wrongGymId,
                      ),
                    );

                    return;
                  }
                  customerJoinGym(gymIdController.text);
                },
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
                controller: gymIdController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TodaySchedule extends StatefulWidget {
  const TodaySchedule({Key? key, required this.gymData}) : super(key: key);
  final Map<String, dynamic> gymData;

  @override
  State<TodaySchedule> createState() => _TodayScheduleState();
}

class _TodayScheduleState extends State<TodaySchedule> {
  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                Text(
                  AppLocalizations.of(context)!.todaysSchedule,
                  style: headerTextStyle(darkTextColor),
                ),
                vSpaceM,
              ] +
              ListTile.divideTiles(
                context: context,
                color: Colors.grey,
                tiles: List.generate(
                  widget.gymData['schedules'].length,
                  (index) {
                    widget.gymData['schedules']
                        .sort(((a, b) => a.toString().compareTo(b.toString())));

                    Map<String, dynamic> scheduleData =
                        widget.gymData['schedules'].elementAt(index);

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: mainGradientH,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          timeToText(
                            scheduleData['startHr'],
                            scheduleData['startMin'],
                          ),
                        ),
                      ),
                      title: FutureBuilder<int>(
                        future: todayScheduleCapacity(widget.gymData['gymId'],
                            scheduleData['scheduleId']),
                        builder: (context, snapshot) {
                          return Text(
                            '${AppLocalizations.of(context)!.capacity} ${snapshot.hasData ? snapshot.data : '-'}/${scheduleData['capacity']}',
                          );
                        },
                      ),
                      subtitle: Text(
                        '${AppLocalizations.of(context)!.duration} ${scheduleData['duration'].floor()} ${AppLocalizations.of(context)!.mins}',
                      ),
                      trailing: FutureBuilder<bool>(
                        future: isUserReserveScheduleAlready(
                            widget.gymData['gymId'],
                            scheduleData['scheduleId']),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && !snapshot.data!) {
                            // already reserved
                            return TextButton(
                              onPressed: () async {
                                await reserveTodaySchedule(
                                    widget.gymData['gymId'],
                                    scheduleData['scheduleId']);

                                setState(() {});
                              },
                              child: Text(
                                AppLocalizations.of(context)!.reserve,
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppLocalizations.of(context)!.reserve,
                                style: normalTextStyle(normalTextColor),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ).toList(),
        ),
      ),
    );
  }
}

class TodayReserved extends StatelessWidget {
  const TodayReserved({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.todayReserved,
              style: headerTextStyle(darkTextColor),
            ),
            vSpaceM,
          ],
        ),
      ),
    );
  }
}
