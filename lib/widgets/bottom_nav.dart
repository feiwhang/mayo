import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayo/enums/user_role.dart';
import 'package:mayo/providers/nav_bar_index_provider.dart';
import 'package:mayo/providers/user_data_provider.dart';
import 'package:mayo/utils/constants/color_const.dart';
import 'package:mayo/utils/constants/navbar_const.dart';
import 'package:mayo/utils/constants/text_style_const.dart';

class BottomNav extends ConsumerWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int selectedIndex = ref.watch(navBarIndexProvider);
    NavBarIndexNotifier navBarIndexNotifier =
        ref.read(navBarIndexProvider.notifier);

    UserData? userData = ref.watch(userDataProvider);

    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        items: userData!.role == UserRole.admin
            ? navItems(adminBottomNavLabels(context), adminBottomNavIconData,
                adminBottomNavActiveIconData)
            : navItems(userBottomNavLabels(context), userBottomNavIconData,
                userBottomNavActiveIconData),
        currentIndex: selectedIndex,
        onTap: navBarIndexNotifier.setIndex,
        selectedLabelStyle: normalTextStyle(darkYellowColor),
        unselectedLabelStyle: normalTextStyle(darkTextColor),
        selectedItemColor: darkestYellowColor,
        unselectedItemColor: lightTextColor,
        backgroundColor: Colors.white,
      ),
    );
  }

  List<BottomNavigationBarItem> navItems(
    List<String> labels,
    List<IconData> iconDatas,
    List<IconData> activeIconDatas,
  ) {
    return List.generate(
      labels.length,
      (index) => BottomNavigationBarItem(
        label: labels[index],
        icon: Icon(iconDatas[index]),
        activeIcon: Icon(activeIconDatas[index]),
      ),
    );
  }
}
