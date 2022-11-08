import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:url_launcher/url_launcher.dart';


import 'package:flutter/material.dart';

class WebViewPage extends StatefulWidget {
  String? strUrl;
  String? strTitle;
  bool blNavigation;
  WebViewPage({
    Key? key,
    required this.strTitle,
    required this.strUrl,
    required this.blNavigation,
  }) : super(key: key);

  @override
  WebViewPageState createState() => new WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final colorScheme = themeData.colorScheme;
    final textScheme = themeData.textTheme;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.primary,
          leading: IconButton(
            color: Colors.white,
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () async {
              // onBackPressed();
              var canPop = navigator?.canPop();
              if (canPop != null && canPop) {
                Get.back();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: Text(widget.strTitle!,style: TextStyle(color: Colors.white),),
          actions: widget.blNavigation?[
            SizedBox(
              width: 50,
              height: 50.0,
              child: ElevatedButton(
                child: Icon(Icons.arrow_back),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                ),
                onPressed: () {
                  webViewController?.goBack();
                },
              ),
            ),
            Container(width: 10,),
            SizedBox(
              width: 50,
              height: 50.0,
              child: ElevatedButton(
                child: Icon(
                  Icons.arrow_forward,
                ),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(10, 10),
                  shape: const CircleBorder(),
                ),
                onPressed: () {
                  webViewController?.goForward();
                },
              ),
            ),
            Container(width: 10,),
            SizedBox(
              width: 50,
              height: 50.0,
              child: ElevatedButton(
                child: Icon(
                  Icons.refresh,
                ),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(15, 15),
                  shape: const CircleBorder(),
                ),
                onPressed: () {
                  webViewController?.reload();
                },
              ),
            ),
            Container(width: 5,),
          ]:[Container()],
        ),
        body: SafeArea(
            child: Column(children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  initialUrlRequest: URLRequest(
                      url: Uri.parse(widget.strUrl!)),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url!;

                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunch(url)) {
                        // Launch the App
                        await launch(
                          url,
                        );
                        // and cancel the request
                        return NavigationActionPolicy.CANCEL;
                      }
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController.endRefreshing();
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onLoadError: (controller, url, code, message) {
                    pullToRefreshController.endRefreshing();
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                    }
                    setState(() {
                      this.progress = progress / 100;
                      urlController.text = this.url;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print(consoleMessage);
                  },
                ),
                progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container(),
              ],
            ),
          ),
        ])));
  }
}

class WebPageController extends GetxController {
  @override
  void loadNet() {}

  @override
  void onReady() {
    super.onReady();
  }
}

class WebPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WebPageController());
  }
}
