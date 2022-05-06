import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/presensi_controller.dart';

class PresensiPage extends StatelessWidget {
  PresensiPage({Key? key}) : super(key: key);

  final presC = Get.find<PresensiController>();
  final loginC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Presensi Chaka'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                title: 'Logout',
                middleText: 'Apakah anda yakin ingin logout?',
                textCancel: 'Tidak',
                textConfirm: 'Ya',
                onConfirm: () {
                  Get.back();
                  loginC.logout();
                },
              );
            },
            icon: Icon(Icons.logout_rounded),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              // judul
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.3,
                child: const Text(
                  'Chaka',
                  style: const TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // form
              Obx(
                () => Form(
                  key: presC.formKey.value,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // tanggal dan jam
                        Container(
                          child: Text(
                            '1) ${presC.date.value}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // employee number
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '2) Employee No.',
                              style: TextStyle(fontSize: 20),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: TextFormField(
                                controller: presC.noEmployeeController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // foto lokasi
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '3) Foto Lokasi (selfie)',
                              style: TextStyle(fontSize: 20),
                            ),
                            InkWell(
                              onTap: () {
                                presC.getImage();
                              },
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration:
                                    const BoxDecoration(color: Colors.grey),
                                child: presC.image.value.path != ''
                                    ? Image.file(
                                        File(presC.image.value.path),
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.camera_alt),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),

                        // cek lokasi
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${presC.latitude}, ${presC.longitude}'),
                            ElevatedButton(
                              onPressed: () async {
                                await presC.getPosition();
                              },
                              child: Text('Cek Lokasi'),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // tombol submit
                        ElevatedButton(
                          onPressed: () async {
                            if (presC.image.value.path.isNotEmpty &&
                                presC.formKey.value.currentState!.validate() &&
                                presC.latitude != null &&
                                presC.longitude != null) {
                              presC.submit();
                            } else {
                              Get.defaultDialog(
                                title: 'Presensi Gagal',
                                middleText: 'Semua data harus diisi',
                                textCancel: 'OK',
                              );
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 40,
                            child: Text(
                              'Submit',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
