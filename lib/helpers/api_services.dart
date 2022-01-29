import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Config {
  static const baseUrl = 'http://89.223.65.168/api/v1';
}

final dio = Dio(
  BaseOptions(
    baseUrl: Config.baseUrl,
    contentType: Headers.jsonContentType,
    headers: {
      'X-CSRFToken':
          '${Hive.box('main').get('token', defaultValue: {}).isNotEmpty ? Hive.box('main').get('token', defaultValue: {})['access'] : Hive.box('main').get('tokens', defaultValue: {})['access_token']}'
    },
  ),
);

final dio2 = Dio(
  BaseOptions(
    baseUrl: Config.baseUrl,
    contentType: Headers.jsonContentType,
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

Future getUniversityApi() async {
  await checkConnection();
  return dio2.get(
    '/universities/1/',
  );
}

Future getCoursesApi() async {
  await checkConnection();
  return dio2.get(
    '/universities/course/',
  );
}

Future registerApi(data) async {
  await checkConnection();
  return dio2.post(
    '/registrations/',
    data: data,
  );
}

Future getAccessTokenApi(data) async {
  await checkConnection();
  return dio.post(
    '/token/refresh/',
    data: data,
  );
}

Future getSearchApi(String word) async {
  return dio.get(
    '/dictionary/search/?',
    queryParameters: {'word': word},
  );
}
