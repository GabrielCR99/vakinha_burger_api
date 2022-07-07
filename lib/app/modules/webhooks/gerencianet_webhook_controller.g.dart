// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gerencianet_webhook_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$GerencianetWebhookControllerRouter(
    GerencianetWebhookController service) {
  final router = Router();
  router.add('POST', r'/', service.webhookConfig);
  router.add('POST', r'/pix', service.webhookPaymentCallback);
  return router;
}
