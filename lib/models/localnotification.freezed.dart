// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'localnotification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LocalNotification _$LocalNotificationFromJson(Map<String, dynamic> json) {
  return _LocalNotification.fromJson(json);
}

/// @nodoc
mixin _$LocalNotification {
  @Id(assignable: true)
  int? get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  String? get payload => throw _privateConstructorUsedError;
  @Property(type: PropertyType.date)
  DateTime? get scheduledTime => throw _privateConstructorUsedError;

  /// Serializes this LocalNotification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocalNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocalNotificationCopyWith<LocalNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalNotificationCopyWith<$Res> {
  factory $LocalNotificationCopyWith(
          LocalNotification value, $Res Function(LocalNotification) then) =
      _$LocalNotificationCopyWithImpl<$Res, LocalNotification>;
  @useResult
  $Res call(
      {@Id(assignable: true) int? id,
      String title,
      String body,
      String? payload,
      @Property(type: PropertyType.date) DateTime? scheduledTime});
}

/// @nodoc
class _$LocalNotificationCopyWithImpl<$Res, $Val extends LocalNotification>
    implements $LocalNotificationCopyWith<$Res> {
  _$LocalNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocalNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? body = null,
    Object? payload = freezed,
    Object? scheduledTime = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      payload: freezed == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledTime: freezed == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocalNotificationImplCopyWith<$Res>
    implements $LocalNotificationCopyWith<$Res> {
  factory _$$LocalNotificationImplCopyWith(_$LocalNotificationImpl value,
          $Res Function(_$LocalNotificationImpl) then) =
      __$$LocalNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@Id(assignable: true) int? id,
      String title,
      String body,
      String? payload,
      @Property(type: PropertyType.date) DateTime? scheduledTime});
}

/// @nodoc
class __$$LocalNotificationImplCopyWithImpl<$Res>
    extends _$LocalNotificationCopyWithImpl<$Res, _$LocalNotificationImpl>
    implements _$$LocalNotificationImplCopyWith<$Res> {
  __$$LocalNotificationImplCopyWithImpl(_$LocalNotificationImpl _value,
      $Res Function(_$LocalNotificationImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocalNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? body = null,
    Object? payload = freezed,
    Object? scheduledTime = freezed,
  }) {
    return _then(_$LocalNotificationImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      payload: freezed == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledTime: freezed == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@Entity(realClass: LocalNotification)
class _$LocalNotificationImpl extends _LocalNotification
    with DiagnosticableTreeMixin {
  _$LocalNotificationImpl(
      {@Id(assignable: true) this.id,
      required this.title,
      required this.body,
      this.payload,
      @Property(type: PropertyType.date) this.scheduledTime})
      : super._();

  factory _$LocalNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocalNotificationImplFromJson(json);

  @override
  @Id(assignable: true)
  final int? id;
  @override
  final String title;
  @override
  final String body;
  @override
  final String? payload;
  @override
  @Property(type: PropertyType.date)
  final DateTime? scheduledTime;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LocalNotification(id: $id, title: $title, body: $body, payload: $payload, scheduledTime: $scheduledTime)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LocalNotification'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('body', body))
      ..add(DiagnosticsProperty('payload', payload))
      ..add(DiagnosticsProperty('scheduledTime', scheduledTime));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalNotificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.payload, payload) || other.payload == payload) &&
            (identical(other.scheduledTime, scheduledTime) ||
                other.scheduledTime == scheduledTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, body, payload, scheduledTime);

  /// Create a copy of LocalNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalNotificationImplCopyWith<_$LocalNotificationImpl> get copyWith =>
      __$$LocalNotificationImplCopyWithImpl<_$LocalNotificationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocalNotificationImplToJson(
      this,
    );
  }
}

abstract class _LocalNotification extends LocalNotification {
  factory _LocalNotification(
          {@Id(assignable: true) final int? id,
          required final String title,
          required final String body,
          final String? payload,
          @Property(type: PropertyType.date) final DateTime? scheduledTime}) =
      _$LocalNotificationImpl;
  _LocalNotification._() : super._();

  factory _LocalNotification.fromJson(Map<String, dynamic> json) =
      _$LocalNotificationImpl.fromJson;

  @override
  @Id(assignable: true)
  int? get id;
  @override
  String get title;
  @override
  String get body;
  @override
  String? get payload;
  @override
  @Property(type: PropertyType.date)
  DateTime? get scheduledTime;

  /// Create a copy of LocalNotification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocalNotificationImplCopyWith<_$LocalNotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}