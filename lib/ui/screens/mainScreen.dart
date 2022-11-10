import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:nizvpn/core/provider/vpnProvider.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import '../../core/provider/uiProvider.dart';
import '../../core/resources/nerdVpnIcons.dart';
import '../../core/resources/warna.dart';
import '../components/customCard.dart';
import '../components/customImage.dart';
import '../page/homePage.dart';
import '../page/settingsPage.dart';
import '../page/sharePage.dart';
import '../widgets/base_stateful_widget.dart';
import '../widgets/controller/base_controller.dart';
import '../widgets/utils/log_utils.dart';
import 'selectVpnScreen.dart';

class MainScreen extends BaseStatefulWidget<MainController> {
  MainScreen({Key? key}) : super(key: key);

  @override
  Widget buildContent(BuildContext context) {
    // TODO: implement buildContent
    return WillPopScope(
      onWillPop: () async {
        if (UIProvider.instance(context).sheetController.currentPosition > 300) {
          UIProvider.instance(context).sheetController.snapToPosition(SnappingPosition.factor(positionFactor: .13, grabbingContentOffset: GrabbingContentOffset.bottom));
          return false;
        }
        MainScreenProvider provider = MainScreenProvider.instance(context);
        if (provider.pageIndex > 0) {
          provider.pageIndex--;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: SnappingSheet(
          controller: UIProvider.instance(context).sheetController,
          onSheetMoved: (position) {
            double _val = (100 / 600) * (position.pixels / 600);
            if (_val > 1) return;
            if (_val < 0.5) _val = 0;
            if (_val > 1) _val = 1;
            controller.selectServerOpacity = _val;
          },
          initialSnappingPosition: SnappingPosition.factor(
            positionFactor: 0.16,
            snappingCurve: Curves.easeOutExpo,
            snappingDuration: Duration(seconds: 1),
            grabbingContentOffset: GrabbingContentOffset.bottom,
          ),
          snappingPositions: [
            SnappingPosition.factor(
              positionFactor: 0.16,
              snappingCurve: Curves.easeOutExpo,
              snappingDuration: Duration(seconds: 1),
              grabbingContentOffset: GrabbingContentOffset.bottom,
            ),
            SnappingPosition.factor(
              positionFactor: .8,
              snappingCurve: Curves.bounceOut,
              snappingDuration: Duration(seconds: 1),
              grabbingContentOffset: GrabbingContentOffset.bottom,
            ),
          ],
          grabbingHeight: 100,
          sheetBelow: SnappingSheetContent(
            child: Container(
              child: SelectVpnScreen(scrollController: controller._scrollController),
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(.1), offset: Offset(0, -1), blurRadius: 10)],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
            ),
          ),
          grabbing: _customBottomNavBar(),
          child: Stack(
            children: [
              Positioned(
                bottom: 30,
                child: BottomImageCityWidget(),
              ),
              Column(
                children: [
                  Expanded(
                    child: Consumer<MainScreenProvider>(
                      builder: (context, value, child) => [
                        HomePage(),
                        SharePage(),
                        PengaturanPage(),
                      ][value.pageIndex],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customBottomNavBar() {
    return CustomCard(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      radius: 20,
      backgroundColor: Colors.white.withOpacity(1),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5),
                    width: 50,
                    height: 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
                Consumer<MainScreenProvider>(
                  builder: (context, value, child) => SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.only(),
                              primary: primaryColor,
                              shape: CircleBorder(),
                            ),
                            child: Icon(
                              NerdVPNIcon.home,
                              color: value.pageIndex == 0 ? Theme.of(context).primaryColor : grey,
                            ),
                            onPressed: () {
                              value.pageIndex = 0;
                            },
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.only(),
                              primary: primaryColor,
                              shape: CircleBorder(),
                            ),
                            child: Icon(
                              NerdVPNIcon.gift,
                              color: value.pageIndex == 1 ? Theme.of(context).primaryColor : grey,
                            ),
                            onPressed: () {
                              value.pageIndex = 1;
                            },
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.only(),
                              primary: primaryColor,
                              shape: CircleBorder(),
                            ),
                            child: Icon(
                              NerdVPNIcon.settings,
                              color: value.pageIndex == 2 ? Theme.of(context).primaryColor : grey,
                            ),
                            onPressed: () {
                              value.pageIndex = 2;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///是否展示回退按钮
  bool showBackButton() => false;
}

class MainController extends BaseController {
  DateTime? lastPopTime;
  final RxInt _curPage = 0.obs;
  final PageController pageController = PageController(initialPage: 0);
  RxInt selected = 0.obs;
  final List<Widget> naviItems = [
  ];

  double selectServerOpacity = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void loadNet() {}

  @override
  void onReady() {
    super.onReady();
    showSuccess();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

}


class MainScreenProvider extends ChangeNotifier {
  int _curIndex = 0;

  int get pageIndex => _curIndex;
  set pageIndex(int value) {
    _curIndex = value;
    notifyListeners();
  }

  static MainScreenProvider instance(BuildContext context) => Provider.of(context, listen: false);
}

class MainBinding extends Bindings {
  @override
  void dependencies() {
    LogD(">>>>>>>>>>>>开始注入代码");
    Get.lazyPut(() => MainController());
  }
}
