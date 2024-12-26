// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'earthquake.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EarthquakeImpl _$$EarthquakeImplFromJson(Map<String, dynamic> json) =>
    _$EarthquakeImpl(
      anm: json['anm'] as String? ?? "情報がうまく取得できませんでした",
      ttl: json['ttl'] as String? ?? "情報がうまく取得できませんでした",
      mag: json['mag'] as String? ?? "情報がうまく取得できませんでした",
      maxi: json['maxi'] as String? ?? "情報がうまく取得できませんでした",
      json: json['json'] as String? ?? "情報がうまく取得できませんでした",
    );

Map<String, dynamic> _$$EarthquakeImplToJson(_$EarthquakeImpl instance) =>
    <String, dynamic>{
      'anm': instance.anm,
      'ttl': instance.ttl,
      'mag': instance.mag,
      'maxi': instance.maxi,
      'json': instance.json,
    };
