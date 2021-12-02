import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class Config {
  static const baseUrl = 'https://allahakbar.pythonanywhere.com';
}

final dio = Dio(
  BaseOptions(
    baseUrl: Config.baseUrl,
    contentType: Headers.formUrlEncodedContentType,
    headers: {
      'Authorization':
          'Bearer ${Hive.box('main').get('token', defaultValue: null)}'
    },
  ),
);

final dio2 = Dio(
  BaseOptions(
    baseUrl: Config.baseUrl,
    contentType: Headers.formUrlEncodedContentType,
  ),
);
Future<bool> checkConnection() async {
  try {
    if (!kIsWeb) {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }

      throw ('Нет интернет соединения');
    }
    return true;
  } on SocketException catch (_) {
    throw ('Нет интернет соединения');
  }
}

Future registerApi(String number) async {
  await checkConnection();
  return dio2.post(
    '/api/user/register',
    data: {'username': number},
  );
}

Future editAccountApi(data) async {
  await checkConnection();

  return dio.post(
    '/api/users/settings',
    data: data,
  );
}

Future resetPasswordApi(String code, String password) async {
  await checkConnection();

  return dio.post(
    '/api/user/reset-password',
    data: {'code': code, 'password': password},
  );
}

Future addToFavoritesApi(int id) async {
  await checkConnection();

  return dio.post(
    '/api/user-favorite-products/add?product_id=$id',
  );
}

Future getFavoritesApi() async {
  await checkConnection();

  return dio.get(
    '/api/user-favorite-products/list',
  );
}

Future removeFavoriteApi(int id) async {
  await checkConnection();

  return dio.post(
    '/api/user-favorite-products/remove?product_id=$id',
  );
}
