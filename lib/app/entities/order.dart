import 'dart:convert';

import 'order_item.dart';

import 'user.dart';

class Order {
  final int id;
  final User user;
  final String? transactionId;
  final String? cpf;
  final String deliveryAddress;
  final String status;
  final List<OrderItem> items;

  const Order({
    required this.id,
    required this.user,
    required this.deliveryAddress,
    required this.status,
    required this.items,
    this.cpf,
    this.transactionId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user.toMap(),
      'transactionId': transactionId,
      'cpf': cpf,
      'deliveryAddress': deliveryAddress,
      'status': status,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id']?.toInt() ?? 0,
      user: User.fromMap(map['user']),
      transactionId: map['transactionId'],
      cpf: map['cpf'],
      deliveryAddress: map['deliveryAddress'] ?? '',
      status: map['status'] ?? '',
      items:
          List<OrderItem>.from(map['items']?.map((x) => OrderItem.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
}
