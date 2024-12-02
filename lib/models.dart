class Earthquake {
  final String anm;
  final String ttl;
  Earthquake({
    this.anm = '',
    this.ttl = "",
  });

  factory Earthquake.fromJson(Map<String, dynamic> json) {
    return Earthquake(
      anm: json['anm'] ?? '',
      ttl: json['ttl'] ?? '',
    );
  }
}
