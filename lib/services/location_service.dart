import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as gc;
import 'package:geofence_service/geofence_service.dart';
import 'package:get/get.dart';

class LocationService extends GetxController {
  final geofenceService = GeofenceService.instance.setup(
    interval: 5000,
    accuracy: 100,
    loiteringDelayMs: 60000,
    statusChangeDelayMs: 10000,
    useActivityRecognition: false,
    allowMockLocations: false,
    printDevLog: false,
    geofenceRadiusSortType: GeofenceRadiusSortType.DESC,
  );

  var geofence = {}.obs;

  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var place = gc.Placemark().obs;

  /// buat list titik patokan lokasi beserta jarak toleransi radiusnya
  final geofenceList = [
    Geofence(
      id: 'medion_bc',
      latitude: -6.940788,
      longitude: 107.582877,
      radius: [
        GeofenceRadius(id: 'radius_100m', length: 100),
        // GeofenceRadius(id: 'radius_200m', length: 200),
      ],
    ),
    Geofence(
      id: 'medion_cr',
      latitude: -6.865867,
      longitude: 107.5031794,
      radius: [
        GeofenceRadius(id: 'radius_200m', length: 200),
      ],
    ),
  ];

  /// fungsi yang dipanggil ketika status geofence berubah
  Future<void> _onGeofenceStatusChanged(
    Geofence geofence,
    GeofenceRadius geofenceRadius,
    GeofenceStatus geofenceStatus,
    Location location,
  ) async {
    this.geofence.value = geofence.toJson();
    latitude.value = location.latitude;
    longitude.value = location.longitude;
    print(geofence.toJson().toString());
  }

  // void _onLocationChanged(Location location) {
  //   latitude.value = location.toJson()['latitude'];
  //   longitude.value = location.toJson()['longitude'];
  //   print(location.toJson());
  // }

  /// convert latlong to Address
  _getAddressFromLatLong() async {
    try {
      List<gc.Placemark> placemarks =
          await gc.placemarkFromCoordinates(latitude.value, longitude.value);
      place.value = placemarks[0];
      // street, sublocal, local, subadministrative, administrative, country, postalcode
    } catch (e) {
      print(e);
    }
  }

  // handle error
  void _onError(error) {
    final errorCode = getErrorCodesFromError(error);
    if (errorCode == null) {
      print('Undefined error: $error');
      return;
    }
    print('ErrorCode: $errorCode');
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      geofenceService.addGeofenceStatusChangeListener(_onGeofenceStatusChanged);
      // geofenceService.addLocationChangeListener(_onLocationChanged);
      geofenceService.addStreamErrorListener(_onError);
      geofenceService.start(geofenceList).catchError(_onError);
    });
  }
}
