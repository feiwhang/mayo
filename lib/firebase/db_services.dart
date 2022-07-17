import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayo/firebase/auth_services.dart';
import 'package:mayo/providers/user_data_provider.dart';
import 'package:mayo/screens/shared/landing_screen.dart';
import 'package:mayo/screens/shared/main_screen.dart';
import 'package:mayo/utils/api_services.dart';
import 'package:mayo/utils/constants/main_const.dart';
import 'package:mayo/utils/converter.dart';
import 'package:mayo/widgets/alert_dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final usersCollection = db.collection('users');
final gymsCollection = db.collection('gyms');

final FirebaseStorage storage = FirebaseStorage.instance;

Future<void> getUserData(WidgetRef ref) async {
  try {
    DocumentSnapshot doc = await usersCollection.doc(getUID()).get();
    final data = doc.data() as Map<String, dynamic>;

    await Future.delayed(const Duration(seconds: 1));

    ref.read(userDataProvider.notifier).initUserData(
          data['name'],
          data['age'],
          data['gender'],
          userRoleFromString(data['role']),
        );
  } catch (e) {
    // TODO: HANDLE ERRS

    // navigate back to landingscreen
    navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LandingScreen()),
        (Route<dynamic> route) => false);
  }
}

Future<void> createUserOnDb(Map<String, dynamic> registerData) async {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) =>
        LoadingDialog(loadingText: AppLocalizations.of(context)!.signingUp),
    barrierDismissible: false,
  );

  usersCollection.doc(getUID()).set(registerData).onError((error, stackTrace) {
    // TODO: HANDLE ERRS
  });

  // navigate to mainscreen
  navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainScreen()),
      (Route<dynamic> route) => false);
}

// return String of the gym id or null if admin doesn't join any gym yet
Future<Map<String, dynamic>?> getAdminGymInfo() async {
  DocumentSnapshot userDoc = await usersCollection.doc(getUID()).get();

  // get gymId from userData
  final userData = userDoc.data() as Map<String, dynamic>;
  if (!userData.containsKey('gymId')) return null;
  final String gymId = userData['gymId'];

  // get gymData
  DocumentSnapshot gymDoc = await gymsCollection.doc(gymId).get();

  final Map<String, dynamic> gymData = gymDoc.data() as Map<String, dynamic>;
  gymData["gymId"] = gymId;

  // get schedules from subcollection
  final QuerySnapshot schedulesSnapshot =
      await gymsCollection.doc(gymId).collection("schedules").get();

  gymData['schedules'] = <TimeOfDay>[];

  for (var doc in schedulesSnapshot.docs) {
    final scheduleData = doc.data() as Map<String, dynamic>;
    final scheduleTime = TimeOfDay(
        hour: scheduleData['startHr'], minute: scheduleData['startMin']);

    gymData['schedules'].add(scheduleTime);
  }

  return gymData;
}

Future<void> createNewGym(Map<String, dynamic> gymData) async {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) =>
        LoadingDialog(loadingText: AppLocalizations.of(context)!.creatingGym),
    barrierDismissible: false,
  );

  // check whether gym's name is official
  // this is too strait forward
  // in a real-life app we may need some kind of verification for this step
  gymData["isOffical"] = await isOfficalGym(gymData['name']);
  // add creator id, created timestamp
  gymData['createdBy'] = getUID();
  gymData['createdOn'] = Timestamp.fromDate(DateTime.now());

  // get imagePath by removing it from data
  final String imagePath = gymData.remove("imagePath");

  // create gym on db first to get the gymId
  DocumentReference<Map<String, dynamic>> gymDbDoc =
      await gymsCollection.add(gymData);
  // add gymId to user
  usersCollection.doc(getUID()).update({'gymId': gymDbDoc.id});

  // upload image to storage with the name of gymId from db doc
  final imageRef = storage.ref('gyms/${gymDbDoc.id}');
  final imageFile = File(imagePath);
  TaskSnapshot imageTask = await imageRef.putFile(imageFile,
      SettableMetadata(customMetadata: {'uploadedBy': getUID() ?? "UNKNOWN"}));

  final String imageUrl = await imageTask.ref.getDownloadURL();

  // then add imageUrl back to db doc
  await gymDbDoc.update({'imageUrl': imageUrl}).onError((error, stackTrace) {
    // TODO: HANDLE ERRS
  });

  // navigate back to mainscreen-gymview
  navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainScreen()),
      (Route<dynamic> route) => false);
}

Future<void> createGymSchedule(
    Map<String, dynamic> scheduleData, String gymId) async {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) =>
        LoadingDialog(loadingText: AppLocalizations.of(context)!.creatingGym),
    barrierDismissible: false,
  );

  // schedules sub collection in gyms
  final gymSchedulesCollection =
      gymsCollection.doc(gymId).collection("schedules");

  // add schedule data
  await gymSchedulesCollection.add(scheduleData);

  // navigate back to mainscreen-gymview
  navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainScreen()),
      (Route<dynamic> route) => false);
}
