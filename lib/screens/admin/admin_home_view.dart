import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mayo/firebase/db_services.dart';
import 'package:mayo/utils/constants/color_const.dart';
import 'package:mayo/utils/constants/text_style_const.dart';
import 'package:mayo/utils/converter.dart';

class AdminHomeView extends ConsumerWidget {
  const AdminHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.home),
        backgroundColor: darkestYellowColor,
        shadowColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: getUserGymInfo(),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>?> snapshot) {
            if (snapshot.hasData) {
              final gymData = snapshot.data!;

              return ListView(
                children: <Widget>[
                      Text(
                        '${AppLocalizations.of(context)!.todaysSchedule} (${todayDateString()})',
                        style: headerTextStyle(darkTextColor),
                      ),
                    ] +
                    ListTile.divideTiles(
                      context: context,
                      color: Colors.grey,
                      tiles: List.generate(
                        gymData['schedules'].length,
                        (index) {
                          gymData['schedules'].sort(
                              ((a, b) => a.toString().compareTo(b.toString())));

                          Map<String, dynamic> scheduleData =
                              gymData['schedules'].elementAt(index);

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
                              future: todayScheduleCapacity(
                                  gymData['gymId'], scheduleData['scheduleId']),
                              builder: (context, snapshot) {
                                return Text(
                                  '${AppLocalizations.of(context)!.capacity} ${snapshot.hasData ? snapshot.data : '-'}/${scheduleData['capacity']}',
                                );
                              },
                            ),
                            subtitle: Text(
                              '${AppLocalizations.of(context)!.duration} ${scheduleData['duration'].floor()} ${AppLocalizations.of(context)!.mins}',
                            ),
                          );
                        },
                      ),
                    ).toList(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
