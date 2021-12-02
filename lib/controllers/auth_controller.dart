// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mgimo_dictionary/helpers/alerts.dart';
import 'package:mgimo_dictionary/services/api_services.dart';

enum UserStatus {
  IsAuthenticated,
  Authenticating,
  Unauthenticated,
  WrongCredentials
}

enum UserEditStatus { Initial, Loading }

class AuthController extends GetxController {
  UserStatus status = UserStatus.Unauthenticated;
//  Future<void> authUser() async {
//     status = UserStatus.Authenticating;
//     update();
//     try {
//       dio.Response response = await loginApi(email, password);
//       final result = response.data;
//       if (result != null && result.containsKey('id')) {
//         Hive.box('main').put('user', result);
//         status = UserStatus.IsAuthenticated;
//           Get.off(() => SellerScreen());
//       } else {
//         status = UserStatus.WrongCredentials;
//         String errorMessage = result['message'];
//         if (result['code'] == 0) {
//           errorMessage =
//               'Неверный email или пароль. Проверьте правильность данных.';
//         }
//         errorAlert(errorMessage);
//       }
//       // SharedPreferences session = await SharedPreferences.getInstance();
//       // session.getBool(key)
//     } on dio.DioError catch (error) {
//       String errorMessage = error.response!.data.toString();
//       if (error.response!.data.containsKey('code') &&
//           error.response!.data['code'] == 0) {
//         errorMessage =
//             'Неверный email или пароль. Проверьте правильность данных.';
//       }
//       errorAlert(errorMessage);
//       status = UserStatus.WrongCredentials;
//     } catch (error) {
//       errorAlert(error);
//       status = UserStatus.Unauthenticated;
//     } finally {
//       update();
//     }
//   }

  // Future<void> logout() async {
  //   await Hive.box('main').delete('user');
  //   status = UserStatus.Unauthenticated;
  //  await Get.offAll(const AuthScreen());
  // }

}
