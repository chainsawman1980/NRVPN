import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter_flurry_sdk/flurry.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nizvpn/easy_local/src/public_ext.dart';
//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:nizvpn/core/provider/purchaseProvider.dart';
import 'package:nizvpn/ui/routes/app_pages.dart';
import 'package:nizvpn/ui/routes/app_routes.dart';
import 'package:nizvpn/ui/screens/auth/auth_api_service.dart';
import 'package:nizvpn/ui/screens/auth/auth_controller.dart';
import 'package:nizvpn/ui/screens/auth/cache_service.dart';
import 'package:nizvpn/ui/screens/http/gcpay_api.dart';
import 'package:nizvpn/ui/screens/login/login_controller.dart';
import 'package:nizvpn/ui/screens/login/login_screen.dart';
import 'package:nizvpn/ui/widgets/app_binding.dart';
import 'package:nizvpn/ui/widgets/res/theme_page.dart';
import 'package:nizvpn/ui/widgets/utils/injection.dart';
import 'package:nizvpn/ui/widgets/utils/storage_prefs.dart';
import 'package:provider/provider.dart';

import 'core/provider/uiProvider.dart';
import 'core/provider/vpnProvider.dart';
import 'core/resources/environment.dart';
import 'core/resources/warna.dart';
import 'core/utils/preferences.dart';
import 'easy_local/src/easy_localization_app.dart';
import 'ui/screens/introScreen.dart';
import 'ui/screens/mainScreen.dart';
import 'ui/screens/privacyPolicyScreen.dart';
//import 'package:firebase_core/firebase_core.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Injection().init();

  final prefs = StoragePrefs();
  await prefs.initPrefs();

  await GetStorage.init();


      Get.put(LoginController(Get.put(AuthApiService()), Get.put(CacheService()), Get.put(GCPayApi())),
  permanent: true);
  Get.put(MainController());
  Get.put(AuthController(Get.put(AuthApiService()), Get.put(CacheService()), Get.put(GCPayApi())),
      permanent: true);

  Flurry.builder
      .withCrashReporting(true)
      .withLogEnabled(true)
      .withLogLevel(LogLevel.debug)
      .withReportLocation(true)
      .build(
      androidAPIKey:"GN8ZPYD67WKMTHQHDYWW",
      iosAPIKey:"2KHZMWYPJQN99F595DP2");

  log('Initialize');
}

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    //await Firebase.initializeApp();
    await initializeApp();
    Provider.debugCheckInvalidValueType = null;
    await EasyLocalization.ensureInitialized();
    if (kDebugMode) {
      //await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    }
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => VpnProvider()),
          ChangeNotifierProvider(create: (context) => MainScreenProvider()),
          ChangeNotifierProvider(create: (context) => UIProvider()),
          ChangeNotifierProvider(create: (context) => PurchaseProvider()),
        ],
        child: Consumer<UIProvider>(
          builder: (context, value, child) => EasyLocalization(
            path: 'assets/languages',
            startLocale: value.selectedLocale ?? Locale("zh", "CN"),
            supportedLocales: value.locales!,
            useOnlyLangCode: true,
            child: Root(),
          ),
        ),
      ),
    );
  }, (error, stack) => {});
}

class Root extends StatefulWidget {
  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> {
  bool ready = false;
  @override
  void initState() {
    AppTrackingTransparency.requestTrackingAuthorization();
    if (Platform.isAndroid)
      try {
        InAppUpdate.checkForUpdate().then((value) {
          if (value.flexibleUpdateAllowed) return InAppUpdate.startFlexibleUpdate().then((value) => InAppUpdate.completeFlexibleUpdate());
          if (value.immediateUpdateAllowed) return InAppUpdate.performImmediateUpdate();
        }).onError((error, stackTrace) => null);
      } catch (e) {}
    UIProvider.initializeLanguages(context);
    VpnProvider.instance(context).initialize();
    VpnProvider.refreshInfoVPN(context);
    PurchaseProvider.initPurchase(context);

    if (!ready)
      setState(() {
        ready = true;
      });

    Future.delayed(Duration(seconds: 8)).then((value) {
      if (!ready)
        setState(() {
          ready = true;
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CacheService caches = Get.find<CacheService>();
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
      },
      child:ScreenUtilInit(
          designSize: const Size(750, 1334),
          builder: (BuildContext context, child) =>
              GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'HastBet',
                navigatorObservers: [FlutterSmartDialog.observer],
                builder: FlutterSmartDialog.init(),
                theme: ThemeData(
                  primaryColor: primaryColor,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  scaffoldBackgroundColor: Colors.white,
                  textButtonTheme: TextButtonThemeData(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      textStyle: MaterialStateProperty.all(TextStyle(color: Colors.black)),
                    ),
                  ),
                  buttonTheme: ButtonThemeData(
                    focusColor: Colors.grey.shade300,
                  ),
                  appBarTheme: AppBarTheme(
                    color: Colors.white,
                    iconTheme: IconThemeData(color: Colors.black),
                    titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                fallbackLocale: Locale('zh', 'CH'),
                // initialRoute: AppRoutes.MainPage,
                // initialBinding: AppBinding(),
                // getPages: AppPages.pages,
                //initialRoute: AppRoutes.MainPage,
                initialBinding: AppBinding(),
                getPages: AppPages.pages,
                home: ready
                    ? FutureBuilder<Preferences>(
                  future: Preferences.init(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (!snapshot.data!.firstOpen)
                      {
                        return Consumer<UIProvider>(
                          builder: (context, value, child) => EasyLocalization(
                            path: 'assets/languages',
                            startLocale: value.selectedLocale ?? Locale("zh", "CN"),
                            supportedLocales: value.locales!,
                            useOnlyLangCode: true,
                            child: IntroScreen(rootState: this),
                          ),
                        );
                      }
                      if (snapshot.data!.privacyPolicy) {
                        if(caches.isLogin())
                          {
                            return MainScreen();
                          }
                        else
                          {
                            return LoginScreen();
                          }

                      } else {
                        return PrivacyPolicyIntroScreen(rootState: this);
                      }
                    } else {
                      return SplashScreen();
                    }
                  },
                )
                    : SplashScreen(),
              )),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(text: "$appname ", style: GoogleFonts.poppins(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600)),
            TextSpan(text: "VPN", style: GoogleFonts.poppins(color: primaryColor, fontSize: 24, fontWeight: FontWeight.w600)),
          ]),
        ),
      ),
    );
  }
}
