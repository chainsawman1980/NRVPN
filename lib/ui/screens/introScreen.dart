import 'package:nizvpn/easy_local/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../../core/resources/environment.dart';
import '../../core/utils/preferences.dart';
import '../../main.dart';

class IntroScreen extends StatelessWidget {
  final RootState? rootState;

  const IntroScreen({Key? key, @required this.rootState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 100),
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              image: LottieBuilder.asset("assets/animations/1.json"),
              title: "welcometo".tr() + " $appname VPN",
              body: "takeyouaround".tr() + " $appname VPN",
            ),
            PageViewModel(
              image: LottieBuilder.asset("assets/animations/2.json"),
              title: "provacyprotect".tr(),
              body: "internetaccess".tr(),
            ),
            PageViewModel(
              image: LottieBuilder.asset("assets/animations/3.json"),
              title: "fastlimitless".tr(),
              body: "provideserverfastlimitless".tr(),
            ),
          ],
          showSkipButton: true,
          onDone: () {
            Preferences.init().then((value) {
              // ignore: invalid_use_of_protected_member
              rootState!.setState(() {
                value.saveFirstOpen();
              });
            });
          },
          next: Text("next".tr(), style: TextStyle(fontSize: 20, color: Colors.black)),
          skip: Text("skip".tr(), style: TextStyle(fontSize: 20, color: Colors.black)),
          showNextButton: true,
          done: Text("done".tr(), style: TextStyle(fontSize: 20, color: Colors.black)),
        ),
      ),
    );
  }
}
