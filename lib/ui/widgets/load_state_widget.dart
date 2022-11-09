import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'res/colors.dart';
import 'res/style.dart';

import 'controller/base_controller.dart';

///空布局
Widget createEmptyWidget(BaseController controller) {
  return Material(
    child: Center(
        widthFactor: double.infinity,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: GestureDetector(
          onTap: () {
            controller.showLoading();
            controller.loadNet();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/common_empty_img.png",
                height: 320.w,
                width: 320.w,
              ),
              Box.hBox30,
              Text(
                "NoData".tr,
                style:
                TextStyle(fontSize: 32.sp, color: ColorStyle.color_999999),
              ),
              Box.hBox20,
              Text(
                "ClickRetry".tr,
                style:
                TextStyle(fontSize: 25.sp, color: ColorStyle.color_999999),
              )
            ],
          ),
        ))
        ),
  );
}

///创建AppBar
AppBar createAppBar(
    String titleString, bool showBackButton, List<Widget>? actionWidget,bool blBackgroundColor,
    {Widget? titleWidget}) {
  final ThemeData theme = Theme.of(Get.context!);
  final ColorScheme colorScheme = theme.colorScheme;
  return AppBar(
    title: titleWidget ?? titleView(titleString,blBackgroundColor),
    centerTitle: true,
    iconTheme: const IconThemeData(color: ColorStyle.color_white),
    elevation: 0,
    systemOverlayStyle: systemOverLayoutStyle(),
    leading: showBackButton ? leadingButton(blBackgroundColor) : null,
    actions: actionWidget,
    backgroundColor: blBackgroundColor?colorScheme.primary:null,
  );
}

Widget titleView(String titleString,bool blBackgroundColor) {
  final ThemeData theme = Theme.of(Get.context!);
  final ColorScheme colorScheme = theme.colorScheme;
  final textScheme = theme.textTheme;
  return Text(
    titleString,
    style: blBackgroundColor?textScheme.titleLarge?.copyWith(color:Colors.white ):textScheme.titleLarge,
  );
}

///回退按钮
Widget leadingButton(bool blBackgroundColor) {
  final ThemeData theme = Theme.of(Get.context!);
  final ColorScheme colorScheme = theme.colorScheme;
  return IconButton(
    color: blBackgroundColor?Colors.white:colorScheme.primary,
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
  );
}

Future<void> pop() async {
  await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
}

///状态栏颜色设置
SystemUiOverlayStyle systemOverLayoutStyle() {
  return const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light);
}

///异常布局
Widget createErroWidget(BaseController controller, String? error) {
  return Material(
      child: Center(
          widthFactor: double.infinity,
          child: GestureDetector(
            onTap: () {
              controller.showLoading();
              controller.loadNet();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/common_empty_img.png",
                  height: 320.w,
                  width: 320.w,
                ),
                Box.wBox30,
                Text(
                  error ?? "页面加载异常",
                  style: TextStyle(
                      fontSize: 32.sp, color: ColorStyle.color_999999),
                ),
                Box.hBox20,
                Text(
                  "点我重试",
                  style: TextStyle(
                      fontSize: 25.sp, color: ColorStyle.color_999999),
                )
              ],
            ),
          )));
}

Widget createCustomHoldreWidget(String? error, BaseController controller) {
  return Material(
      child: Center(
          widthFactor: double.infinity,
          child: GestureDetector(
            onTap: () {
              controller.showLoading();
              controller.loadNet();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/common_empty_img.png",
                  height: 320.w,
                  width: 320.w,
                ),
                Box.wBox30,
                Text(
                  error ?? "页面加载异常",
                  style: TextStyle(
                      fontSize: 32.sp, color: ColorStyle.color_999999),
                ),
                Box.hBox20,
                Text(
                  "点我重试",
                  style: TextStyle(
                      fontSize: 25.sp, color: ColorStyle.color_999999),
                )
              ],
            ),
          )));
}
