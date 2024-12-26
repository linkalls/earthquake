// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'earthquake.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Earthquake _$EarthquakeFromJson(Map<String, dynamic> json) {
  return _Earthquake.fromJson(json);
}

/// @nodoc
mixin _$Earthquake {
  String get anm => throw _privateConstructorUsedError;
  String get ttl => throw _privateConstructorUsedError;
  String get mag => throw _privateConstructorUsedError;
  String get maxi => throw _privateConstructorUsedError;
  String get json => throw _privateConstructorUsedError;
  String get at => throw _privateConstructorUsedError;

  /// Serializes this Earthquake to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Earthquake
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EarthquakeCopyWith<Earthquake> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EarthquakeCopyWith<$Res> {
  factory $EarthquakeCopyWith(
          Earthquake value, $Res Function(Earthquake) then) =
      _$EarthquakeCopyWithImpl<$Res, Earthquake>;
  @useResult
  $Res call(
      {String anm,
      String ttl,
      String mag,
      String maxi,
      String json,
      String at});
}

/// @nodoc
class _$EarthquakeCopyWithImpl<$Res, $Val extends Earthquake>
    implements $EarthquakeCopyWith<$Res> {
  _$EarthquakeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Earthquake
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? anm = null,
    Object? ttl = null,
    Object? mag = null,
    Object? maxi = null,
    Object? json = null,
    Object? at = null,
  }) {
    return _then(_value.copyWith(
      anm: null == anm
          ? _value.anm
          : anm // ignore: cast_nullable_to_non_nullable
              as String,
      ttl: null == ttl
          ? _value.ttl
          : ttl // ignore: cast_nullable_to_non_nullable
              as String,
      mag: null == mag
          ? _value.mag
          : mag // ignore: cast_nullable_to_non_nullable
              as String,
      maxi: null == maxi
          ? _value.maxi
          : maxi // ignore: cast_nullable_to_non_nullable
              as String,
      json: null == json
          ? _value.json
          : json // ignore: cast_nullable_to_non_nullable
              as String,
      at: null == at
          ? _value.at
          : at // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EarthquakeImplCopyWith<$Res>
    implements $EarthquakeCopyWith<$Res> {
  factory _$$EarthquakeImplCopyWith(
          _$EarthquakeImpl value, $Res Function(_$EarthquakeImpl) then) =
      __$$EarthquakeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String anm,
      String ttl,
      String mag,
      String maxi,
      String json,
      String at});
}

/// @nodoc
class __$$EarthquakeImplCopyWithImpl<$Res>
    extends _$EarthquakeCopyWithImpl<$Res, _$EarthquakeImpl>
    implements _$$EarthquakeImplCopyWith<$Res> {
  __$$EarthquakeImplCopyWithImpl(
      _$EarthquakeImpl _value, $Res Function(_$EarthquakeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Earthquake
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? anm = null,
    Object? ttl = null,
    Object? mag = null,
    Object? maxi = null,
    Object? json = null,
    Object? at = null,
  }) {
    return _then(_$EarthquakeImpl(
      anm: null == anm
          ? _value.anm
          : anm // ignore: cast_nullable_to_non_nullable
              as String,
      ttl: null == ttl
          ? _value.ttl
          : ttl // ignore: cast_nullable_to_non_nullable
              as String,
      mag: null == mag
          ? _value.mag
          : mag // ignore: cast_nullable_to_non_nullable
              as String,
      maxi: null == maxi
          ? _value.maxi
          : maxi // ignore: cast_nullable_to_non_nullable
              as String,
      json: null == json
          ? _value.json
          : json // ignore: cast_nullable_to_non_nullable
              as String,
      at: null == at
          ? _value.at
          : at // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EarthquakeImpl extends _Earthquake with DiagnosticableTreeMixin {
  const _$EarthquakeImpl(
      {this.anm = "情報がうまく取得できませんでした",
      this.ttl = "情報がうまく取得できませんでした",
      this.mag = "情報がうまく取得できませんでした",
      this.maxi = "情報がうまく取得できませんでした",
      this.json = "情報がうまく取得できませんでした",
      this.at = "時間をうまく取得できませんでした"})
      : super._();

  factory _$EarthquakeImpl.fromJson(Map<String, dynamic> json) =>
      _$$EarthquakeImplFromJson(json);

  @override
  @JsonKey()
  final String anm;
  @override
  @JsonKey()
  final String ttl;
  @override
  @JsonKey()
  final String mag;
  @override
  @JsonKey()
  final String maxi;
  @override
  @JsonKey()
  final String json;
  @override
  @JsonKey()
  final String at;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Earthquake(anm: $anm, ttl: $ttl, mag: $mag, maxi: $maxi, json: $json, at: $at)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Earthquake'))
      ..add(DiagnosticsProperty('anm', anm))
      ..add(DiagnosticsProperty('ttl', ttl))
      ..add(DiagnosticsProperty('mag', mag))
      ..add(DiagnosticsProperty('maxi', maxi))
      ..add(DiagnosticsProperty('json', json))
      ..add(DiagnosticsProperty('at', at));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EarthquakeImpl &&
            (identical(other.anm, anm) || other.anm == anm) &&
            (identical(other.ttl, ttl) || other.ttl == ttl) &&
            (identical(other.mag, mag) || other.mag == mag) &&
            (identical(other.maxi, maxi) || other.maxi == maxi) &&
            (identical(other.json, json) || other.json == json) &&
            (identical(other.at, at) || other.at == at));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, anm, ttl, mag, maxi, json, at);

  /// Create a copy of Earthquake
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EarthquakeImplCopyWith<_$EarthquakeImpl> get copyWith =>
      __$$EarthquakeImplCopyWithImpl<_$EarthquakeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EarthquakeImplToJson(
      this,
    );
  }
}

abstract class _Earthquake extends Earthquake {
  const factory _Earthquake(
      {final String anm,
      final String ttl,
      final String mag,
      final String maxi,
      final String json,
      final String at}) = _$EarthquakeImpl;
  const _Earthquake._() : super._();

  factory _Earthquake.fromJson(Map<String, dynamic> json) =
      _$EarthquakeImpl.fromJson;

  @override
  String get anm;
  @override
  String get ttl;
  @override
  String get mag;
  @override
  String get maxi;
  @override
  String get json;
  @override
  String get at;

  /// Create a copy of Earthquake
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EarthquakeImplCopyWith<_$EarthquakeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
