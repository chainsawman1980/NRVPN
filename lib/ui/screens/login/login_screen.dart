import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nizvpn/easy_local/easy_localization.dart';
import 'package:nizvpn/ui/widgets/base_stateful_widget.dart';

import 'package:uuid/uuid.dart';

import '../../page/webview_page.dart';
import '../../routes/app_routes.dart';
import '../../widgets/constant/http_url.dart';
import '../../widgets/flat_widget.dart';
import '../../widgets/utils/storage_prefs.dart';
import '../auth/Loading_overlay.dart';
import 'package:nizvpn/ui/screens/auth/cache_service.dart';
import 'login_controller.dart';

class LoginScreen extends BaseStatefulWidget<LoginController> {
  void openLanguageDialog() {
    SmartDialog.show(
      backDismiss: false,
      clickMaskDismiss: false,
      builder: (_) {
        return Container(
          height: 200,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          alignment: Alignment.topCenter,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    tooltip: '',
                    onPressed: () {
                      SmartDialog.dismiss();
                    },
                  ),
                ),
                InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/icons/flags/us.png',
                          height: 30,
                        ),
                        Text('English'.trs(), textScaleFactor: 2),
                      ],
                    ),
                    onTap: () {
                      var locale = Locale('en', 'US');
                      Get.updateLocale(locale);
                      final prefs = StoragePrefs();
                      prefs.language = 'English';
                      CacheService cacheservice = Get.find<CacheService>();
                      cacheservice.saveLanguage('2');
                    }),
                Divider(
                  color: Colors.grey,
                ),
                InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/icons/flags/cn.png',
                          height: 30,
                        ),
                        Text('Chinese'.trs(), textScaleFactor: 2),
                      ],
                    ),
                    onTap: () {
                      var locale = Locale('zh', 'CH');
                      Get.updateLocale(locale);
                      final prefs = StoragePrefs();
                      prefs.language = 'Chinese';
                      CacheService cacheservice = Get.find<CacheService>();
                      cacheservice.saveLanguage('1');
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    final ThemeData themeData = Theme.of(Get.context!);
    final ColorScheme colorScheme = themeData.colorScheme;
    final backgroundColor = themeData.colorScheme.surfaceVariant;
    final foregroundColor = themeData.colorScheme.surface;
    final primaryTextTheme = themeData.textTheme;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: Form(
              key: controller.loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                  ),
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
                  Container(
                    height: 40,
                  ),
                  SizedBox(
                    // <-- Your width
                    height: 50, // <-- Your height
                    child: TextFormField(
                      key: controller.formLoginEmailFieldKey,
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.email_outlined),
                        hintText: 'login_email_hint'.trs(),
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: controller.userNameValidator,
                    ),
                  ),
                  Container(
                    height: 10,
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
                          padding: EdgeInsets.only(left: 0, right: 0, top: 0),
                          child: SizedBox(
                            // <-- Your width
                            height: 50, // <-- Your height
                            child: TextFormField(
                              key: controller.formLoginVerifyCodeFieldKey,
                              controller: controller.verifycodeController,
                              focusNode: controller.loginVerifyCodeFocusNode,
                              decoration: InputDecoration(
                                icon: Icon(Icons.sms),
                                suffixIconConstraints:
                                    BoxConstraints(minWidth: 0, minHeight: 0),
                                suffixIcon: Container(
                                  width: 140,
                                  child: Obx(() => FlatButtonX(
                                        disabledColorx: Colors.grey
                                            .withOpacity(0.1), //按钮禁用时的颜色
                                        disabledTextColorx:
                                            Colors.white, //按钮禁用时的文本颜色
                                        textColorx:
                                            controller.isButtonEnable.value
                                                ? Colors.white
                                                : Colors.black
                                                    .withOpacity(0.2), //文本颜色
                                        colorx: controller.isButtonEnable.value
                                            ? colorScheme.primary
                                            : Colors.grey
                                                .withOpacity(0.1), //按钮的颜色
                                        shapex: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(50),
                                            ),
                                            side: BorderSide(
                                                color: Colors.grey,
                                                width: 0.5)),
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
                              validator: controller.verifyCodeValidator,
                              // obscureText: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 5,
                  ),
                  Container(
                    height: 35,
                  ),
                  SizedBox(
                    width: 250, // <-- Your width
                    height: 50, // <-- Your height
                    child: ElevatedButton(
                        onPressed: () async {
                          if (controller.loginFormKey.currentState!
                              .validate()) {
                            LoadingOverlay.show(message: 'loginmessage'.trs());
                            try {
                              await controller.login();
                              Get.back(closeOverlays: true);
                              Get.offNamed(AppRoutes.MainPage);
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

                            controller.loginFormKey.currentState!.save();
                          }
                        },
                        child: Text(
                          'login'.trs(),
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                  Container(
                    height: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            // TODO: We need implement the forgetpassword page.
                            CacheService cacheservice =
                                Get.find<CacheService>();
                            String? getLocal = cacheservice.loadLanguage();
                            String strCSUrl = '';
                            if (getLocal == '1') {
                              strCSUrl =
                                  "https://chatlink.mstatik.com/widget/standalone.html?eid=b6de0b8c409c539be3cfa3a9908f1d6c";
                            } else {
                              strCSUrl =
                                  "https://chatlink.mstatik.com/widget/standalone.html?eid=0d2b2137e3c92d6d9205c2e0a2feb9ff&language=en";
                            }
                            Get.to(WebViewPage(
                              strUrl: strCSUrl,
                              strTitle: 'customerService'.trs(),
                              blNavigation: false,
                            ));
                          },
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'forgetpassword'.trs(),
                                  style: primaryTextTheme.labelLarge),
                              TextSpan(
                                  text: 'contactcustomer'.trs(),
                                  style: TextStyle(color: colorScheme.primary)),
                            ]),
                          )),
                      Container(
                        height: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.SignupPage);
                          },
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'noaccount'.trs(),
                                  style: primaryTextTheme.labelLarge),
                              TextSpan(
                                  text: 'createaccount'.trs(),
                                  style: TextStyle(color: colorScheme.primary)),
                            ]),
                          )),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }

  @override

  ///是否展示回退按钮
  bool showBackButton() => false;

  @override

  ///是否展示标题
  bool showTitleBar() => false;
}
