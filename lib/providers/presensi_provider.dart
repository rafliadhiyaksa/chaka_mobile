import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ntp/ntp.dart';

class PresensiProvider extends GetConnect {
  // submit data presensi
  Future<Response> postPresensi(String noEmployee, XFile image,
      String imageBase64, double? latitude, double? longitude) async {
    try {
      DateTime now = await NTP.now();
      String username = 'Medion';
      String password = '4dmin@Ch4k4';

      final body = jsonEncode({
        "employeenumber": noEmployee,
        "date": now.toString(),
        "foto": imageBase64,
        "latitude": latitude,
        "longitude": longitude,
        "filename": image.path.split('/').last,
      });

      var response = await post(
        "http://chaka.medionindonesia.com:2005/api/v1/SubmitAttendance",
        body,
        headers: {
          "Authorization":
              "Basic ${base64Encode(utf8.encode('$username:$password'))}",
          "Content-Type": "application/json"
        },
      );
      print(noEmployee);
      print(now.toString());
      print(imageBase64);
      print(latitude);
      print(longitude);
      print(image.path.split('/').last);
      print('status code = ' + response.statusCode.toString());
      return response;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // cek radius lokasi saat ini dengan titik pusat
  Future<Response> checkLocation(double? latitude, double? longitude) async {
    try {
      final body = jsonEncode({
        "latitude": latitude,
        "longitude": longitude,
      });

      var response = await post('api untuk cek lokasi', body);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
