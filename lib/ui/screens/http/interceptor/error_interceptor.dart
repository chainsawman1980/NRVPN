import 'package:dio/dio.dart';

import '../../../widgets/http/app_except.dart';
import '../../../widgets/utils/log_utils.dart';



///错误处理拦截器
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // error统一处理
    AppException appException = AppException.create(err);
    // 错误提示
    LogE('DioError===: ${appException.toString()}');
    err.error = appException;
    super.onError(err, handler);
  }
}
