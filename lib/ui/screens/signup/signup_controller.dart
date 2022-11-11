import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:nizvpn/easy_local/easy_localization.dart';
import 'package:nizvpn/ui/screens/http/base_result.dart';

import 'package:platform_device_id/platform_device_id.dart';
import 'package:uuid/uuid.dart';

import '../../widgets/constant/http_url.dart';
import '../../widgets/utils/validate_utils.dart';
import '../auth/Loading_overlay.dart';
import '../auth/auth_api_service.dart';
import '../auth/auth_controller.dart';
import 'package:nizvpn/ui/screens/auth/cache_service.dart';
import 'package:nizvpn/ui/screens/http/gcpay_api.dart';

class SignupController extends AuthController {
  final GlobalKey<FormState> signupFormKey =
      GlobalKey<FormState>(debugLabel: '__signupFormKey__');
  final phoneNumController = TextEditingController();
  final formPhoneNumFieldKey = GlobalKey<FormFieldState>();
  final verifyCodeController = TextEditingController();
  final formVerifyCodeFieldKey = GlobalKey<FormFieldState>();
  final emailController = TextEditingController();
  final formEmailFieldKey = GlobalKey<FormFieldState>();
  final passwordController = TextEditingController();
  final formPasswordFieldKey = GlobalKey<FormFieldState>();
  final confirmPasswordController = TextEditingController();
  final formConfirmPasswordFieldKey = GlobalKey<FormFieldState>();
  final payCodeController = TextEditingController();
  final formInviteCodeFieldKey = GlobalKey<FormFieldState>();

  FocusNode phoneNumFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode verifyCodeFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  FocusNode inviteCodeFocusNode = FocusNode();

  RxBool isButtonEnable = true.obs;      //按钮初始状态  是否可点击
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
    if(phoneNumController.text.length < 0)
      {
        Fluttertoast.showToast(msg:"Phonenum or Email must be filled".trs());
        return;
      }
    else if(!ValidateUtils().isEmail(phoneNumController.text)&&!ValidateUtils().isChinaPhoneNumber(phoneNumController.text))
      {
        Fluttertoast.showToast(msg:"Invalid mobile number or email".trs());
          return;
      }
    if (isButtonEnable.value) {
      //当按钮可点击时
      isButtonEnable.value = false; //按钮状态标记
      LoadingOverlay.show(message: 'verifycodesending'.trs());
      try {
        bool blSendSmsCode = await sendRegsmscode();
        LoadingOverlay.hide();
        log('buttonClickListen response signup');
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
    String? deviceId = await PlatformDeviceId.getDeviceId;
    log("signup controller" + deviceId!);
    captaText.value = deviceId;
    verifyCodeController.text='';
    phoneNumController.text='';
    emailController.text='';
  }

  void _addListener() {
    emailFocusNode.addListener(() {
      log('emailFocusNode-----${emailFocusNode.hasFocus}');
      if (!emailFocusNode.hasFocus) {
        formEmailFieldKey.currentState!.validate();
      }
    });

    phoneNumFocusNode.addListener(() {
      log('phoneNumFocusNode-----${phoneNumFocusNode.hasFocus}');
      if (!phoneNumFocusNode.hasFocus) {
        formPhoneNumFieldKey.currentState!.validate();
        // fieldLostFocus = usernameController.hashCode.toString();
      }
    });

    verifyCodeFocusNode.addListener(() {
      if (!verifyCodeFocusNode.hasFocus) {
        formVerifyCodeFieldKey.currentState!.validate();
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
    phoneNumFocusNode.dispose();
    emailController.dispose();
    emailFocusNode.dispose();
    verifyCodeController.dispose();
    verifyCodeFocusNode.dispose();
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

  String? passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please this field must be filled'.trs();
    }
    if (value.trim().length < 3) {
      return 'Password must be at least 8 characters in length'.tr;
    }
    // Return null if the entered password is valid
    return null;
  }

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please this field must be filled'.trs();
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
      return 'Please this field must be filled'.trs();
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please this field must be filled'.trs();
    }
    if (!ValidateUtils().isEmail(value)) {
      return 'Invalid email'.trs();
    }
    // Return null if the entered password is valid
    return null;
  }

  String? phoneNumValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please this field must be filled'.trs();
    }
    if (!ValidateUtils().isChinaPhoneNumber(value)) {
      return 'Invalid mobile number'.trs();
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

  Future<bool> signup() async {
    bool blSignSuccess = false;
    log('${phoneNumController.text}, ${phoneNumController.text}');
    if (signupFormKey.currentState!.validate()) {
      try {

        String strRegType = '';
        String strEmail = '';
        String strPhoneNum = '';
        if(ValidateUtils().isEmail(emailController.text))
        {
          strRegType = '2';
          strEmail = emailController.text;
          strPhoneNum = phoneNumController.text;
        }
        else if(ValidateUtils().isChinaPhoneNumber(phoneNumController.text))
        {
          strRegType = '2';
          strEmail = emailController.text;
          strPhoneNum = phoneNumController.text;
        }

        blSignSuccess = await signUp(<String, String>{
          'regType': strRegType,
          'email': strEmail,
          'phone': strPhoneNum,
          'verifyCode': verifyCodeController.text,
        });

      } catch (err, _) {
        // message = 'There is an issue with the app during request the data, '
        //         'please contact admin for fixing the issues ' +

        rethrow;
      }
    } else {
      throw Exception('An error occurred, invalid inputs value'.tr);
    }
    return blSignSuccess;
  }

  Future<bool> sendRegsmscode() async {
    log('${emailController.text}, ${emailController.text}');
    bool blRegVerifyCode = false;
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
      blRegVerifyCode = await sendRegSmsCode(<String, String>{
        'regType': strRegType,
        'key': emailController.text,
      });
    } catch (err, _) {
      // message = 'There is an issue with the app during request the data, '
      //         'please contact admin for fixing the issues ' +

      verifyCodeController.clear();
      rethrow;
    }
    return blRegVerifyCode;
  }

}
