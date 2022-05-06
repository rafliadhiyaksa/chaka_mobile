import 'dart:async';

import 'package:chaka_app/controllers/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xml/xml.dart';

import '../models/user.dart';
import '../providers/login_provider.dart';

class AuthController extends GetxController with CacheManager {
  late TextEditingController usernameController, passwordController;
  var loginSuccess = false.obs;
  var isLogged = false.obs;

  var user = User().obs;
  var tempDataUser = User().obs;

  final formKey = GlobalKey<FormState>().obs;

  var passwordVisible = false.obs;
  var rememberMe = false.obs;

  @override
  void onInit() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();

    super.onInit();
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();

    super.onClose();
  }

  Future<void> initializeSettings() async {
    checkLoginStatus();
  }

  Future<void> saveDataToStorage() async {
    user.value = tempDataUser.value;

    final dataLogin = {
      'username': user.value.username,
      'password': user.value.password,
    };
    await saveDataLogin(dataLogin);
  }

  void login() {
    LoginProvider()
        .login(usernameController.text, passwordController.text)
        .then((value) async {
      if (value.status.isOk) {
        final document = XmlDocument.parse(value.body);
        // validasi
        if (document.innerText.contains('benar')) {
          tempDataUser.value = User(
            username: usernameController.text,
            password: passwordController.text,
          );

          if (rememberMe.value) {
            await saveRememberMe({
              "username": usernameController.text,
              "password": passwordController.text,
            });
          } else {
            removeRememberMe().then((_) {
              usernameController.text = '';
              passwordController.text = '';
            });
          }

          isLogged.value = true;
          await saveDataToStorage();
        } else {
          Get.defaultDialog(
            title: 'Login Gagal',
            middleText: 'username dan password salah',
            textCancel: 'OK',
          );
        }
      } else if (value.status.connectionError) {
        Get.snackbar('Connection Error', 'No Internet Connection');
      }
    });
  }

  Future<void> checkLoginStatus() async {
    user.value = await getDataLogin();
    final dataRememberMe = await getRememberMe();

    if (dataRememberMe != null) {
      rememberMe.value = true;
      usernameController.text = dataRememberMe['username'];
      passwordController.text = dataRememberMe['password'];
    } else {
      rememberMe.value = false;
    }

    if (user.value.username != '' && user.value.password != '') {
      isLogged.value = true;
    }
  }

  Future<void> logout() async {
    isLogged.value = false;
    user.value = User();
    await removeDataLogin();
  }
}
