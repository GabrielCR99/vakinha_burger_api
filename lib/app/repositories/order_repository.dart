import 'dart:developer';

import 'package:mysql1/mysql1.dart';

import '../core/database/database.dart';
import '../view_models/order_view_model.dart';

class OrderRepository {
  Future<int> save(OrderViewModel order) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();
      var orderIdResponse = 0;
      await conn.transaction((_) async {
        final orderResult = await conn!.query(
          ''' INSERT INTO pedido(usuario_id, cpf_cliente, endereco_entrega, status_pedido) VALUES (?, ?, ?, ?) ''',
          [order.userId, order.cpf, order.address, 'P'],
        );
        final orderId = orderResult.insertId;
        await conn.queryMulti(
          '''INSERT INTO pedido_item (quantidade, pedido_id, produto_id)
        VALUES (?, ?, ?) ''',
          order.items
              .map((item) => [item.amount, orderId, item.productId])
              .toList(),
        );
        if (orderId != null) {
          orderIdResponse = orderId;
        }
      });

      return orderIdResponse;
    } on MySqlException catch (e, s) {
      Error.throwWithStackTrace(Exception(), s);
    } finally {
      await conn?.close();
    }
  }

  Future<void> updateTransactionId(int orderId, String transactionId) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();
      await conn.query(
        '''UPDATE pedido SET id_transacao = ? WHERE id = ? ''',
        [transactionId, orderId],
      );
    } on MySqlException catch (e, s) {
      Error.throwWithStackTrace(Exception(), s);
    } finally {
      await conn?.close();
    }
  }

  Future<void> confirmPaymentByTransactionId(String transaction) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();
      await conn.query(
        '''UPDATE pedido SET status_pedido = ? WHERE id_transacao = ?''',
        ['F', transaction],
      );
    } on MySqlException catch (e, s) {
      log('$e');
      Error.throwWithStackTrace(Exception(), s);
    } finally {
      await conn?.close();
    }
  }
}
