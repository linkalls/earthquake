class Earthquake {
  final String anm;
  final String ttl;
  final String mag;
  final String maxi;
  final String json;
  Earthquake({this.anm = '', this.ttl = "", this.mag = "", this.maxi = "",this.json = ""});

  factory Earthquake.fromJson(Map<String, dynamic> json) {
    return Earthquake(
      anm: json['anm'] ?? '',
      ttl: json['ttl'] ?? '',
      mag: json['mag'] ?? '',
      maxi: json['maxi'] ?? '',
      json: json['json'] ?? '',
    );
  }
}
