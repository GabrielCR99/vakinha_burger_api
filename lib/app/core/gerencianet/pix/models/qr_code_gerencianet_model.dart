import 'dart:convert';

class QrCodeGerencianetModel {
  final String image;
  final String code;
  final double totalValue;

  const QrCodeGerencianetModel({
    required this.image,
    required this.code,
    required this.totalValue,
  });

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'code': code,
      'totalValue': totalValue,
    };
  }

  factory QrCodeGerencianetModel.fromMap(Map<String, dynamic> map) {
    return QrCodeGerencianetModel(
      image: map['image'] ?? '',
      code: map['code'] ?? '',
      totalValue: map['totalValue']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory QrCodeGerencianetModel.fromJson(String source) =>
      QrCodeGerencianetModel.fromMap(json.decode(source));
}
