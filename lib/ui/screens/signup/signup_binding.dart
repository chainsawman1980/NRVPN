
import 'package:get/get.dart';
import 'package:nizvpn/ui/screens/signup/signup_controller.dart';

import '../auth/auth_api_service.dart';
import 'package:nizvpn/ui/screens/auth/cache_service.dart';
import 'package:nizvpn/ui/screens/http/gcpay_api.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(() =>
        SignupController(Get.find<AuthApiService>(), Get.find<CacheService>(),Get.find<GCPayApi>()));
  }
}
