import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayo/providers/nav_bar_index_provider.dart';
import 'package:mayo/utils/constants.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Screen"),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}

class NavBar extends ConsumerWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int selectedIndex = ref.watch(navBarIndexProvider);
    NavBarIndexNotifier navBarIndexNotifier =
        ref.read(navBarIndexProvider.notifier);

    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        items: [
          navItem(Icons.home, 'Home'),
          navItem(Icons.home, 'Home'),
          navItem(Icons.home, 'Home'),
        ],
        currentIndex: selectedIndex,
        onTap: navBarIndexNotifier.setIndex,
        selectedLabelStyle: normalTextStyle,
        unselectedLabelStyle: normalTextStyle,
        selectedItemColor: darkestYellowColor,
        unselectedItemColor: normalTextColor,
        backgroundColor: Colors.white,
      ),
    );
  }

  BottomNavigationBarItem navItem(IconData iconData, String label) {
    return BottomNavigationBarItem(
      icon: Icon(iconData),
      label: label,
    );
  }
}
