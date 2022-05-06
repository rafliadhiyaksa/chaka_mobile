import 'package:get/get.dart';

import '../controllers/presensi_controller.dart';

class PresensiBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(PresensiController());
  }
}
