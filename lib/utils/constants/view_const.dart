import 'package:mayo/screens/admin/admin_home_view.dart';
import 'package:mayo/screens/admin/admin_mygym_view.dart';
import 'package:mayo/screens/admin/admin_profile_view.dart';
import 'package:mayo/screens/customer/customer_home_view.dart';
import 'package:mayo/screens/customer/customer_mygym_view.dart';
import 'package:mayo/screens/customer/customer_profile_view.dart';
import 'package:mayo/screens/customer/customer_search_view.dart';

const adminViews = [AdminHomeView(), AdminMyGymView(), AdminProfileView()];
const userViews = [
  CustomerHomeView(),
  CustomerSearchView(),
  CustomerMyGymView(),
  CustomerProfileView()
];
