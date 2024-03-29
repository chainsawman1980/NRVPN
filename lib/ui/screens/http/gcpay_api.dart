import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import 'package:retrofit/http.dart';


import '../../../core/models/bannermessage.dart';
import '../../../core/models/vpnConfig.dart';
import '../../../core/models/vpnServer.dart';
import '../../model/Login_entity.dart';
import '../../model/UserRegistration_RespData_entity.dart';
import '../../model/token_model.dart';
import '../../widgets/constant/http_url.dart';
import '../../widgets/http/result/base_result.dart';
import 'package:nizvpn/ui/screens/auth/cache_service.dart';
import 'dart:typed_data';

import 'dio_client.dart';

part 'gcpay_api.g.dart';

@RestApi(baseUrl: HttpUrl.BASE_GCPAY_URL)
abstract class GCPayApi {


  factory GCPayApi({Dio? dio, String? baseUrl}) {
    dio ??= DioClient().dio;
    return _GCPayApi(dio, baseUrl: baseUrl);
  }


  // 活动图片
  @GET("/api/siteMessage/getList")
  Future<BaseResult<List<BannerMessages>>> getBanner(@Body() Map<String, dynamic> map);


  @GET("/api/login/getLoginCaptcha")
  Future<String> captcha(@Body() Map<String, dynamic> map);


  // 玩家jwt登录
  @POST("/api/login/loginIn")
  Future<BaseResult<TokenModel>> login(@Body() Map<String, dynamic> map);

  //  发送手机验证码
  @POST("/api/login/getRegCaptcha")
  Future<BaseResult<String>> senRegSmsCode(@Body() Map<String, dynamic> map);

  //  发送手机验证码
  @POST("/api/login/getLoginCaptcha")
  Future<BaseResult<String>> senLoginSmsCode(@Body() Map<String, dynamic> map);

  //  玩家注册
  @POST("/api/login/reg")
  Future<BaseResult<String>> register(@Body() Map<String, dynamic> map);

  Future<List<VpnServer>?> allFreeServer({int? page});

  @GET("/api/vpn/allservers/free")
  Future<BaseResult<List<VpnServer>>> allFreeServerAPI(@Body() Map<String, dynamic> map);

  Future<List<VpnServer>?> allProServer({int? page});

  @GET("/api/vpn/allservers/pro")
  Future<BaseResult<List<VpnServer>>> allProServerAPI(@Body() Map<String, dynamic> map);

  Future<VpnConfig?> randomVpn();

  @GET("/api/vpn/randomVpn")
  Future<BaseResult<VpnConfig>> randomVpnAPI();

  Future<VpnConfig?> detailVpn(VpnServerModel vpnServer);

  @GET("/api/vpn/detail")
  Future<BaseResult<VpnConfig>> detailVpnAPI(String strServerId);
}
