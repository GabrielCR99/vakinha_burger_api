import 'dart:async';
import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../core/exceptions/email_already_registered.dart';
import '../../core/exceptions/user_not_found_exception.dart';
import '../../entities/user.dart';
import '../../repositories/user_repository.dart';

part 'auth_controller.g.dart';

class AuthController {
  final _userRepository = UserRepository();

  @Route.post('/')
  Future<Response> login(Request request) async {
    final jsonRequest = jsonDecode(await request.readAsString());
    try {
      final user = await _userRepository.login(
        jsonRequest['email'],
        jsonRequest['password'],
      );

      return Response.ok(
        user.toJson(),
        headers: {'content-type': 'application/json'},
      );
    } on UserNotFoundException {
      return Response.forbidden(
        jsonEncode({'message': 'User not found!'}),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError();
    }
  }

  @Route.post('/register')
  Future<Response> register(Request request) async {
    try {
      final userRq = User.fromJson(await request.readAsString());
      await _userRepository.save(userRq);

      return Response.ok(
        jsonEncode({'message': 'User registered!'}),
        headers: {'content-type': 'application/json'},
      );
    } on EmailAlreadyRegistered {
      return Response.badRequest(
        body: jsonEncode({'error': 'E-mail já utilizado por outro usuário'}),
        headers: {'content-type': 'application/json'},
      );
    } catch (_) {
      return Response.internalServerError();
    }
  }

  Router get router => _$AuthControllerRouter(this);
}
