import 'dart:developer';


import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../screens/login/login_binding.dart';
import '../screens/login/login_screen.dart';
import '../screens/mainScreen.dart';
import '../screens/signup/signup_binding.dart';
import '../screens/signup/signup_screen.dart';
import '../widgets/middlewares/auth_middleware.dart';
import 'app_routes.dart';


// part 'routes.dart';
// This file will contain your array routing
class AppPages {
  static List<GetPage> pages = [
    GetPage(
        name: AppRoutes.LoginPage,
        page: () => const LoginScreen(),
        binding: LoginBinding(),
        transition: Transition.downToUp),
    GetPage(
        name: AppRoutes.SignupPage,
        page: () => const SignupScreen(),
        binding: SignupBinding(),
        transition: Transition.rightToLeft),

    ///主入口
    GetPage(
        name: AppRoutes.MainPage,
        page: () => MainScreen(),
        binding: MainBinding(),
        transition: Transition.fadeIn,
        middlewares: [AuthMiddleware()],
    ),

    // ///首页Tab
    // GetPage(
    //   name: AppRoutes.HomePage,
    //   page: () => HomePage(),
    //   binding: HomeBinding(),
    // ),

  ];
}
