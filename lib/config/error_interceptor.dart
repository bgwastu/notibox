import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ErrorInterceptor extends Interceptor {
  @override
  Future onError(DioError e, ErrorInterceptorHandler handler) async {
    await Sentry.captureException(e,
        stackTrace: e.stackTrace, hint: e.requestOptions.data);
    handler.next(e);
  }
}
