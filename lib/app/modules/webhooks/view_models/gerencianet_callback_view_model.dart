import 'dart:convert';

import 'gerencianet_pix_view_model.dart';

class GerencianetCallbackViewModel {
  final List<GerencianetPixViewModel> pix;

  const GerencianetCallbackViewModel({required this.pix});

  Map<String, dynamic> toMap() {
    return {
      'pix': pix.map((x) => x.toMap()).toList(),
    };
  }

  factory GerencianetCallbackViewModel.fromMap(Map<String, dynamic> map) {
    return GerencianetCallbackViewModel(
      pix: List<GerencianetPixViewModel>.from(
        map['pix']?.map((x) => GerencianetPixViewModel.fromMap(x)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory GerencianetCallbackViewModel.fromJson(String source) =>
      GerencianetCallbackViewModel.fromMap(json.decode(source));
}
