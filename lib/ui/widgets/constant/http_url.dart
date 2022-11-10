import 'package:uuid/uuid.dart';

///
///URL配置连接
///
class HttpUrl {
  ///测试环境URL
  static const String BASE_URL = "http://admin.ssdvpn.com/api/vpn/";

  static const String BAES_TZYK_URL = "https://test-tzyk.get88.cn/";

  static const String BASE_GATEWAY_URL = "https://test-gateway.get88.cn/";

  static const String BASE_GCPAY_URL = "http://154.85.63.227:8088/";

  static const String clientId = 'CLIENT_ID';
  static const String clientSecret = 'CLIENT_SECRET';
  static String DEVICE_UUID = Uuid().v1();

  static const PROXY_ENABLE = false;
  //Release Server
  //"http://hashbeto.com:8088";
  //Test Server
  //"http://182.16.17.58:8080";

}
