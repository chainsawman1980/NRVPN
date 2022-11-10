
import 'package:get/get.dart';

import '../auth/auth_api_service.dart';
import 'package:nizvpn/ui/screens/auth/cache_service.dart';
import 'login_controller.dart';
import 'package:nizvpn/ui/screens/http/gcpay_api.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<LoginController>(() =>
        LoginController(Get.find<AuthApiService>(), Get.find<CacheService>(),Get.find<GCPayApi>()));
  }
}
