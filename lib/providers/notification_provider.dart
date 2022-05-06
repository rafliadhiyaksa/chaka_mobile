import 'dart:convert';

import 'package:get/get.dart';

class NotificationProvider extends GetConnect {
  // post notification
  Future<Response> getAllNotifications() async {
    try {
      String username = 'Medion';
      String password = '4dmin@Ch4k4';

      var response = await post(
        'http://chaka.medionindonesia.com:2005/api/v1/GetNotification',
        {},
        headers: {
          "Authorization":
              "Basic ${base64Encode(utf8.encode('$username:$password'))}",
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateNotification(int id) async {
    try {
      String username = 'Medion';
      String password = '4dmin@Ch4k4';

      Map<String, dynamic> body = {};

      var response = await post(
        'http://chaka.medionindonesia.com:2005/api/v1/UpdateNotification/$id',
        body,
        headers: {
          "Authorization":
              "Basic ${base64Encode(utf8.encode('$username:$password'))}",
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
      );
      return response;
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }
}
