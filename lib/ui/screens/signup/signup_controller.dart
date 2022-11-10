import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:platform_device_id/platform_device_id.dart';
import 'package:uuid/uuid.dart';

import '../../widgets/constant/http_url.dart';
import '../auth/Loading_overlay.dart';
import '../auth/auth_api_service.dart';
import '../auth/auth_controller.dart';
import 'package:nizvpn/ui/screens/auth/cache_service.dart';
import 'package:nizvpn/ui/screens/http/gcpay_api.dart';

class SignupController extends AuthController {
  final GlobalKey<FormState> signupFormKey =
      GlobalKey<FormState>(debugLabel: '__signupFormKey__');
  final phoneNumController = TextEditingController();
  final formUsernameFieldKey = GlobalKey<FormFieldState>();
  final phoneVerifyCodeController = TextEditingController();
  final formTrc20FieldKey = GlobalKey<FormFieldState>();
  final emailController = TextEditingController();
  final formEmailFieldKey = GlobalKey<FormFieldState>();
  final passwordController = TextEditingController();
  final formPasswordFieldKey = GlobalKey<FormFieldState>();
  final confirmPasswordController = TextEditingController();
  final formConfirmPasswordFieldKey = GlobalKey<FormFieldState>();
  final payCodeController = TextEditingController();
  final formInviteCodeFieldKey = GlobalKey<FormFieldState>();

  FocusNode usernameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode trc20FocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  FocusNode inviteCodeFocusNode = FocusNode();

  RxBool isButtonEnable = false.obs;      //按钮初始状态  是否可点击
  RxInt count = 60.obs;                     //初始倒计时时间
  Timer? timer;
  RxString buttonText = '发送验证码'.obs;   //初始文本
  RxString captaText = HttpUrl.DEVICE_UUID.obs;

  SignupController(
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
            buttonText.value = '重新发送('+ count.value.toString() +')'; //更新文本内容 //更新文本内容
          }
        });
  }

  Future<void> buttonClickListen() async {
    if (isButtonEnable.value) {
      //当按钮可点击时
      isButtonEnable.value = false; //按钮状态标记
      try {
        await sendRegsmscode();
        log('response signup');
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
    super.onInit();
    _addListener();
    // textFieldFocusNode.hasFocus = false;
    initTimer();
    String? deviceId = await PlatformDeviceId.getDeviceId;
    log("signup controller" + deviceId!);
    captaText.value = deviceId;
    phoneVerifyCodeController.text='';
    phoneNumController.text='';
  }

  void _addListener() {
    usernameFocusNode.addListener(() {
      log('usernameFocusNode-----${usernameFocusNode.hasFocus}');
      if (!usernameFocusNode.hasFocus) {
        formUsernameFieldKey.currentState!.validate();
        // fieldLostFocus = usernameController.hashCode.toString();
      }
    });
    emailFocusNode.addListener(() {
      log('emailFocusNode-----${emailFocusNode.hasFocus}');
      if (!emailFocusNode.hasFocus) {
        formEmailFieldKey.currentState!.validate();
      }
    });
    passwordFocusNode.addListener(() {
      if (!passwordFocusNode.hasFocus) {
        formPasswordFieldKey.currentState!.validate();
      }
    });
    confirmPasswordFocusNode.addListener(() {
      if (!confirmPasswordFocusNode.hasFocus) {
        formConfirmPasswordFieldKey.currentState!.validate();
      }
    });

    inviteCodeFocusNode.addListener(() {
      if (!inviteCodeFocusNode.hasFocus) {
        formInviteCodeFieldKey.currentState!.validate();
      }
    });
  }

  @override
  void onClose() {
    phoneNumController.dispose();
    usernameFocusNode.dispose();
    emailController.dispose();
    emailFocusNode.dispose();
    passwordController.dispose();
    passwordFocusNode.dispose();
    confirmPasswordController.dispose();
    confirmPasswordFocusNode.dispose();
    payCodeController.dispose();
    inviteCodeFocusNode.dispose();
    timer?.cancel();
    timer=null;
    super.onClose();
  }

  String? usernameValidator(String? value) {
    // if(fieldLostFocus == usernameController.hashCode)
    log('usernameValidator-----');
    if (value == null || value.trim().isEmpty) {
      return 'Please this field must be filled'.tr;
    }
    if (value.trim().length < 4) {
      return 'Username must be at least 4 characters in length'.tr;
    }
    // Return null if the entered username is valid
    return null;
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

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please this field must be filled'.tr;
    }
    log('${value}--${passwordController.value.text}');
    if (value != passwordController.value.text) {
      return 'Confirmation password does not match the entered password'.tr;
    }

    return null;
  }

  String? validator(String? value) {
    log('validatoooor');

    if (value != null && value.isEmpty) {
      return 'Please this field must be filled'.tr;
    }
    return null;
  }


  Future<void> signup() async {
    log('${emailController.text}, ${passwordController.text}');
    if (signupFormKey.currentState!.validate()) {
      try {

        await signUp(<String, String>{
          'nickname': phoneNumController.text,
          'captcha': phoneVerifyCodeController.text,
          'loginPassword': passwordController.text,
          'payPassword': payCodeController.text,
          'deviceId': captaText.value,
        });
      } catch (err, _) {
        // message = 'There is an issue with the app during request the data, '
        //         'please contact admin for fixing the issues ' +

        passwordController.clear();
        confirmPasswordController.clear();
        rethrow;
      }
    } else {
      throw Exception('An error occurred, invalid inputs value'.tr);
    }
  }

  Future<void> sendRegsmscode() async {
    log('${phoneNumController.text}, ${phoneNumController.text}');

    try {

      await senRegSmsCode(<String, String>{
        'regType': phoneNumController.text,
        'key': phoneNumController.text,
      });
    } catch (err, _) {
      // message = 'There is an issue with the app during request the data, '
      //         'please contact admin for fixing the issues ' +

      phoneVerifyCodeController.clear();
      rethrow;
    }
  }

}
