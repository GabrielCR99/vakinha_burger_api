import 'package:mysql1/mysql1.dart';

import '../core/database/database.dart';
import '../core/exceptions/email_already_registered.dart';
import '../core/exceptions/user_not_found_exception.dart';
import '../core/helpers/crypt_helper.dart';
import '../entities/user.dart';

class UserRepository {
  Future<User> login(String email, String password) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();

      final result = await conn.query(
        ''' SELECT * FROM usuario WHERE email = ? AND senha = ?  ''',
        [email, CryptHelper.generateSha256Hash(password)],
      );

      if (result.isEmpty) {
        throw UserNotFoundException();
      }

      final userData = result.first;

      return User(
        id: userData['id'],
        name: userData['nome'],
        email: userData['email'],
        password: '',
      );
    } on MySqlException catch (e, s) {
      Error.throwWithStackTrace(Exception('Erro ao realizar login'), s);
    } finally {
      await conn?.close();
    }
  }

  Future<void> save(User user) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();

      final userRegistered = await conn
          .query('select * from usuario where email = ? ', [user.email]);

      if (userRegistered.isEmpty) {
        await conn.query(
          ''' 
          INSERT INTO usuario
          VALUES(?,?,?,?)
        ''',
          [
            null,
            user.name,
            user.email,
            CryptHelper.generateSha256Hash(user.password),
          ],
        );
      } else {
        throw EmailAlreadyRegistered();
      }
    } on MySqlException catch (e, s) {
      Error.throwWithStackTrace(Exception(), s);
    } finally {
      await conn?.close();
    }
  }

  Future<User> findById(int id) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();

      final result =
          await conn.query('SELECT * FROM usuario WHERE id = ?', [id]);

      if (result.isEmpty) {
        throw UserNotFoundException();
      }

      final userData = result.first;

      return User(
        id: userData['id'],
        name: userData['nome'],
        email: userData['email'],
        password: '',
      );
    } on MySqlException catch (e, s) {
      Error.throwWithStackTrace(Exception('Erro ao buscar usuario'), s);
    } finally {
      await conn?.close();
    }
  }
}
