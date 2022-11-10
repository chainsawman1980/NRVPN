import 'dart:developer';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:nizvpn/ui/model/Login_entity.dart';
import 'package:nizvpn/ui/widgets/mixins/helper_mixin.dart';


class CacheService extends GetxService with HelperMixin {
  String? token;
  String? cacheuserId;
  RxString userNameString = "".obs;
  RxString userBonusString = "".obs;
  RxString userTrc20AddressString = "".obs;
  RxString exchangeTrc20AddressString = "".obs;
  RxString rxLanguage = "".obs;
  @override
  onInit() async {
    token = loadToken();

    userNameString.value = loadUserName().toString();
    userTrc20AddressString.value = loadUserTrc20Address().toString();
    exchangeTrc20AddressString.value = loadUserTrc20Address().toString();
    super.onInit();
  }

  void logOut() {
    token = null;
    removeToken();
    removeUsdtBonus();
    removeTrxBonus();
    removeUsername();
    removeUserid();
    removeUserTrc20Address();
  }

  void login(String token) async {
    this.token = token;
    //Token is cached
    await saveToken(token);
    // await saveBonus(bonus);
    // await saveUserName(userName);
  }

  Future<bool> saveToken(String token) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.TOKEN.toString(), token);
    return true;
  }

  Future<bool> saveUsdtBonus(num bonus) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.USDTBONUS.toString(), bonus);
    userBonusString.value = "USDT:"+loadUsdtBonus()!.toStringAsFixed(2);
    return true;
  }

  Future<bool> saveTrxBonus(num bonus) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.TRXBONUS.toString(), bonus);
    userBonusString.value = "USDT:"+loadUsdtBonus()!.toStringAsFixed(2) + "/TRX:"+loadTrxBonus()!.toStringAsFixed(2);
    return true;
  }

  Future<bool> saveUserName(String userName) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.USERNAME.toString(), userName);
    userNameString.value = userName;
    return true;
  }

  Future<bool> saveUserId(String userId) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.USERID.toString(), userId);
    cacheuserId = userId;
    return true;
  }

  Future<bool> saveUserTrc20Address(String userTrc20Address) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.UserTRC20Address.toString(), userTrc20Address);
    userTrc20AddressString.value = userTrc20Address;
    return true;
  }

  Future<bool> saveExchangeTrc20Address(String exchangeTrc20Address) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.ExchangeTRC20Address.toString(), exchangeTrc20Address);
    exchangeTrc20AddressString.value = exchangeTrc20Address;
    return true;
  }

  Future<bool> saveLanguage(String strlanguage) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.ENVLANGUAGE.toString(), strlanguage);
    rxLanguage.value = strlanguage;
    return true;
  }

  String? loadToken() {
    final box = GetStorage();
    var jsonToken = box.read(CacheManagerKey.TOKEN.toString());
    // log('-----------------${jsonToken['expires_in']}----------');
    return jsonToken;
  }

  String? loadUserName() {
    final box = GetStorage();
    var jsonToken = box.read(CacheManagerKey.USERNAME.toString());
    // log('-----------------${jsonToken['expires_in']}----------');
    return jsonToken;
  }

  String? loadUserId() {
    final box = GetStorage();
    var jsonUserId = box.read(CacheManagerKey.USERID.toString());
    // log('-----------------${jsonToken['expires_in']}----------');
    return jsonUserId;
  }

  num? loadUsdtBonus() {
    final box = GetStorage();
    var jsonToken = box.read(CacheManagerKey.USDTBONUS.toString());
    // log('-----------------${jsonToken['expires_in']}----------');
    return jsonToken;
  }

  num? loadTrxBonus() {
    final box = GetStorage();
    var jsonToken = box.read(CacheManagerKey.TRXBONUS.toString());
    // log('-----------------${jsonToken['expires_in']}----------');
    return jsonToken;
  }

  String? loadUserTrc20Address() {
    final box = GetStorage();
    var jsonToken = box.read(CacheManagerKey.UserTRC20Address.toString());
    // log('-----------------${jsonToken['expires_in']}----------');
    return jsonToken;
  }

  String? loadExchangeTrc20Address() {
    final box = GetStorage();
    var jsonToken = box.read(CacheManagerKey.ExchangeTRC20Address.toString());
    // log('-----------------${jsonToken['expires_in']}----------');
    return jsonToken;
  }

  String? loadLanguage() {
    final box = GetStorage();
    var jsonToken = box.read(CacheManagerKey.ENVLANGUAGE.toString());
    // log('-----------------${jsonToken['expires_in']}----------');
    return jsonToken;
  }

  Future<void> removeToken() async {
    final box = GetStorage();
    await box.remove(CacheManagerKey.TOKEN.toString());
  }

  Future<void> removeUsdtBonus() async {
    final box = GetStorage();
    await box.remove(CacheManagerKey.USDTBONUS.toString());
  }

  Future<void> removeTrxBonus() async {
    final box = GetStorage();
    await box.remove(CacheManagerKey.TRXBONUS.toString());
  }

  Future<void> removeUsername() async {
    final box = GetStorage();
    await box.remove(CacheManagerKey.USERNAME.toString());
  }

  Future<void> removeUserid() async {
    final box = GetStorage();
    await box.remove(CacheManagerKey.USERID.toString());
  }

  Future<void> removeUserTrc20Address() async {
    final box = GetStorage();
    await box.remove(CacheManagerKey.UserTRC20Address.toString());
  }

  Future<void> removeExchangeTrc20Address() async {
    final box = GetStorage();
    await box.remove(CacheManagerKey.ExchangeTRC20Address.toString());
  }

  Future<bool> saveUserInfo(LoginEntity userInfo) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.USERINFO.toString(), userInfo);
    return true;
  }

  bool isLogin() {
    if (token == null) return false;
    return true;
  }

  bool sessionIsExpired() {
    if (token == null) return true;

    // int currentTimestamp = HelperMixin.getTimestamp();
    // bool isExceeded = (token!.timestamp +
    //         token!.expiresIn -
    //         ConfigAPI.sessionTimeoutThreshold -
    //         currentTimestamp) <=
    //     0;
    //
    // // log('${DateTime.now().microsecondsSinceEpoch / 1000}');
    // printInfo(
    //     info:
    //         'Expired in: ${token != null ? (token!.timestamp + token!.expiresIn - currentTimestamp) / 60 : 0} mins -- isExceeded: ${isExceeded.toString()}');
    return false;
  }
}

enum CacheManagerKey { TOKEN,USERINFO,USERNAME,USERID,USDTBONUS,TRXBONUS,ExchangeTRC20Address,UserTRC20Address,ENVLANGUAGE}
