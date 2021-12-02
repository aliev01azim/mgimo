import 'package:get/get.dart';
import 'package:mgimo_dictionary/controllers/auth_controller.dart';
import 'package:mgimo_dictionary/controllers/distribution_controller.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<DistributionController>(() => DistributionController());
  }
}
