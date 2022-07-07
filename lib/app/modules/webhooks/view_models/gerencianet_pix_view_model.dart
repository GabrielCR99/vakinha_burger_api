import 'dart:convert';

class GerencianetPixViewModel {
  final String endToEndId;
  final String transactionId;
  final String pixKey;
  final String value;
  final String date;
  final String description;

  const GerencianetPixViewModel({
    required this.endToEndId,
    required this.transactionId,
    required this.pixKey,
    required this.value,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'endToEndId': endToEndId,
      'txid': transactionId,
      'chave': pixKey,
      'valor': value,
      'horario': date,
      'infoPagador': description,
    };
  }

  factory GerencianetPixViewModel.fromMap(Map<String, dynamic> map) {
    return GerencianetPixViewModel(
      endToEndId: map['endToEndId'] ?? '',
      transactionId: map['txid'] ?? '',
      pixKey: map['chave'] ?? '',
      value: map['valor'] ?? '',
      date: map['horario'] ?? '',
      description: map['infoPagador'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GerencianetPixViewModel.fromJson(String source) =>
      GerencianetPixViewModel.fromMap(json.decode(source));
}
