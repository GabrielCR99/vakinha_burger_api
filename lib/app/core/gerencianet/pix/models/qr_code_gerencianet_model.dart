import 'dart:convert';

class QrCodeGerencianetModel {
  final String image;
  final String code;

  const QrCodeGerencianetModel({
    required this.image,
    required this.code,
  });

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'code': code,
    };
  }

  factory QrCodeGerencianetModel.fromMap(Map<String, dynamic> map) {
    return QrCodeGerencianetModel(
      image: map['image'] ?? '',
      code: map['code'] ?? '',
    );
  }

  String toJson() => jsonEncode(toMap());

  factory QrCodeGerencianetModel.fromJson(String source) =>
      QrCodeGerencianetModel.fromMap(json.decode(source));
}
