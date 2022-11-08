import 'package:nizvpn/easy_local/src/public_ext.dart';
import 'package:flutter/material.dart';

import '../../core/resources/environment.dart';
import '../../core/resources/warna.dart';
import '../../core/utils/preferences.dart';
import '../../main.dart';
import '../components/customCard.dart';
import '../components/customDivider.dart';

class PrivacyPolicyIntroScreen extends StatefulWidget {
  final RootState? rootState;

  const PrivacyPolicyIntroScreen({Key? key, this.rootState}) : super(key: key);

  @override
  _PrivacyPolicyIntroScreenState createState() => _PrivacyPolicyIntroScreenState();
}

class _PrivacyPolicyIntroScreenState extends State<PrivacyPolicyIntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomCard(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("privacypolicy_title".trs(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(20),
                  children: [
                    Text("privacypolicy_subtitle".trs().replaceAll("\$appname", appname)),
                    ColumnDivider(),
                    Text("privacypolicy_h2".trs(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ColumnDivider(space: 5),
                    _privacyPointWidget("privacypolicy_title1".trs(), "privacypolicy_desc1".trs()),
                    ColumnDivider(),
                    _privacyPointWidget("privacypolicy_title2".trs(), "privacypolicy_desc2".trs()),
                    ColumnDivider(),
                    _privacyPointWidget("privacypolicy_title3".trs(), "privacypolicy_desc3".trs()),
                    ColumnDivider(),
                    Text("privacypolicy_footer".trs(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primaryColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    ),
                  ),
                  child: Text(
                    "accept_continue".trs(),
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _accAndContinueClick,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _accAndContinueClick() {
    Preferences.init().then((value) {
      widget.rootState!.setState(() {
        value.acceptPrivacyPolicy();
      });
    });
  }

  Widget _privacyPointWidget(String title, String message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 3),
          decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
          width: 15,
          height: 15,
        ),
        RowDivider(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(message),
            ],
          ),
        )
      ],
    );
  }
}
