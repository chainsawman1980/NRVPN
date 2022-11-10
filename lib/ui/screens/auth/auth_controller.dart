import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:nizvpn/ui/model/Login_entity.dart';
import 'package:nizvpn/ui/model/token_model.dart';
import 'package:nizvpn/ui/widgets/controller/base_controller.dart';
import 'package:nizvpn/ui/screens/http/gcpay_api.dart';
import 'auth_api_service.dart';
import 'package:nizvpn/ui/screens/auth/cache_service.dart';

//This controller doesn't have view page but used
// for some widget button like signout and other
class AuthController extends BaseController {
  final AuthApiService _authenticationService;
  final CacheService _cacheServices;
  final GCPayApi api;
  AuthController(this._authenticationService, this._cacheServices,this.api);
  Rx<LoginEntity> loginEntity = Rx<LoginEntity>(LoginEntity(gcBalance: 0, nickname: ""));
  RxString rxUserName = RxString('');

  Future<TokenModel?> signIn(Map<String, dynamic> data) async {
    TokenModel? tokenData;
    try {
      log('Enter Signin');
      var response = await api.login(data);
      //var response = await _authenticationService.signIn(email,trc20, password);
      log('is logged in : ${response.code}：${response.toString()}');

      if (response.code == 200) {
        log('${response.data}');
        // final decoded = jsonDecode(responsense.data.toString()) as List<dynamic>;
        // Map<String, dynamic> tokenJson = decoded[0];
        // if (tokenJson['type'] == 1) {
        // tokenData = TokenModel(
        //   accessToken: response.data.toString(),
        // );
        LoginEntity? loginentity = response.data;
        loginEntity = Rx<LoginEntity>(loginentity!);
        rxUserName.value = loginentity.nickname!;
        _cacheServices.login(loginentity.token.toString());
        _cacheServices.saveUserInfo(loginentity);
        _cacheServices.saveUserName(loginentity.nickname.toString());
        _cacheServices.saveUserId(loginentity.userId.toString());
        _cacheServices.saveUsdtBonus(loginentity.gcBalance!);
        _cacheServices.saveUserTrc20Address(loginentity.walletAddress!);
      } else {
        var message = response.msg;
        log('message---{message}');
        throw Exception(message ?? 'An error occurred, please try again.'.tr);
      }
    } catch (e) {
      // printLog(e);
      printError(info: e.toString());
      rethrow;
    }
    return tokenData;
  }

  Future<TokenModel?> signUp(Map<String, dynamic> data) async {
    TokenModel? tokenData;
    String errorM =
        'An error occurred while registering, please contact the administrator.';
    try {
      var response = await api.register(data);
      errorM = response.msg!;

      log('is signup : ${response.toString()}');
      if (response.code == 200) {
        log('enter signup');
        Get.back();
      } else {
        // var message = response.body['error_description'];

        throw Exception(errorM);
      }
    } catch (e) {
      // printLog(e);
      printError(info: e.toString());
      throw Exception(errorM);
    }
    return tokenData;
  }


  String? token() => _cacheServices.token;

  void signOut() async {
    _cacheServices.logOut();
  }

  bool isAuthenticated() {
    return !_cacheServices.sessionIsExpired();
  }

  @override
  void loadNet() {}

  @override
  void onInit() {
    if(_cacheServices.loadUserName() != null)
      {
        rxUserName.value = _cacheServices.loadUserName()!;
      }

  }
}
