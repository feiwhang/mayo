import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayo/firebase/db_services.dart';
import 'package:mayo/providers/user_data_provider.dart';
import 'package:mayo/screens/shared/loading_screen.dart';
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
        : const Scaffold(
            bottomNavigationBar: BottomNav(),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: SafeArea(
                child: MainView(),
              ),
            ),
          );
  }
}

class MainView extends ConsumerWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
