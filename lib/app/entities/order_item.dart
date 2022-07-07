import 'dart:convert';

import 'product.dart';

class OrderItem {
  final int id;
  final int amount;
  final Product product;

  const OrderItem({
    required this.id,
    required this.amount,
    required this.product,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'product': product.toMap(),
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id']?.toInt() ?? 0,
      amount: map['amount']?.toInt() ?? 0,
      product: Product.fromMap(map['product']),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItem.fromJson(String source) =>
      OrderItem.fromMap(json.decode(source));
}
