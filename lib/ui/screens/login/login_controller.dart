import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nizvpn/easy_local/easy_localization.dart';

import 'package:nizvpn/ui/screens/auth/auth_controller.dart';
import 'package:nizvpn/ui/screens/auth/auth_api_service.dart';
import 'package:nizvpn/ui/screens/auth/cache_service.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:platform_device_id/platform_device_id.dart';

import 'package:nizvpn/ui/screens/http/gcpay_api.dart';

import '../../widgets/utils/validate_utils.dart';
import '../auth/Loading_overlay.dart';



class LoginController extends AuthController {
  final GlobalKey<FormState> loginFormKey =
      GlobalKey<FormState>(debugLabel: '__loginFormKey__');
  final emailController = TextEditingController();
  final verifycodeController = TextEditingController();
  final formLoginVerifyCodeFieldKey = GlobalKey<FormFieldState>();
  final formLoginEmailFieldKey = GlobalKey<FormFieldState>();

  FocusNode loginEmailFocusNode = FocusNode();
  FocusNode loginVerifyCodeFocusNode = FocusNode();
  RxBool isButtonEnable = true.obs;      //按钮初始状态  是否可点击
  RxInt count = 60.obs;                     //初始倒计时时间
  Timer? timer;
  RxString buttonText = '发送验证码'.obs;   //初始文本
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
            buttonText.value = '发送验证码'; //重置按钮文本
          } else {
            buttonText.value = '重新发送('+ count.value.toString() +')'; //更新文本内容
          }
        });
  }

  Future<void> buttonClickListen() async {
    if(emailController.text.length < 0)
    {
      Fluttertoast.showToast(msg:"Phonenum or Email must be filled".trs());
      return;
    }
    else if(!ValidateUtils().isEmail(emailController.text)&&!ValidateUtils().isChinaPhoneNumber(emailController.text))
    {
      Fluttertoast.showToast(msg:"Invalid mobile number or email".trs());
      return;
    }
    if (isButtonEnable.value) {
      //当按钮可点击时
      isButtonEnable.value = false; //按钮状态标记
      LoadingOverlay.show(message: 'verifycodesending'.trs());
      try {
        bool blSendSmsCode = await sendLoginsmscode();
        LoadingOverlay.hide();
        log('buttonClickListen response login');
      } catch (err, _) {
        printError(info: err.toString());
        LoadingOverlay.hide();
        Get.snackbar(
          "error".tr,
          err.toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(.75),
          colorText: Colors.white,
          icon: const Icon(Icons.error,
              color: Colors.white),
          shouldIconPulse: true,
          barBlur: 20,
        );
      } finally {}
      initTimer();
    }
  }

  @override
  Future<void> onInit() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    captaText.value = deviceId!;
    log("login controller" + deviceId);
    ImageCache  imageCache = PaintingBinding.instance.imageCache;
    imageCache.clear();
    imageCache.clearLiveImages();
    showSuccess();
  }
  @override
  void onClose() {
    emailController.dispose();
    loginEmailFocusNode.dispose();
    verifycodeController.dispose();
    loginVerifyCodeFocusNode.dispose();
    timer?.cancel();
    timer=null;
    super.onClose();
  }

  String? validator(String? value) {
    log('validatoooor');

    if (value != null && value.isEmpty) {
      return 'Please this field must be filled'.trs();
    }
    return null;
  }

//  "password": "string",
//   "playerName": "string",
//   "trc20Address": "string"
  Future<void> login() async {
    log('${emailController.text}, ${emailController.text}');
    if (loginFormKey.currentState!.validate()) {
      try {
        String strRegType = '';
        String strEmail = '';
        String strPhoneNum = '';
        if(ValidateUtils().isEmail(emailController.text))
        {
          strRegType = '2';
          strEmail = emailController.text;
        }
        else if(ValidateUtils().isChinaPhoneNumber(emailController.text))
        {
          strRegType = '1';
          strPhoneNum = emailController.text;
        }

        await signIn(<String, String>{
          'regType': strRegType,
          'email': strEmail,
          'phone': strPhoneNum,
          'verifyCode': verifycodeController.text,
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
          'regType': "2",
          'key': "lamyz0417@qq.com",
        });
        captaText.value = captchaResult;//base64String(captchaResult);
      } catch (err, _) {
        // message = 'There is an issue with the app during request the data, '
        //         'please contact admin for fixing the issues ' +

        //passwordController.clear();
        rethrow;
      }

  }

  String? userNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please this field must be filled'.trs();
    }
    if (!ValidateUtils().isEmail(value)&&!ValidateUtils().isChinaPhoneNumber(value)) {
      return 'Invalid mobile number or email'.trs();
    }
    // Return null if the entered password is valid
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please this field must be filled'.trs();
    }
    if (value.trim().length < 6) {
      return 'Password must be at least 6 characters in length'.trs();
    }
    // Return null if the entered password is valid
    return null;
  }

  String? verifyCodeValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please this field must be filled'.trs();
    }
    if (value.trim().length < 4) {
      return 'VerifyCode must be at least 4 characters in length'.trs();
    }
    // Return null if the entered password is valid
    return null;
  }


  Future<bool> sendLoginsmscode() async {
    log('${emailController.text}, ${emailController.text}');
    bool blLoginSmsCode = false;
    try {
      String strRegType = '';
      if(ValidateUtils().isEmail(emailController.text))
        {
          strRegType = '2';
        }
      else if(ValidateUtils().isChinaPhoneNumber(emailController.text))
        {
          strRegType = '1';
        }
      blLoginSmsCode = await sendLoginSmsCode(<String, String>{
        'regType': strRegType,
        'key': emailController.text,
      });
    } catch (err, _) {
      // message = 'There is an issue with the app during request the data, '
      //         'please contact admin for fixing the issues ' +
      verifycodeController.clear();
      rethrow;
    }
    return blLoginSmsCode;
  }
}
