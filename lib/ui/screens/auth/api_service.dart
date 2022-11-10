import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import 'package:nizvpn/ui/widgets/constant/http_url.dart';
import 'auth_api_service.dart';
import 'auth_controller.dart';

class ApiService extends GetConnect {
  int retry = 0;

  @override
  void onInit() {
    httpClient.baseUrl = HttpUrl.BASE_URL;
    httpClient.timeout = const Duration(seconds: 15);
    httpClient.maxAuthRetries = retry = 3;
    httpClient.followRedirects = true;


    httpClient.addRequestModifier<dynamic>((request) async {
      log('addRequestModifier ${request.url.toString()}');

      AuthController authController = Get.find();
      if (authController.isAuthenticated()) {
        request.headers['Authorization'] =
            'Bearer ${authController.token()!}';
      } else {
        request.headers['Authorization'] = 'Basic ' +
            base64Encode(
                utf8.encode(HttpUrl.clientId + ':' + HttpUrl.clientSecret));
      }
      return request;
    });
  }

  bool isLoginRequest(request) {
    return (HttpUrl.BASE_URL + AuthApiService.signInUrl ==
        request.url.toString());
  }
}
