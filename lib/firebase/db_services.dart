import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayo/firebase/auth_services.dart';
import 'package:mayo/providers/user_data_provider.dart';
import 'package:mayo/screens/shared/landing_screen.dart';
import 'package:mayo/screens/shared/main_screen.dart';
import 'package:mayo/utils/constants/main_const.dart';
import 'package:mayo/utils/converter.dart';
import 'package:mayo/widgets/alert_dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final usersCollection = db.collection("users");

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

  usersCollection
      .doc(getUID())
      .set(registerData)
      .onError((error, stackTrace) {});

  // navigate to mainscreen
  navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainScreen()),
      (Route<dynamic> route) => false);
}

// return String of the gym id or null if admin doesn't join any gym yet
Future<String?> getAdminGymId() async {
  DocumentSnapshot doc = await usersCollection.doc(getUID()).get();

  final data = doc.data() as Map<String, dynamic>;

  return data.containsKey('gymId') ? data['gymId'] : null;
}
