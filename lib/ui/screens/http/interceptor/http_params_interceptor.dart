import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import 'package:nizvpn/ui/screens/auth/cache_service.dart';


///请求参数拦截器
class HttpParamsInterceptor extends Interceptor {
  static const VERSION = "version";
  static const TOKEN = "token";
  static const DEVICE_NO = "deviceNo";
  static const APP_TYPE_KEY = "appType";
  static const APP_TYPE_VALUE = "Android";
  static const APP_ID_KEY = "appId";
  static const JSON_BODY = "jsonBody";
  static const SIGN = "sign";
  static const TIMESTAMP = "timestamp";
  static const UTF_8 = "UTF-8";
  static const APP_ID = "test_android";

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var headers = options.headers;
    //headers["Authorization"] = 'Bearer $loadToken';
    super.onRequest(options, handler);
  }


  String? loadToken() {
    final box = GetStorage();
    var jsonToken = box.read(CacheManagerKey.TOKEN.toString());
    // log('-----------------${jsonToken['expires_in']}----------');
    return jsonToken;
  }
}
