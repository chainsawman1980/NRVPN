import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import 'package:nizvpn/ui/screens/auth/cache_service.dart';


class AuthMiddleware extends GetMiddleware {
  final CacheService _cacheService = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    if (!_cacheService.isLogin()) {
      return RouteSettings(name: AppRoutes.LoginPage);
    }
  }
}
