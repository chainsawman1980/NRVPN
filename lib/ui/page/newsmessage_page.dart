import 'dart:io';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:nizvpn/easy_local/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';


import 'package:flutter/material.dart';

import '../../core/models/bannermessage.dart';
import '../../core/provider/vpnProvider.dart';
import '../widgets/base_stateful_widget.dart';
import '../widgets/controller/base_controller.dart';

class NewsMessagePage extends BaseStatefulWidget<NewsMessageController> {
  String? strTitle;
  bool blNavigation;
  NewsMessagePage({
    Key? key,
    required this.strTitle,
    required this.blNavigation,
  }) : super(key: key);

  @override
  Widget buildContent(BuildContext context) {
    final themeData = Theme.of(context);
    final colorScheme = themeData.colorScheme;
    final textScheme = themeData.textTheme;
    return EasyRefresh(
      controller: controller.refreshController,
      header: ClassicHeader(
        dragText: 'Pull to refresh'.tr,
        armedText: 'Release ready'.tr,
        readyText: 'Refreshing...'.tr,
        processingText: 'Refreshing...'.tr,
        processedText: 'Succeeded'.tr,
        noMoreText: 'No more'.tr,
        failedText: 'Failed'.tr,
        messageText: 'Last updated at %T'.tr,
        safeArea: false,
      ),
      footer: ClassicFooter(
        position: IndicatorPosition.locator,
        dragText: 'Pull to load'.tr,
        armedText: 'Release ready'.tr,
        readyText: 'Loading...'.tr,
        processingText: 'Loading...'.tr,
        processedText: 'Succeeded'.tr,
        noMoreText: 'No more'.tr,
        failedText: 'Failed'.tr,
        messageText: 'Last updated at %T'.tr,
      ),
      refreshOnStart: false,
      refreshOnStartHeader: BuilderHeader(
        triggerOffset: 70,
        clamping: true,
        position: IndicatorPosition.above,
        processedDuration: Duration.zero,
        builder: (ctx, state) {
          if (state.mode == IndicatorMode.inactive ||
              state.mode == IndicatorMode.done) {
            return const SizedBox();
          }
          return Container(
            padding: const EdgeInsets.only(bottom: 100),
            width: double.infinity,
            height: state.viewportDimension,
            alignment: Alignment.center,
          );
        },
      ),
      onRefresh: () async {
        controller.getBanner();
        await Future.delayed(const Duration(seconds: 2));
        controller.refreshController.finishRefresh();
        controller..refreshController.resetFooter();
      },
      onLoad: () async {
        await Future.delayed(const Duration(seconds: 2));
        controller.refreshController.finishLoad(
          //_count >= 3 ? IndicatorResult.noMore : IndicatorResult.success);
            IndicatorResult.noMore);
      },
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            child: Container(
              alignment: Alignment.center,
              height: 80,
              child: Text('${index + 1}'),
            ),
          );
        },
        itemCount: controller.rxBanner.value.length,
      ),
    );
  }

  @override
  bool showTitleBar() => true;

  @override
  String titleString() => "messages".trs();

}

class NewsMessageController extends BaseController {
  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();
  RxList<BannerMessages> rxBanner = RxList<BannerMessages>();
  late EasyRefreshController refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void loadNet() {}

  @override
  void onReady() {
    super.onReady();
    getBanner();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {

      },
    );
  }

  Future<void> getBanner()
  async {
    rxBanner.value = await VpnProvider.getBanner(Get.context!);
    if (rxBanner.value.length > 0) {
      //return json.decode(response.body);
      change(rxBanner.value, status: RxStatus.success());
    } else {
      change(null, status: RxStatus.empty());
    }
  }
}

class NewsMessagePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewsMessageController());
  }
}
