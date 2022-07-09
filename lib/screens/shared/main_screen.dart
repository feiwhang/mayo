import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayo/firebase/auth_services.dart';
import 'package:mayo/firebase/db_services.dart';
import 'package:mayo/providers/user_data_provider.dart';
import 'package:mayo/screens/shared/loading_screen.dart';
import 'package:mayo/utils/constants.dart';
import 'package:mayo/widgets/bottom_nav.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserData? userData = ref.watch(userDataProvider);

    if (userData == null) {
      getUserData(ref);
    }

    return userData == null
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Main Screen"),
              actions: [
                TextButton(
                  onPressed: () {
                    logout(ref);
                  },
                  child: Text(
                    "Logout",
                    style: headerTextStyle(darkRedColor),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: const BottomNav(),
            body: Center(
              child: Text("${userData.name}"),
            ),
          );
  }
}
