import 'package:mysql1/mysql1.dart';
import 'package:vakinha_burger_api/app/core/exceptions/email_already_registered.dart';
import 'package:vakinha_burger_api/app/core/exceptions/user_not_found_exceptino.dart';
import 'package:vakinha_burger_api/app/core/helpers/crypt_helper.dart';
import '../core/database/database.dart';
import '../entities/user.dart';

class UserRepository {
  Future<User> login(String email, String password) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();

      await Future.delayed(const Duration(milliseconds: 1));

      final result = await conn.query(
        ''' SELECT * FROM usuario WHERE email = ? AND senha = ?  ''',
        [email, CryptHelper.generatedSha256Hash(password)],
      );

      if (result.isEmpty) {
        throw UserNotFoundExceptino();
      }

      final userData = result.first;

      return User(
        id: userData['id'],
        name: userData['nome'],
        email: userData['email'],
        password: '',
      );
    } on MySqlException catch (e, s) {
      print(e);
      print(s);
      throw Exception('Erro ao realizar login');
    } finally {
      await conn?.close();
    }
  }

  Future<void> save(User user) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();

      await Future.delayed(const Duration(seconds: 1));

      final isUserRegiser = await conn
          .query('select * from usuario where email = ? ', [user.email]);

      if (isUserRegiser.isEmpty) {
        await conn.query(''' 
          insert into usuario
          values(?,?,?,?)
        ''', [
          null,
          user.name,
          user.email,
          CryptHelper.generatedSha256Hash(user.password)
        ]);
      } else {
        throw EmailAlreadyRegistered();
      }
    } on MySqlException catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    } finally {
      await conn?.close();
    }
  }
}
