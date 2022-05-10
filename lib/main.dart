import 'package:chaka_app/services/location_service.dart';
import 'package:chaka_app/services/notification_service.dart';
import 'package:chaka_app/views/authentication/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/auth_controller.dart';
import 'controllers/presensi_controller.dart';
import 'routes/route_page.dart';
import 'views/authentication/login_page.dart';
import 'views/presensi_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  NotificationService notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestIOSPermissions();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final authC = Get.find<AuthController>();
  final presensiC = Get.lazyPut(() => PresensiController());
  final locationC = Get.lazyPut(() => LocationService());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue.shade600),
            padding: MaterialStateProperty.all(const EdgeInsets.all(5)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ),
      ),
      home: FutureBuilder(
        future: authC.initializeSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          } else {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Obx(() {
                NotificationService().showPeriodicNotification();
                if (authC.isLogged.value) {
                  return PresensiPage();
                } else {
                  return LoginPage();
                }
              });
            }
          }
        },
      ),
      getPages: RoutePage.pages,
    );
  }
}
