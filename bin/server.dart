import 'dart:developer';
import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:vakinha_burger_api/app/modules/auth/auth_controller.dart';
import 'package:vakinha_burger_api/app/modules/order/order_controller.dart';
import 'package:vakinha_burger_api/app/modules/product/product_controller.dart';
import 'package:vakinha_burger_api/app/modules/webhooks/gerencianet_webhook_controller.dart';

final staticFiles = createStaticHandler('images/', listDirectories: true);

final _router = Router()
  ..mount('/auth/', AuthController().router)
  ..mount('/products/', ProductController().router)
  ..mount('/order/', OrderController().router)
  ..mount('/gerencianet/webhook', GerencianetWebhookController().router)
  ..mount('/images/', staticFiles);

void main() async {
  final ip = InternetAddress.anyIPv4;

  DotEnv(includePlatformEnvironment: true).load();

  final handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(_router);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);

  log('Server listening on port ${server.port}');
}
