// models.dart

class Earthquake {
 final String anm;
 final String rdt;
 final String mag;
 final String time;

 Earthquake({this.anm = '', this.rdt = '', this.mag = '', this.time = ''});

 factory Earthquake.fromJson(Map<String, dynamic> json) {
  return Earthquake(
   anm: json['anm'] ?? '',
   rdt: json['rdt'] ?? '',
   mag: json['mag'] ?? '',
   time: json['time'] ?? '',
  );
 }

}