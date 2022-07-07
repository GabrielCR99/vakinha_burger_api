import 'dart:convert';

import 'order_item_view_model.dart';

class OrderViewModel {
  final int userId;
  final String? cpf;
  final String address;
  final List<OrderItemViewModel> items;

  const OrderViewModel({
    required this.userId,
    required this.address,
    required this.items,
    this.cpf,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'cpf': cpf,
      'address': address,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory OrderViewModel.fromMap(Map<String, dynamic> map) {
    return OrderViewModel(
      userId: map['userId']?.toInt() ?? 0,
      cpf: map['cpf'],
      address: map['address'] ?? '',
      items: List<OrderItemViewModel>.from(
        map['items']?.map((x) => OrderItemViewModel.fromMap(x)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderViewModel.fromJson(String source) =>
      OrderViewModel.fromMap(json.decode(source));
}
