import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mayo/firebase/db_services.dart';
import 'package:mayo/screens/admin/create_gym_screen.dart';
import 'package:mayo/utils/constants/color_const.dart';
import 'package:mayo/utils/constants/space_const.dart';
import 'package:mayo/utils/constants/text_style_const.dart';
import 'package:mayo/utils/converter.dart';
import 'package:mayo/widgets/alert_dialogs.dart';
import 'package:mayo/widgets/cta.dart';
import 'package:mayo/widgets/shadow_container.dart';

class AdminMyGymView extends StatelessWidget {
  const AdminMyGymView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<Map<String, dynamic>?>(
        future: getUserGymInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AdminGym(gymData: snapshot.data!);
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

class AdminGym extends StatelessWidget {
  const AdminGym({Key? key, required this.gymData}) : super(key: key);
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
                      GestureDetector(
                        onTap: () {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (context) => AddScheduleModal(
                                    gymId: gymData['gymId'],
                                  ));
                        },
                        child: const Icon(
                          Icons.add_circle,
                          color: darkestYellowColor,
                          size: 32,
                        ),
                      )
                    ],
                  ),
                ),
                subtitle: gymData.containsKey('schedules')
                    ? Wrap(
                        spacing: 8,
                        children:
                            List.generate(gymData['schedules'].length, (index) {
                          gymData['schedules'].sort(
                              ((a, b) => a.toString().compareTo(b.toString())));

                          return Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              gradient: mainGradientH,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              timeToText(gymData['schedules'].elementAt(index)),
                            ),
                          );
                        }),
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

class AddScheduleModal extends StatefulWidget {
  const AddScheduleModal({Key? key, required this.gymId}) : super(key: key);
  final String gymId;

  @override
  State<AddScheduleModal> createState() => _AddScheduleModalState();
}

class _AddScheduleModalState extends State<AddScheduleModal> {
  DateTime? startDt;
  double duration = 90.0;
  int capacity = 5;

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
      height: 584,
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
              Text(AppLocalizations.of(context)!.createSchedule,
                  style: subtitleTextStyle),
              CupertinoButton(
                child: Text(
                  AppLocalizations.of(context)!.done,
                  style: normalTextStyle(darkestYellowColor),
                ),
                onPressed: () {
                  // validate form first
                  if (startDt == null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => ErrorDialog(
                        errTitle: AppLocalizations.of(context)!.sthWentWrong,
                        errText: AppLocalizations.of(context)!.errorBlank,
                      ),
                    );
                    return;
                  }

                  // then run firebase login
                  createGymSchedule({
                    "startHr": startDt!.hour,
                    "startMin": startDt!.minute,
                    "duration": duration,
                    "capacity": capacity,
                  }, widget.gymId);
                },
              )
            ],
          ),
          const Divider(),
          Text(
            AppLocalizations.of(context)!.selectStarTime,
            style: normalTextStyle(darkestYellowColor),
          ),
          vSpaceS,
          SizedBox(
            height: 222,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: DateTime.now(),
              use24hFormat: true,
              onDateTimeChanged: (DateTime newDt) {
                setState(() {
                  startDt = newDt;
                });
              },
            ),
          ),
          const Divider(),
          vSpaceS,
          Text(
            AppLocalizations.of(context)!.selectDuration,
            style: normalTextStyle(darkestYellowColor),
          ),
          vSpaceS,
          Material(
            child: Slider(
              value: duration,
              onChanged: (value) {
                setState(() {
                  duration = value;
                });
              },
              thumbColor: darkestYellowColor,
              activeColor: darkYellowColor,
              inactiveColor: brightYellowColor,
              min: 30,
              max: 300,
              divisions: 9,
            ),
          ),
          vSpaceS,
          Text(
            '${duration.round().toString()} ${AppLocalizations.of(context)!.mins}',
            style: subtitleTextStyle,
          ),
          const Divider(),
          vSpaceS,
          Text(
            AppLocalizations.of(context)!.classCap,
            style: normalTextStyle(darkestYellowColor),
          ),
          vSpaceS,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (capacity > 1) {
                      capacity--;
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  shadowColor: Colors.transparent,
                  primary: capacity <= 1 ? Colors.grey.shade100 : lightRedColor,
                  padding: EdgeInsets.zero,
                ),
                child: Icon(
                  Icons.remove,
                  color: capacity <= 1 ? normalTextColor : darkRedColor,
                  size: 18,
                ),
              ),
              hSpaceM,
              Text(
                capacity.toString(),
                style: subtitleTextStyle,
              ),
              hSpaceM,
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    capacity++;
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  shadowColor: Colors.transparent,
                  primary: lightestGreenColor,
                  padding: EdgeInsets.zero,
                ),
                child: const Icon(
                  Icons.add,
                  color: darkGreenColor,
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
