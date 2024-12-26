// class Earthquake {
//   final String anm;
//   final String ttl;
//   final String mag;
//   final String maxi;
//   final String json;
//   Earthquake({this.anm = '', this.ttl = "", this.mag = "", this.maxi = "",this.json = ""});

//   factory Earthquake.fromJson(Map<String, dynamic> json) {
//     return Earthquake(
//       anm: json['anm'] ?? '',
//       ttl: json['ttl'] ?? '',
//       mag: json['mag'] ?? '',
//       maxi: json['maxi'] ?? '',
//       json: json['json'] ?? '',
//     );
//   }
// }

import 'package:freezed_annotation/freezed_annotation.dart';
import "package:flutter/foundation.dart";

part 'earthquake.freezed.dart';
part 'earthquake.g.dart';

@freezed
class Earthquake with _$Earthquake {
  const factory Earthquake({
    @Default("情報がうまく取得できませんでした") String anm,
    @Default("情報がうまく取得できませんでした") String ttl,
    @Default("情報がうまく取得できませんでした") String mag,
    @Default("情報がうまく取得できませんでした") String maxi,
    @Default("情報がうまく取得できませんでした") String json,
  }) = _Earthquake;

  factory Earthquake.fromJson(Map<String, dynamic> json) =>
      _$EarthquakeFromJson(json);
}
