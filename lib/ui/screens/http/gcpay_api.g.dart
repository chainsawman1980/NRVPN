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


  @override
  Future<BaseResult<String>> getBanner() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResult<String>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/api/getBanner',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResult<String>.fromJson(
      _result.data!,
      (json) => json as String,
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
                .compose(_dio.options, '/api/user/captcha',
                queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data!;
    return value;
  }


  @override
  Future<BaseResult<LoginEntity>> login(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResult<LoginEntity>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/api/user/login',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResult<LoginEntity>.fromJson(
      _result.data!,
      (json) => LoginEntity.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }


  @override
  Future<BaseResult<UserRegistrationRespDataEntity>> register(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResult<UserRegistrationRespDataEntity>> (
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/api/user/register',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResult<UserRegistrationRespDataEntity>.fromJson(
      _result.data!,
          (json) => UserRegistrationRespDataEntity.fromJson(json as Map<String, dynamic>),
    );
    return value;
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
}
