import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayo/enums/user_role.dart';
import 'package:mayo/firebase/db_services.dart';
import 'package:mayo/providers/nav_bar_index_provider.dart';
import 'package:mayo/providers/user_data_provider.dart';
import 'package:mayo/screens/shared/loading_screen.dart';
import 'package:mayo/utils/constants/view_const.dart';
import 'package:mayo/widgets/bottom_nav.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserData? userData = ref.watch(userDataProvider);
    int selectedIndex = ref.watch(navBarIndexProvider);

    if (userData == null) {
      getUserData(ref);
    }

    return userData == null
        ? const LoadingScreen()
        : Scaffold(
            bottomNavigationBar: const BottomNav(),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: userData.role == UserRole.admin
                  ? adminViews[selectedIndex]
                  : userViews[selectedIndex],
            ),
          );
  }
}
