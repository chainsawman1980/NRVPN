
import 'package:get/get.dart';
import 'package:nizvpn/ui/widgets/res/theme_page.dart';

import '../screens/auth/connectivity_service.dart';


class AppBinding extends Bindings {
  @override
  void dependencies() {
    injectService();
    Get.put(ThemeController(), permanent: true);
  }

  void injectService() {
    Get.put(ConnectivityService());
  }
}
