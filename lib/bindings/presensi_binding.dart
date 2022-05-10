import 'package:get/get.dart';

import '../controllers/presensi_controller.dart';
import '../services/location_service.dart';

class PresensiBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(PresensiController());
    Get.put(LocationService());
  }
}
