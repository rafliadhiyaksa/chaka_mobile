import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../widgets/custom_text_form_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final controller = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // judul
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'CHAKA MOBILE',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  'Use your chaka account bellow and login to your account',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 40),

          Container(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.07),
            child: Obx(
              () => Form(
                key: controller.formKey.value,
                child: Column(
                  children: [
                    CustomTextFormField(
                      hintText: 'username',
                      controller: controller.usernameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'username tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      hintText: 'password',
                      suffixIcon: InkWell(
                        onTap: () {
                          controller.passwordVisible.value =
                              !controller.passwordVisible.value;
                        },
                        child: Icon(controller.passwordVisible.value
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded),
                      ),
                      obscureText:
                          controller.passwordVisible.value ? false : true,
                      controller: controller.passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'password tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),

                    // remember me
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Checkbox(
                                splashRadius: 2,
                                visualDensity: VisualDensity.compact,
                                value: controller.rememberMe.value,
                                onChanged: (value) {
                                  controller.rememberMe.value = value!;
                                },
                              ),
                              Text('Remember me')
                            ],
                          ),
                        ),
                        Container(
                          child: TextButton(
                            onPressed: () {},
                            child: Text('Forgot Password?'),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30),

                    // login button
                    ElevatedButton(
                      onPressed: () {
                        if (controller.formKey.value.currentState!.validate()) {
                          controller.login();
                        }
                      },
                      style: ButtonStyle(),
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
