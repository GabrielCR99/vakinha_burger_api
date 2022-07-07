import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import '../../config/app_config.dart';
import 'gerencianet_auth_interceptor.dart';

class GerencianetRestClient extends DioForNative {
  GerencianetRestClient() : super(_baseOptions) {
    _configureCertificates();
    interceptors.add(LogInterceptor(responseBody: true));
  }

  GerencianetRestClient auth() {
    interceptors.add(GerencianetAuthInterceptor());

    return this;
  }

  static final _baseOptions = BaseOptions(
    baseUrl: AppConfig.env['GERENCIANET_URL'] ??
        AppConfig.env['gerencianetURL'] ??
        '',
    connectTimeout: 60000,
    receiveTimeout: 60000,
  );

  void _configureCertificates() {
    httpClientAdapter = Http2Adapter(
      ConnectionManager(
        onClientCreate: (_, config) {
          final pathCRT = AppConfig.env['GERENCIANET_CERTIFICADO_CRT'] ??
              AppConfig.env['gerencianetCertificadoCRT'];
          final pathKEY = AppConfig.env['GERENCIANET_CERTIFICADO_KEY'] ??
              AppConfig.env['gerencianetCertificadoKEY'];

          final root = Directory.current.path;
          final securityContext = SecurityContext(withTrustedRoots: true)
            ..useCertificateChain('$root/$pathCRT')
            ..usePrivateKey('$root/$pathKEY');

          config.context = securityContext;
        },
      ),
    );
  }
}
