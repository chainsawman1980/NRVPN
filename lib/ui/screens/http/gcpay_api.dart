import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import 'package:retrofit/http.dart';


import '../../model/Login_entity.dart';
import '../../model/UserRegistration_RespData_entity.dart';
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
  @GET("/api/getBanner")
  Future<BaseResult<String>> getBanner();


  @GET("/api/user/captcha")
  Future<String> captcha(@Body() Map<String, dynamic> map);


  // 玩家jwt登录
  @POST("/api/user/login")
  Future<BaseResult<LoginEntity>> login(@Body() Map<String, dynamic> map);


  //  玩家注册
  @POST("/api/user/register")
  Future<BaseResult<UserRegistrationRespDataEntity>> register(@Body() Map<String, dynamic> map);



}
