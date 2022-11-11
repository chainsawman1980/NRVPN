import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:card_swiper/card_swiper.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nizvpn/easy_local/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:lottie/lottie.dart';
import 'package:ndialog/ndialog.dart';
import 'package:nizvpn/ui/page/webview_page.dart';
import 'package:nizvpn/ui/screens/http/base_result.dart';
import 'package:nizvpn/ui/screens/http/gcpay_api.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/models/bannermessage.dart';
import '../../core/provider/uiProvider.dart';
import '../../core/provider/vpnProvider.dart';
import '../../core/resources/environment.dart';
import '../../core/resources/nerdVpnIcons.dart';
import '../../core/resources/warna.dart';
import '../../core/utils/NizVPN.dart';
import '../../core/utils/preferences.dart';
import '../components/customDivider.dart';
import '../components/customImage.dart';
import '../screens/subscriptionDetailScreen.dart';
import 'newsmessage_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RxList<BannerMessages> rxBanner = RxList<BannerMessages>();
  @override
  void initState()
  {
    getBanner();
  }

  Future<void> getBanner()
  async {
    GCPayApi api = Get.find<GCPayApi>();
    var bannerResult = await api.getBanner(<String, dynamic>{
      'type': 1,
    });
    rxBanner.value = bannerResult.data!;
  }
  @override
  void didChangeDependencies() {
    VpnProvider.refreshInfoVPN(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _customAppBarWidget(),
            Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.all(10),
                child: _body(),
              ),
            ),

        ],
      ),
    );
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _topBannerWidget(),
        ColumnDivider(space: 20),
        _topMessageWidget(),
        ColumnDivider(space: 20),
        SizedBox(height: 200, child: _connectButtonWidget()),
        ColumnDivider(space: 20),
        _currentLocationWidget(),
        Platform.isAndroid ? _connectionInfo() : SizedBox(),
        ColumnDivider(space: 90),
      ],
    );
  }

  Widget _connectionInfo() {
    return Container(
      height: 100,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Consumer<VpnProvider>(
        builder: (context, snapshot, child) {
          String byteIn = "0,0 kB - 0,0 kB/s";
          String byteOut = "0,0 kB - 0,0 kB/s";

          if (snapshot.vpnStatus != null) {
            byteIn = snapshot.vpnStatus!.byteIn!.trim().length == 0 ? "0,0 kB - 0,0 kB/s" : snapshot.vpnStatus!.byteIn!.trim();
            byteOut = snapshot.vpnStatus!.byteOut!.trim().length == 0 ? "0,0 kB - 0,0 kB/s" : snapshot.vpnStatus!.byteOut!.trim();
          }
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "download".trs(),
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      byteIn,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "upload".trs(),
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      byteOut,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _currentLocationWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "current_location".trs(),
            style: TextStyle(fontSize: 12),
          ),
          ColumnDivider(
            space: 5,
          ),
          Consumer<VpnProvider>(
            builder: (context, value, child) => SizedBox(
              height: 50,
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: grey)))),
                child: Row(
                  children: [
                    value.vpnConfig?.flag == null
                        ? SizedBox.shrink()
                        : SizedBox(
                            height: 30,
                            width: 30,
                            child: (value.vpnConfig!.flag!.toLowerCase().startsWith("http")
                                ? CustomImage(
                                    url: value.vpnConfig!.flag,
                                    fit: BoxFit.scaleDown,
                                  )
                                : Image.asset(
                                    "assets/icons/flags/${value.vpnConfig!.flag}.png",
                                    height: 30,
                                    width: 30,
                                  )),
                          ),
                    RowDivider(),
                    Expanded(child: Text(value.vpnConfig?.name ?? "select_vpn".trs())),
                    Consumer<VpnProvider>(
                      builder: (context, value, child) => Text(value.vpnConfig?.protocol?.toUpperCase() ?? ""),
                    ),
                  ],
                ),
                onPressed: _changeLocationClick,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _connectButtonWidget() {
    return Consumer<VpnProvider>(
      builder: (context, value, child) {
        Color buttonColor = greyLittleWhite;
        // Color focusColor = greyLittleWhite;

        String stage = (value.vpnStage ?? NVPN.vpnDisconnected).toLowerCase();
        if (stage == NVPN.vpnConnected.toLowerCase()) {
          buttonColor = primaryColor;
        } else if (stage != NVPN.vpnDisconnected.toLowerCase() || stage == "") {
          buttonColor = Colors.orange;
        } else {
          buttonColor = greyLittleWhite;
        }
        return Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(.1),
                ),
              ],
              shape: BoxShape.circle,
            ),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(buttonColor),
                shape: MaterialStateProperty.all(CircleBorder()),
              ),
              onPressed: () => _connectVPNClick(value),
              child: Icon(
                NerdVPNIcon.power,
                size: 130,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  static final en_US = [
    'assets/images/banner/oubao_banner1.jpeg',
    'assets/images/banner/oubao_banner2.jpeg',
    'assets/images/banner/oubao_banner3.jpeg',
    'assets/images/banner/oubao_banner4.jpeg',
  ];

  Widget _topBannerWidget() {
    return Obx(() =>
        rxBanner.length>0?Container(
          height: 160,
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child:
              Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Image.asset(
                      en_US[index],
                      fit: BoxFit.cover,
                    );
                  },
                  itemCount: rxBanner.length,
                  autoplay: true,
                  pagination: SwiperPagination(),
                  onTap: (int index) {
                    String? strJumpUrl = rxBanner.value[index].url;
                    String strurl = Uri.encodeFull(strJumpUrl!);
                    strurl.replaceAll("\n", '');
                    //launchUrl(Uri.https(strurl));
                    Navigator.push(context, new MaterialPageRoute(builder: (context) => WebViewPage(
                        strUrl: strurl,
                        strTitle: rxBanner.value[index].title,
                        blNavigation: true)),);

                  }
                //control: SwiperControl(),
              )
          )
      :ColumnDivider(space: 20)

    );

  }

  Widget _topMessageWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<VpnProvider>(
        builder: (context, value, child) {
          String tulisan = "unprotected".trs();
          Color color = Colors.red;

          String stage = (value.vpnStage ?? NVPN.vpnDisconnected).toLowerCase();
          if (stage == NVPN.vpnConnected.toLowerCase()) {
            tulisan = "protected".trs();
            color = Colors.green;
          } else if (stage != NVPN.vpnDisconnected.toLowerCase()) {
            tulisan = value.vpnStage!.replaceAll("_", " ");
            color = Colors.orange;
          } else {
            tulisan = "unprotected".trs();
            color = Colors.red;
          }
          return RichText(
            text: TextSpan(children: [
              TextSpan(text: "${"welcome".trs()},\n", style: GoogleFonts.poppins(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
              TextSpan(text: "${"your_connection".trs()} ", style: GoogleFonts.poppins(fontSize: 15, color: Colors.black)),
              TextSpan(text: tulisan.toUpperCase(), style: GoogleFonts.poppins(fontSize: 15, color: color)),
            ]),
          );
        },
      ),
    );
  }

  Widget _customAppBarWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(child: IconButton(onPressed: () {
            Get.lazyPut(() => NewsMessageController());
            Navigator.push(context, new MaterialPageRoute(builder: (context) => NewsMessagePage(
                strTitle: "站内信",
                blNavigation: false)),);
          }, icon: Icon(Icons.message_outlined,color: Colors.grey,)),left: 0,),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(text: "$appname ", style: GoogleFonts.poppins(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)),
              TextSpan(text: "VPN", style: GoogleFonts.poppins(color: primaryColor, fontSize: 18, fontWeight: FontWeight.w600)),
            ]),
          ),
          Consumer<VpnProvider>(
            builder: (context, value, child) {
              if (value.isPro) {
                return Positioned(
                  child: CupertinoButton(
                    padding: EdgeInsets.only(),
                    onPressed: () {},
                    child: Row(
                      children: [
                        LottieBuilder.asset(
                          "assets/animations/crown.json",
                          height: 50,
                          width: 50,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                  right: 0,
                );
              }
              return Positioned(
                child: CupertinoButton(
                  padding: EdgeInsets.only(),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionDetailScreen()));
                  },
                  child: Row(
                    children: [
                      LottieBuilder.asset(
                        "assets/animations/crown_grey.json",
                        height: 50,
                        width: 50,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                right: 0,
              );
            },
          )
        ],
      ),
    );
  }

  void _connectVPNClick(VpnProvider vpnProvider) async {
    if (vpnProvider.vpnStage != NVPN.vpnDisconnected && (vpnProvider.vpnStage?.length ?? 0) > 0) {
      if (vpnProvider.vpnStage == NVPN.vpnConnected) {
        var resp = await NAlertDialog(
          dialogStyle: DialogStyle(titleDivider: true, contentPadding: EdgeInsets.only()),
          title: Text("${"disconnect".trs()}?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text("disconnect_question".trs()),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("disconnect".trs()),
              style: ButtonStyle(shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)))),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: Text("cancel".trs()),
              style: ButtonStyle(shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)))),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        ).show(context);

        if (resp ?? false) {
          NVPN.stopVpn();
        }
      } else {
        NVPN.stopVpn();
      }
    } else {
      if (vpnProvider.vpnConfig != null) {
        if (vpnProvider.vpnConfig!.status == 1 && !vpnProvider.isPro) {
          return VpnProvider.renewSubs(context);
        }
        if (vpnProvider.vpnConfig!.config == null && vpnProvider.vpnConfig!.slug != null) {
          await CustomProgressDialog.future(
            context,
            future: vpnProvider.setConfig(context, vpnProvider.vpnConfig!.slug, vpnProvider.vpnConfig!.protocol),
            dismissable: false,
            loadingWidget: Center(
              child: Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          );
          return _connectVPNClick(vpnProvider);
        }
      } else {
        return NAlertDialog(
          title: Text("unknown_server".trs()),
          content: Text("select_a_server".trs()),
          actions: [
            TextButton(
              onPressed: () => UIProvider.instance(context).sheetController.snapToPosition(SnappingPosition.factor(positionFactor: .8, grabbingContentOffset: GrabbingContentOffset.bottom)),
              child: Text("choose_server".trs()),
              style: ButtonStyle(shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)))),
            )
          ],
        ).show(context);
      }

      Future.delayed(Duration(seconds: 5)).then((value) async {
        if ((await Preferences.init()).shared.getBool("show_dialog") ?? false) return;
        if (Random().nextBool()) {
          NAlertDialog(
            title: Text("rating_title".trs()),
            content: Text("rating_description".trs()),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text("rating_done".trs())),
              TextButton(
                child: Text("rating_goto".trs()),
                onPressed: () {
                  InAppReview.instance.openStoreListing();
                  Navigator.pop(context);
                },
              ),
            ],
          ).show(context).then((value) async {
            Preferences.init().then((value) {
              value.shared.setBool("show_dialog", true);
            });
          });
        }
      });

      // AdsProvider.instance(context).showAd1(context);
      if(vpnProvider.vpnConfig!.serverIp != null)
        {
          await NVPN.startVpn(vpnProvider.vpnConfig!);
        }

    }
  }

  void _changeLocationClick() async {
    UIProvider.instance(context).sheetController.snapToPosition(SnappingPosition.factor(positionFactor: .8, grabbingContentOffset: GrabbingContentOffset.bottom));
  }
}
