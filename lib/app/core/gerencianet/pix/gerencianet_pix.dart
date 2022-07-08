import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../config/app_config.dart';
import '../gerencianet_rest_client.dart';
import 'models/billing_gerencianet_model.dart';
import 'models/qr_code_gerencianet_model.dart';

class GerencianetPix {
  Future<BillingGerencianetModel> generateBilling({
    required double value,
    required int orderId,
    String? cpf,
    String? name,
  }) async {
    try {
      final restClient = GerencianetRestClient();

      final billingData = {
        'calendario': {'expiracao': 3600},
        'devedor': {'cpf': cpf, 'nome': name},
        'valor': {'original': value.toStringAsFixed(2)},
        'chave': AppConfig.env['gerencianetChavePix'],
        'solicitacaoPagador': 'Pedido de número $orderId no vakinha burger',
        'infoAdicionais': [
          {
            'nome': 'orderId',
            'valor': '$orderId',
          },
        ],
      };

      final billingResponse =
          await restClient.auth().post('/v2/cob', data: billingData);

      final data = billingResponse.data;

      return BillingGerencianetModel(
        transactionId: data['txid'],
        locationId: data['loc']['id'],
        totalValue: double.parse(data['valor']['original']),
      );
    } on DioError catch (e) {
      log('Erro ao gerar cobrança: $e');
      rethrow;
    }
  }

  Future<QrCodeGerencianetModel> getQrCode(
    int locationId,
    double totalValue,
  ) async {
    try {
      final restClient = GerencianetRestClient();

      final qrCodeResponse =
          await restClient.auth().get('/v2/loc/$locationId/qrcode');

      final data = qrCodeResponse.data;

      return QrCodeGerencianetModel(
        code: data['qrcode'],
        image: data['imagemQrcode'],
        totalValue: totalValue,
      );
    } on DioError catch (e) {
      log('Erro ao gerar código QR: $e');
      rethrow;
    }
  }

  Future<void> registerWebhook() async {
    final restClient = GerencianetRestClient();

    await restClient.auth().put(
      '/v2/webhook/${AppConfig.env['gerencianetChavePix']}',
      data: {'webhookUrl': '${AppConfig.env['gerencianetWebhookUrl']}'},
    );
  }
}
