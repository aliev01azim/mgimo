// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:mgimo_dictionary/helpers/alerts.dart';
import 'package:mgimo_dictionary/pages/main_page.dart';

import '../helpers/api_services.dart';
import '../main.dart';
import '../pages/start_pages/course.dart';
import '../pages/start_pages/facultet.dart';

enum UserStatus {
  IsAuthenticated,
  Authenticating,
}

enum UserEditStatus { Initial, Loading }

class AuthController extends GetxController {
  UserStatus _status = UserStatus.IsAuthenticated;
  String _email = '';
  List _facutets = [];
  UserStatus get status => _status;
  String get email => _email;
  List get facultets => _facutets;

  Future<void> authUser(int course) async {
    _status = UserStatus.Authenticating;
    update();
    try {
      final data = {
        'email': email,
        'gender': 'male',
        'course': course,
      };
      print(data);
      dio.Response response = await registerApi(data);
      final result = response.data;
      print('result1 : $result');
      if (result != null) {
        await Hive.box('main').put('tokens', result);
        await Get.offAll(() => const MainPage());
        // dio.Response response2 = await getAccessTokenApi(data);
        // var result2 = response2.data;
        // if (result2 != null) {

        // }
      }
    } on dio.DioError catch (error) {
      print('result1 : $error');
      errorAlert(error);
    } catch (error) {
      errorAlert(error);
    } finally {
      _status = UserStatus.IsAuthenticated;
      update();
    }
  }

  Future<void> logout() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    // await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    await Hive.box('main').delete('user');
    await Hive.box('main').delete('userChoices');
    await Get.offAll(const MyHomePage());
  }

  Future<void> googleSignIn() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    _status = UserStatus.Authenticating;
    update();
    try {
      final result = await _googleSignIn.signIn();
      if (result != null) {
        print(
            'objecttretettttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt : $result');
        _email = result.email;
        final Map _user = {
          'id': result.id,
          'displayName': result.displayName,
          'email': result.email,
          'photoUrl': result.photoUrl,
          'serverAuthCode': result.serverAuthCode,
        };
        await Hive.box('main').put('user', _user);
        await Get.offAll(() => Facultet());
      } else {
        const String errorMessage =
            'Не удалось зарегестрировать. Возможно,проблемы с вашим аккаунтом';
        errorAlert(errorMessage);
      }
    } catch (error) {
      log(error.toString());
      errorAlert(error);
    } finally {
      _status = UserStatus.IsAuthenticated;
      update();
    }
  }

  Future<void> getFacultets() async {
    _status = UserStatus.Authenticating;

    try {
      dio.Response response = await getUniversityApi();
      final result = response.data;
      print(result);
      if (result != null) {
        _facutets = result['faculties'];
      }
    } catch (e) {
      print('facultetsError : $e');
      errorAlert(e);
    } finally {
      _status = UserStatus.IsAuthenticated;
      update();
    }
  }

  List getCourse(name) {
    final facultet = _facutets.firstWhere((element) => element['name'] == name);
    return facultet['courses'];
  }
}
