class Hospital {
  final String nome;
  final String endereco;
  final double latitude;
  final double longitude;
  final String tipo;

  Hospital({
    required this.nome,
    required this.endereco,
    required this.latitude,
    required this.longitude,
    required this.tipo,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      nome: json['nome'] as String,
      endereco: json['endereco'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      tipo: json['tipo'] as String? ?? 'UBS',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'endereco': endereco,
      'latitude': latitude,
      'longitude': longitude,
      'tipo': tipo,
    };
  }
}