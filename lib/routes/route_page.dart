import 'package:get/get.dart';

import '../bindings/login_binding.dart';
import '../bindings/presensi_binding.dart';
import '../views/authentication/login_page.dart';
import '../views/presensi_page.dart';
import 'route_name.dart';

class RoutePage {
  static final pages = [
    GetPage(
      name: RouteName.login,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: RouteName.presensi,
      page: () => PresensiPage(),
      binding: PresensiBinding(),
    ),
  ];
}
