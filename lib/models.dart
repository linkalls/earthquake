// models.dart

class Earthquake {
 final String anm;
 final String ctt;
 final String mag;
 final String time;

 Earthquake({this.anm = '', this.ctt = '', this.mag = '', this.time = ''});

 factory Earthquake.fromJson(Map<String, dynamic> json) {
  return Earthquake(
   anm: json['anm'] ?? '',
   ctt: json['ctt'] ?? '',
   mag: json['mag'] ?? '',
   time: json['time'] ?? '',
  );
 }

}