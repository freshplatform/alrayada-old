import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/data/location/location_api_entity.dart';
import '/services/networking/http_clients/dio/s_dio.dart';

class IpApiException implements Exception {

  IpApiException(this.message);
  final String message;

  @override
  String toString() => message.toString();
}

class LocationService {
  LocationService._();

  static const url = 'https://ipapi.co/json';
  static const locationKeyPrefKey = 'locationIp';

  static Future<IpGeoLocation?> getIpLocation() async {
    try {
      final response = await DioService.getDio().get<Map<String, dynamic>>(url);
      if (response.data == null || (response.statusCode ?? 500) != 200) {
        throw IpApiException(response.data.toString());
      }
      final value = IpGeoLocation.fromJson(response.data!);
      _saveCachedIpLocation(jsonEncode(value));
      return value;
    } on DioException {
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Unhandled exception: $e');
      }
      return null;
    }
  }

  static Future<void> _saveCachedIpLocation(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(locationKeyPrefKey, value);
  }

  static Future<IpGeoLocation?> getCachedIpLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonValue = prefs.getString(locationKeyPrefKey);
      if (jsonValue == null) return null;
      final Map<String, dynamic> value = json.decode(jsonValue);
      return IpGeoLocation.fromJson(value);
    } catch (e) {
      if (kDebugMode) {
        print('Unhandled error on getCachedIpLocation, type: ${e.runtimeType}');
      }
      return null;
    }
  }
}
