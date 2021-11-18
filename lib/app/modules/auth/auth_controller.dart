import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:vakinha_burger_api/app/core/exceptions/email_already_registered.dart';
import 'package:vakinha_burger_api/app/core/exceptions/user_not_found_exceptino.dart';
import 'package:vakinha_burger_api/app/entities/user.dart';
import 'package:vakinha_burger_api/app/repositories/user_repository.dart';

part 'auth_controller.g.dart';

class AuthController {
  final _userRepository = UserRepository();

  @Route.post('/')
  Future<Response> login(Request request) async {
    final jsonRequest = jsonDecode(await request.readAsString());
    try {
      final user = await _userRepository.login(
          jsonRequest['email'], jsonRequest['password']);

      return Response.ok(user.toJson(), headers: {
        'content-type': 'application/json',
      });
    } on UserNotFoundExceptino catch (e, s) {
      print(e);
      print(s);
      return Response(403, headers: {
        'content-type': 'application/json',
      });
    } catch (e) {
      return Response.internalServerError();
    }
  }

  @Route.post('/register')
  Future<Response> register(Request request) async {
    try {
      final userRq = User.fromJson(await request.readAsString());
      await _userRepository.save(userRq);

      return Response(200, headers: {
        'content-type': 'application/json',
      });
    } on EmailAlreadyRegistered catch (e, s) {
      print(e);
      print(s);
      return Response(400,
          body: jsonEncode(
            {'error': 'E-mail já utilizado por outro usuário'},
          ),
          headers: {
            'content-type': 'application/json',
          });
    } catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  Router get router => _$AuthControllerRouter(this);
}
