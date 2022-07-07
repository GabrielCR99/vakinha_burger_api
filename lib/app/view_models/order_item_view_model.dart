import 'dart:convert';

class OrderItemViewModel {
  final int amount;
  final int productId;

  const OrderItemViewModel({
    required this.amount,
    required this.productId,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'productId': productId,
    };
  }

  factory OrderItemViewModel.fromMap(Map<String, dynamic> map) {
    return OrderItemViewModel(
      amount: map['amount']?.toInt() ?? 0,
      productId: map['productId']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItemViewModel.fromJson(String source) =>
      OrderItemViewModel.fromMap(json.decode(source));
}
