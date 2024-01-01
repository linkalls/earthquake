// models.dart

class Earthquake {
 final String anm;
 final String rdt;
 final String mag;

 Earthquake({this.anm = '', this.rdt = '', this.mag = '', });

 factory Earthquake.fromJson(Map<String, dynamic> json) {
  return Earthquake(
   anm: json['anm'] ?? '',
   rdt: json['rdt'] ?? '',
   mag: json['mag'] ?? '',
  );
 }

}