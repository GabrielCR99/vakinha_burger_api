import 'package:mysql1/mysql1.dart';

import '../core/database/database.dart';
import '../entities/product.dart';

class ProductRepository {
  Future<List<Product>> findAll() async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();
      final result = await conn.query(''' SELECT * FROM produto ''');

      return result
          .map(
            (p) => Product(
              id: p['id'],
              name: p['nome'],
              image: (p['imagem'] as Blob?)?.toString() ?? '',
              description: (p['descricao'] as Blob?)?.toString() ?? '',
              price: p['preco'],
            ),
          )
          .toList();
    } on MySqlException catch (e, s) {
      Error.throwWithStackTrace(Exception(), s);
    } finally {
      await conn?.close();
    }
  }

  Future<Product> findById(int id) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();
      final result = await conn.query(
        ''' SELECT * FROM produto WHERE id = ? ''',
        [id],
      );

      return result
          .map(
            (p) => Product(
              id: p['id'],
              name: p['nome'],
              image: (p['imagem'] as Blob?)?.toString() ?? '',
              description: (p['descricao'] as Blob?)?.toString() ?? '',
              price: p['preco'],
            ),
          )
          .first;
    } on MySqlException catch (e, s) {
      Error.throwWithStackTrace(Exception(), s);
    } finally {
      await conn?.close();
    }
  }
}
