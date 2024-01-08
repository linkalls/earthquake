// models.dart

class Earthquake {
  final int id;
  final String anm;
  final String at;
  final String mag;

  Earthquake({
    this.id = 0,
    this.anm = '',
    this.at = '',
    this.mag = '',
  });

  factory Earthquake.fromJson(Map<String, dynamic> json) {
    return Earthquake(
      id: json['id'] ?? 0,
      anm: json['anm'] ?? '',
      at: json['at'] ?? '',
      mag: json['mag'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["anm"] = anm;
    map["at"] = at;
    map["mag"] = mag;
    return map;
  }
}
