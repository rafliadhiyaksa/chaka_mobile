import 'dart:async';
import 'dart:convert';

import 'package:chaka_app/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

import '../providers/presensi_provider.dart';

class PresensiController extends GetxController {
  var date = ''.obs;
  late TextEditingController noEmployeeController;
  var imageBase64 = ''.obs;
  var image = XFile('').obs;

  // var latitude = 0.0.obs;
  // var longitude = 0.0.obs;
  // var place = Placemark().obs;

  var tempData = {}.obs;

  // LocationPermission? permission;
  final ImagePicker _picker = ImagePicker();

  final formKey = GlobalKey<FormState>().obs;

  @override
  void onInit() async {
    noEmployeeController = TextEditingController();

    date.value = DateFormat('d MMMM yyyy HH:mm:ss').format(await NTP.now());
    Timer.periodic(const Duration(seconds: 1), (_) async {
      date.value = DateFormat('d MMMM yyyy HH:mm:ss').format(await NTP.now());
    });

    super.onInit();
  }

  @override
  void onClose() {
    noEmployeeController.dispose();
    super.onClose();
  }

  getImage() async {
    final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    if (pickedImage != null) {
      XFile image = XFile(pickedImage.path);
      _cropImage(image);
    }
  }

  _cropImage(XFile imageFile) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
    );
    if (cropped != null) {
      // convert image to base64
      image.value = XFile(cropped.path);
      // final bytes = Io.File(cropped.path).readAsBytesSync();
      imageBase64.value = base64Encode(await image.value.readAsBytes());
    }
  }

  // /// ambil posisi sesuai dengan lokasi saat ini
  // Future<Position> getPosition() async {
  //   await Geolocator.isLocationServiceEnabled().then((value) {
  //     if (!value) {
  //       return Future.error('Location services are disabled');
  //     }
  //   });

  //   permission = await Geolocator.checkPermission();

  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }

  //   return await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );
  // }

  // /// convert latlong to Address
  // _getAddressFromLatLong() async {
  //   try {
  //     List<Placemark> placemarks =
  //         await placemarkFromCoordinates(latitude.value, longitude.value);
  //     place.value = placemarks[0];
  //     // street, sublocal, local, subadministrative, administrative,country, postalcode

  //   } catch (e) {
  //     print(e);
  //   }
  // }

  /// check radius lokasi dari titik yang ditentukan

  /// submit presensi
  submit() async {
    // await getPosition().then((value) {
    //   print(value.latitude);
    //   print(value.longitude);
    //   latitude.value = value.latitude;
    //   longitude.value = value.longitude;
    //   _getAddressFromLatLong();
    // }).catchError((e) {
    //   print(e);
    // });
    final loc = Get.find<LocationService>();

    if (loc.geofence.isEmpty) {
      Get.snackbar(
        'Out of Location',
        'Anda berada di luar jangkauan lokasi PT. Medion',
        colorText: Colors.white,
        backgroundColor: Colors.red.shade300,
      );
    } else {
      PresensiProvider()
          .postPresensi(noEmployeeController.text, image.value,
              imageBase64.value, loc.latitude.value, loc.longitude.value)
          .then(
        (value) {
          if (value.status.isOk) {
            if (value.body["isSuccess"]) {
              Get.snackbar(
                'Success',
                'Anda Berhasil Melakukan Presensi',
                colorText: Colors.white,
                backgroundColor: Colors.green.shade300,
              );
            } else {
              Get.snackbar(
                'Failed',
                value.body['message'],
                colorText: Colors.white,
                backgroundColor: Colors.red.shade300,
              );
            }
          } else if (value.status.connectionError) {
            Get.snackbar('Failed', 'Connection Error');
          }
        },
      );
    }

    // // check lokasi
    // PresensiProvider()
    //     .checkLocation(latitude.value, longitude.value)
    //     .then((value) {
    //   if (value.status.isOk) {
    //     print(value.body);
    //     // kalau masih dalam radius lokasi, maka jalankan input presensi
    //     if (value.body['isSuccess']) {
    //       PresensiProvider()
    //           .postPresensi(noEmployeeController.text, image.value,
    //               imageBase64.value, latitude.value, longitude.value)
    //           .then(
    //         (value) {
    //           if (value.status.isOk) {
    //             if (value.body["isSuccess"]) {
    //               Get.snackbar(
    //                 'Success',
    //                 'Anda Berhasil Melakukan Presensi',
    //                 colorText: Colors.white,
    //                 backgroundColor: Colors.green.shade300,
    //               );
    //             } else {
    //               List<String> messages = value.body['message'].split('\n');
    //               messages.removeLast();

    //               Get.snackbar(
    //                 'Failed',
    //                 messages.map((e) => e + "\n").join(),
    //                 colorText: Colors.white,
    //                 backgroundColor: Colors.red.shade300,
    //               );
    //             }
    //           } else if (value.status.connectionError) {
    //             Get.snackbar('Failed', 'Connection Error');
    //           }
    //         },
    //       );
    //     } else {
    //       // kalau jauh dalam jangkauan radius, maka jalankan alert gagal, anda berada diluar jangkauan kantor
    //       Get.snackbar(
    //         'Failed',
    //         value.body['message'],
    //         colorText: Colors.white,
    //         backgroundColor: Colors.red.shade300,
    //       );
    //     }
    //   }
    // });
  }
}
