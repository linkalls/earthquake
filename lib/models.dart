// models.dart

class Earthquake {
  final int id;
  final String anm;
  final String at;
  final String mag;
  final String maxi;
  final String ttl; // ttlフィールドを追加

  Earthquake({
    this.id = 0,
    this.anm = '',
    this.at = '',
    this.mag = '',
    this.maxi = '',
    this.ttl = '', // 初期値を追加
  });

  factory Earthquake.fromJson(Map<String, dynamic> json) {
    return Earthquake(
      id: json['id'] ?? 0,
      anm: json['anm'] ?? '',
      at: json['at'] ?? '',
      mag: json['mag'] ?? '',
      maxi: json['maxi'] ?? '',
      ttl: json['ttl'] ?? '', // JSONから読み込む
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["anm"] = anm;
    map["at"] = at;
    map["mag"] = mag;
    map["maxi"] = maxi;
    map["ttl"] = ttl; // マップに追加
    return map;
  }
}

