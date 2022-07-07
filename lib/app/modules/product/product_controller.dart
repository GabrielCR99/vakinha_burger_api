import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../repositories/product_repository.dart';

part 'product_controller.g.dart';

class ProductController {
  final _repository = ProductRepository();

  @Route.get('/')
  Future<Response> find(Request _) async {
    try {
      final products = await _repository.findAll();

      return Response.ok(
        jsonEncode(products.map((p) => p.toMap()).toList()),
        headers: {'content-type': 'application/json'},
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());

      return Response.internalServerError();
    }
  }

  Router get router => _$ProductControllerRouter(this);
}
