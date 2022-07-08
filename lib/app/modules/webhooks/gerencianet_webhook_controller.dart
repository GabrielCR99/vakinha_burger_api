import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../core/gerencianet/pix/gerencianet_pix.dart';
import '../../services/order_service.dart';
import 'view_models/gerencianet_callback_view_model.dart';

part 'gerencianet_webhook_controller.g.dart';

class GerencianetWebhookController {
  final _service = OrderService();

  @Route.post('/')
  Future<Response> webhookConfig(Request _) async {
    return Response(
      HttpStatus.ok,
      headers: {'content-type': 'application/json'},
    );
  }

  @Route.put('/register')
  Future<Response> register(Request _) async {
    await GerencianetPix().registerWebhook();

    return Response.ok(
      jsonEncode({'status': 'ok'}),
      headers: {'content-type': 'application/json'},
    );
  }

  @Route.post('/pix')
  Future<Response> webhookPaymentCallback(Request request) async {
    try {
      final callback =
          GerencianetCallbackViewModel.fromJson(await request.readAsString());

      await _service.confirmPayment(callback.pix.map((e) => e.transactionId));

      return Response(
        HttpStatus.ok,
        headers: {'content-type': 'application/json'},
      );
    } on Exception catch (e) {
      log(e.toString());

      return Response.internalServerError();
    }
  }

  Router get router => _$GerencianetWebhookControllerRouter(this);
}
