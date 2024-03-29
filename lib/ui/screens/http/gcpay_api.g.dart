// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gcpay_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _GCPayApi implements GCPayApi {
  _GCPayApi(this._dio, {this.baseUrl}) {
    baseUrl ??= HttpUrl.BASE_GCPAY_URL;
  }

  final Dio _dio;

  String? baseUrl;

  String? loadToken() {
    final box = GetStorage();
    var jsonToken = box.read(CacheManagerKey.TOKEN.toString());
    // log('-----------------${jsonToken['expires_in']}----------');
    return jsonToken;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  @override
  Future<BaseResult<List<BannerMessages>>> getBanner(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = map;
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _headers["Authorization"] = loadToken()!;

    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResult<List<BannerMessages>>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/api/siteMessage/getList',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResult<List<BannerMessages>>.fromJson(
      _result.data!,
          (json) => (json as List<dynamic>)
          .map<BannerMessages>(
              (i) => BannerMessages.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
    return value;
  }





  @override
  Future<String> captcha(map) async {
    const _extra = <String, dynamic>{};
    var queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    queryParameters = map;
    final _result = await _dio.fetch<String>(
        _setStreamType<String>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/api/login/getLoginCaptcha',
                queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!;
    return value;
  }

  @override
  Future<BaseResult<String>> senRegSmsCode(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    queryParameters.addAll(map);
    String strRegType = queryParameters["regType"];
    String strEmail = queryParameters["key"];
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResult<String>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/api/login/getRegCaptcha/'+strRegType+'/'+strEmail,
                queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResult<String>.fromJson(
      _result.data!,
          (json) => json as String,
    );
    return value;
  }

  @override
  Future<BaseResult<String>> senLoginSmsCode(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    queryParameters.addAll(map);
    String strRegType = queryParameters["regType"];
    String strEmail = queryParameters["key"];
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResult<LoginEntity>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/api/login/getLoginCaptcha/'+strRegType+'/'+strEmail,
                queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResult<String>.fromJson(
      _result.data!,
          (json) => json as String,
    );
    return value;
  }


  @override
  Future<BaseResult<TokenModel>> login(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResult<TokenModel>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/api/login/loginIn',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResult<TokenModel>.fromJson(
      _result.data!,
      (json) => TokenModel.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }


  @override
  Future<BaseResult<String>> register(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResult<String>> (
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/api/login/reg',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResult<String>.fromJson(
      _result.data!,
          (json) => json as String,
    );
    return value;
  }

  @override
  Future<List<VpnServer>?> allFreeServer({int? page}) async {
    var resp;
    if (page == null) {
      resp = await allFreeServerAPI(<String, dynamic>{
        'page': 0,
      });
    } else {
      resp = await allFreeServerAPI(<String, dynamic>{
        'page': page,
      });
    }

    return resp.data;
  }

  @override
  Future<BaseResult<List<VpnServer>>> allFreeServerAPI(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = map;
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _headers["Authorization"] = loadToken()!;

    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResult<List<VpnServer>>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/api/vpn/allservers/free',
                queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResult<List<VpnServer>>.fromJson(
      _result.data!,
          (json) => (json as List<dynamic>)
          .map<VpnServer>(
              (i) => VpnServer.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
    return value;
  }

  @override
  Future<List<VpnServer>?> allProServer({int? page}) async {
    var resp;
    if (page == null) {
      resp = await allProServerAPI(<String, dynamic>{
        'page': 0,
      });
    } else {
      resp = await allProServerAPI(<String, dynamic>{
        'page': page,
      });
    }

    return resp.data;
  }

  @override
  Future<BaseResult<List<VpnServer>>> allProServerAPI(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = map;
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _headers["Authorization"] = loadToken()!;

    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResult<List<VpnServer>>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/api/vpn/allservers/pro',
                queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResult<List<VpnServer>>.fromJson(
      _result.data!,
          (json) => (json as List<dynamic>)
          .map<VpnServer>(
              (i) => VpnServer.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
    return value;
  }

  @override
  Future<VpnConfig?> randomVpn() async {
    var resp;
    resp = await randomVpnAPI();

    return resp.data;
  }

  @override
  Future<BaseResult<VpnConfig>> randomVpnAPI() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _headers["Authorization"] = loadToken()!;

    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResult<VpnConfig>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/api/vpn/randomVpn',
                queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResult<VpnConfig>.fromJson(
      _result.data!,
          (json) => VpnConfig.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<VpnConfig?> detailVpn(VpnServerModel vpnServer) async {
    var resp;
    resp = await detailVpnAPI(vpnServer.slug!);

    return resp.data;
  }

  @override
  Future<BaseResult<VpnConfig>> detailVpnAPI(String strServerId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _headers["Authorization"] = loadToken()!;

    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResult<VpnConfig>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/api/vpn/detail/'+strServerId,
                queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResult<VpnConfig>.fromJson(
      _result.data!,
          (json) => VpnConfig.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }
}
