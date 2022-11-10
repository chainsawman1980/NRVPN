import 'package:event_bus/event_bus.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/http/gcpay_api.dart';

///初始化注入对象
class Injection extends GetxService {
  Future<void> init() async {
    await Get.putAsync(() => SharedPreferences.getInstance());
    Get.lazyPut(() => GCPayApi(), fenix: true);
    Get.lazyPut(() => EventBus(), fenix: true);
  }
}
