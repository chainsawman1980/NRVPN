import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:nizvpn/ui/screens/auth/auth_controller.dart';
import 'package:nizvpn/ui/screens/auth/auth_api_service.dart';
import 'package:nizvpn/ui/screens/auth/cache_service.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:platform_device_id/platform_device_id.dart';

import 'package:nizvpn/ui/screens/http/gcpay_api.dart';



class LoginController extends AuthController {
  final GlobalKey<FormState> loginFormKey =
      GlobalKey<FormState>(debugLabel: '__loginFormKey__');
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final verifycodeController = TextEditingController();
  final formTrc20FieldKey = GlobalKey<FormFieldState>();

  FocusNode trc20FocusNode = FocusNode();
  RxBool isButtonEnable = false.obs;      //按钮初始状态  是否可点击
  RxInt count = 60.obs;                     //初始倒计时时间
  Timer? timer;
  RxString buttonText = '60'.obs;   //初始文本
  RxString captaText = ''.obs;   //图形验证码

  LoginController(
      AuthApiService authenticationService, CacheService cacheServices,GCPayApi gcpayapi)
      : super(authenticationService, cacheServices,gcpayapi);

  void initTimer() {
    timer =
        Timer.periodic(const Duration(seconds: 1), (Timer timer) {
          count--;

          if (count == 0) {
            timer.cancel(); //倒计时结束取消定时器
            isButtonEnable.value = true; //按钮可点击
            count.value = 60; //重置时间
            buttonText.value = ''; //重置按钮文本
          } else {
            buttonText.value = count.value.toString(); //更新文本内容
          }
        });
  }

  Future<void> buttonClickListen() async {
    if (isButtonEnable.value) {
      //当按钮可点击时
      isButtonEnable.value = false; //按钮状态标记
      initTimer();
    }
  }

  @override
  Future<void> onInit() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    captaText.value = deviceId!;
    log("login controller" + deviceId);
    initTimer();
    ImageCache  imageCache = PaintingBinding.instance.imageCache;
    imageCache.clear();
    imageCache.clearLiveImages();
  }
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    timer?.cancel();
    timer=null;
    super.onClose();
  }

  String? validator(String? value) {
    log('validatoooor');

    if (value != null && value.isEmpty) {
      return 'Please this field must be filled'.tr;
    }
    return null;
  }

//  "password": "string",
//   "playerName": "string",
//   "trc20Address": "string"
  Future<void> login() async {
    log('${emailController.text}, ${passwordController.text}');
    if (loginFormKey.currentState!.validate()) {
      try {
        await signIn(<String, String>{
          'nickname': emailController.text,
          'loginPassword': passwordController.text,
          'captcha': verifycodeController.text,
          'deviceId': captaText.value,
        });
      } catch (err, _) {
        // message = 'There is an issue with the app during request the data, '
        //         'please contact admin for fixing the issues ' +

        //passwordController.clear();
        rethrow;
      }
    } else {
      throw Exception('An error occurred, invalid inputs value'.tr);
    }
  }

  Future<void> getCaptca() async {
      try {
        String? deviceId = await PlatformDeviceId.getDeviceId;
        String captchaResult = await api.captcha(<String, String>{
          'deviceId': deviceId!,
        });
        captaText.value = captchaResult;//base64String(captchaResult);
      } catch (err, _) {
        // message = 'There is an issue with the app during request the data, '
        //         'please contact admin for fixing the issues ' +

        //passwordController.clear();
        rethrow;
      }

  }

  String? passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please this field must be filled'.tr;
    }
    if (value.trim().length < 3) {
      return 'Password must be at least 8 characters in length'.tr;
    }
    // Return null if the entered password is valid
    return null;
  }
}
