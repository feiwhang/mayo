import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayo/providers/user_data_provider.dart';
import 'package:mayo/screens/shared/landing_screen.dart';
import 'package:mayo/screens/shared/main_screen.dart';
import 'package:mayo/screens/shared/phone_verification_screen.dart';
import 'package:mayo/screens/shared/register_screen.dart';
import 'package:mayo/utils/constants.dart';
import 'package:mayo/utils/converter.dart';
import 'package:mayo/widgets/alert_dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

bool isAuthenticated() {
  return auth.currentUser != null;
}

String? getUID() {
  return isAuthenticated() ? auth.currentUser?.uid : null;
}

Future<void> sendPhoneNumVerificationCode(String phoneNum) async {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) => LoadingDialog(
        loadingText: AppLocalizations.of(context)!.verifyingPhone),
    barrierDismissible: false,
  );

  await auth.verifyPhoneNumber(
    phoneNumber: textToFirebasePhoneNum(phoneNum),
    verificationCompleted: (PhoneAuthCredential credential) async {
      navigatorKey.currentState?.pop(); // close loading dialog

      await signUserIn(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      navigatorKey.currentState?.pop(); // close loading dialog

      showDialog(
        context: navigatorKey.currentContext!,
        builder: (BuildContext context) => ErrorDialog(
          errTitle: AppLocalizations.of(context)!.sthWentWrong,
          errText:
              e.message ?? AppLocalizations.of(context)!.errorInvalidPhoneNum,
        ),
      );
    },
    codeSent: (String verificationId, int? resendToken) {
      navigatorKey.currentState?.pop(); // close loading dialog

      // push to phone verification screen (smsCode)
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => PhoneVerificationScreen(
            phoneNum: phoneNum.replaceAll(' ', ''),
            verificationId: verificationId,
          ),
        ),
      );
    },
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}

Future<void> verifyCodeFromPhoneNum(
    String verificationId, String smsCode) async {
  PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId, smsCode: smsCode);

  await signUserIn(credential);
}

Future<void> signUserIn(PhoneAuthCredential credential) async {
  try {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) =>
          LoadingDialog(loadingText: AppLocalizations.of(context)!.signingIn),
      barrierDismissible: false,
    );

    UserCredential userCredential = await auth.signInWithCredential(credential);

    navigatorKey.currentState?.pop(); // close loading dialog

    // check if new user
    if (userCredential.additionalUserInfo == null ||
        userCredential.additionalUserInfo!.isNewUser) {
      // new user -> send to register screen
      navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => RegisterScreen(
              phoneNum:
                  firebasePhoneNumToText(userCredential.user!.phoneNumber!),
            ),
          ),
          (Route<dynamic> route) => false);
    } else {
      // current user -> send to main screen
      navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (Route<dynamic> route) => false);
    }
  } catch (e) {
    // TODO: Handle login errors
  }
}

Future<void> logout(WidgetRef ref) async {
  await auth.signOut();

  ref.read(userDataProvider.notifier).resetUserData();

  navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LandingScreen()),
      (Route<dynamic> route) => false);
}
