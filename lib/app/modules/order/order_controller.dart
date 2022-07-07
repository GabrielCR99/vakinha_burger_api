import 'dart:async';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../services/order_service.dart';
import '../../view_models/order_view_model.dart';

part 'order_controller.g.dart';

class OrderController {
  final _service = OrderService();

  @Route.post('/')
  Future<Response> register(Request request) async {
    final orderModel = OrderViewModel.fromJson(await request.readAsString());
    final order = await _service.createOrder(orderModel);

    return Response.ok(
      order.toJson(),
      headers: {'content-type': 'application/json'},
    );
  }

  Router get router => _$OrderControllerRouter(this);
}
