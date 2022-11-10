import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:nizvpn/easy_local/easy_localization.dart';
import 'package:nizvpn/ui/screens/signup/signup_controller.dart';
import 'package:uuid/uuid.dart';

import '../../routes/app_routes.dart';
import '../../widgets/constant/http_url.dart';
import '../../widgets/flat_widget.dart';
import '../auth/Loading_overlay.dart';


class SignupScreen extends GetView<SignupController> {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // LoadingOverlay overlay = LoadingOverlay.of(context);
    final ThemeData theme = Theme.of(Get.context!);
    final ColorScheme colorScheme = theme.colorScheme;
    log("getcapte captatext:"+controller.captaText.value);

    return Scaffold(
      appBar: AppBar(
        title: Text('signup'.trs()),
        leading: IconButton(
          color: colorScheme.onPrimary,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            // onBackPressed();
            var canPop = navigator?.canPop();
            if (canPop != null && canPop) {
              Get.back();
            } else {
              SystemNavigator.pop();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.signupFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/icons/logo_android.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      'cp_gcpay'.trs(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    // <-- Your width
                    height: 50, // <-- Your height
                    child: TextFormField(
                      key: controller.formUsernameFieldKey,
                      controller: controller.phoneNumController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.phone_android),
                        hintText: 'login_phonenum_hint'.trs(),
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                      focusNode: controller.usernameFocusNode,
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: controller.usernameValidator,
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding:
                          EdgeInsets.only(left: 0, right: 0, top: 0),
                          child: SizedBox(
                            // <-- Your width
                            height: 50, // <-- Your height
                            child: TextFormField(
                              key: controller.formTrc20FieldKey,
                              controller: controller.phoneVerifyCodeController,
                              focusNode: controller.trc20FocusNode,
                              decoration: InputDecoration(
                                icon: Icon(Icons.sms),
                                suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                                suffixIcon: Container(
                                  width: 120,
                                  child: Obx(() =>FlatButtonX(
                                    disabledColorx:
                                    Colors.grey.withOpacity(0.1), //按钮禁用时的颜色
                                    disabledTextColorx: Colors.white, //按钮禁用时的文本颜色
                                    textColorx: controller.isButtonEnable.value
                                        ? Colors.white
                                        : Colors.black.withOpacity(0.2), //文本颜色
                                    colorx: controller.isButtonEnable.value
                                        ? colorScheme.primary
                                        : Colors.grey.withOpacity(0.1), //按钮的颜色
                                    shapex: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(50),
                                        ),
                                        side:
                                        BorderSide(color: Colors.grey, width: 0.5)),
                                    onPressedx: () {
                                      if (controller.isButtonEnable.value) {
                                        controller.buttonClickListen();
                                      }
                                    },
                                    childx: Text(
                                      controller.buttonText.value,
                                      style: const TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  )),
                                ),
                                hintText: 'login_verifycode_hint'.trs(),
                                hintStyle: TextStyle(fontSize: 14),
                              ),
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              validator: controller.passwordValidator,
                              // obscureText: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 10,
                  ),
                  SizedBox(
                    // <-- Your width
                    height: 50, // <-- Your height
                    child: TextFormField(
                      key: controller.formPasswordFieldKey,
                      controller: controller.passwordController,
                      focusNode: controller.passwordFocusNode,
                      decoration: InputDecoration(
                        icon: Icon(Icons.security),
                        hintText: 'login_password_hint'.trs(),
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: controller.passwordValidator,
                      obscureText: true,
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  SizedBox(
                    // <-- Your width
                    height: 50, // <-- Your height
                    child: TextFormField(
                      key: controller.formConfirmPasswordFieldKey,
                      controller: controller.confirmPasswordController,
                      focusNode: controller.confirmPasswordFocusNode,
                      decoration: InputDecoration(
                        icon: Icon(Icons.security),
                        hintText: 'login_passwordagain_hint'.trs(),
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: controller.confirmPasswordValidator,
                      obscureText: true,
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  SizedBox(
                    // <-- Your width
                    height: 50, // <-- Your height
                    child: TextFormField(
                      key: controller.formInviteCodeFieldKey,
                      controller: controller.payCodeController,
                      focusNode: controller.inviteCodeFocusNode,
                      decoration: InputDecoration(
                        icon: Image.asset(
                          "assets/images/Icon_invitecode.png",
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                        hintText: 'pay_code_hint'.trs(),
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: false,
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  SizedBox(
                    width: 250, // <-- Your width
                    height: 50, // <-- Your height
                    child: ElevatedButton(
                        onPressed: () async {
                          if (controller.signupFormKey.currentState!
                              .validate()) {
                            LoadingOverlay.show(message: 'Loading...'.trs());
                            try {
                              await controller.signup();
                              controller.signupFormKey.currentState!.save();
                              log('response signup');
                              Get.back(closeOverlays: true);
                              Get.toNamed(AppRoutes.LoginPage);
                            } catch (err, _) {
                              printError(info: err.toString());
                              LoadingOverlay.hide();
                              Get.snackbar(
                                "error".trs(),
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
                          }
                        },
                        child: Text(
                          'signup'.trs(),
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                  Container(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('haveaccount'.trs()),
                        Text(
                          'loginnow'.trs(),
                          style: TextStyle(color: Colors.blue),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
