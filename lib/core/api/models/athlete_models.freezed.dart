// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'athlete_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Athlete {

 int get id; String get username; String get firstName; String get lastName; String? get birthDate; String? get phone;@JsonKey(includeToJson: false) String? get avatar;
/// Create a copy of Athlete
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AthleteCopyWith<Athlete> get copyWith => _$AthleteCopyWithImpl<Athlete>(this as Athlete, _$identity);

  /// Serializes this Athlete to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Athlete&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatar, avatar) || other.avatar == avatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,firstName,lastName,birthDate,phone,avatar);

@override
String toString() {
  return 'Athlete(id: $id, username: $username, firstName: $firstName, lastName: $lastName, birthDate: $birthDate, phone: $phone, avatar: $avatar)';
}


}

/// @nodoc
abstract mixin class $AthleteCopyWith<$Res>  {
  factory $AthleteCopyWith(Athlete value, $Res Function(Athlete) _then) = _$AthleteCopyWithImpl;
@useResult
$Res call({
 int id, String username, String firstName, String lastName, String? birthDate, String? phone,@JsonKey(includeToJson: false) String? avatar
});




}
/// @nodoc
class _$AthleteCopyWithImpl<$Res>
    implements $AthleteCopyWith<$Res> {
  _$AthleteCopyWithImpl(this._self, this._then);

  final Athlete _self;
  final $Res Function(Athlete) _then;

/// Create a copy of Athlete
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? firstName = null,Object? lastName = null,Object? birthDate = freezed,Object? phone = freezed,Object? avatar = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Athlete].
extension AthletePatterns on Athlete {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Athlete value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Athlete() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Athlete value)  $default,){
final _that = this;
switch (_that) {
case _Athlete():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Athlete value)?  $default,){
final _that = this;
switch (_that) {
case _Athlete() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String username,  String firstName,  String lastName,  String? birthDate,  String? phone, @JsonKey(includeToJson: false)  String? avatar)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Athlete() when $default != null:
return $default(_that.id,_that.username,_that.firstName,_that.lastName,_that.birthDate,_that.phone,_that.avatar);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String username,  String firstName,  String lastName,  String? birthDate,  String? phone, @JsonKey(includeToJson: false)  String? avatar)  $default,) {final _that = this;
switch (_that) {
case _Athlete():
return $default(_that.id,_that.username,_that.firstName,_that.lastName,_that.birthDate,_that.phone,_that.avatar);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String username,  String firstName,  String lastName,  String? birthDate,  String? phone, @JsonKey(includeToJson: false)  String? avatar)?  $default,) {final _that = this;
switch (_that) {
case _Athlete() when $default != null:
return $default(_that.id,_that.username,_that.firstName,_that.lastName,_that.birthDate,_that.phone,_that.avatar);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Athlete extends Athlete {
  const _Athlete({this.id = 0, this.username = '', this.firstName = '', this.lastName = '', this.birthDate, this.phone, @JsonKey(includeToJson: false) this.avatar}): super._();
  factory _Athlete.fromJson(Map<String, dynamic> json) => _$AthleteFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  String username;
@override@JsonKey() final  String firstName;
@override@JsonKey() final  String lastName;
@override final  String? birthDate;
@override final  String? phone;
@override@JsonKey(includeToJson: false) final  String? avatar;

/// Create a copy of Athlete
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AthleteCopyWith<_Athlete> get copyWith => __$AthleteCopyWithImpl<_Athlete>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AthleteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Athlete&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatar, avatar) || other.avatar == avatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,firstName,lastName,birthDate,phone,avatar);

@override
String toString() {
  return 'Athlete(id: $id, username: $username, firstName: $firstName, lastName: $lastName, birthDate: $birthDate, phone: $phone, avatar: $avatar)';
}


}

/// @nodoc
abstract mixin class _$AthleteCopyWith<$Res> implements $AthleteCopyWith<$Res> {
  factory _$AthleteCopyWith(_Athlete value, $Res Function(_Athlete) _then) = __$AthleteCopyWithImpl;
@override @useResult
$Res call({
 int id, String username, String firstName, String lastName, String? birthDate, String? phone,@JsonKey(includeToJson: false) String? avatar
});




}
/// @nodoc
class __$AthleteCopyWithImpl<$Res>
    implements _$AthleteCopyWith<$Res> {
  __$AthleteCopyWithImpl(this._self, this._then);

  final _Athlete _self;
  final $Res Function(_Athlete) _then;

/// Create a copy of Athlete
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? firstName = null,Object? lastName = null,Object? birthDate = freezed,Object? phone = freezed,Object? avatar = freezed,}) {
  return _then(_Athlete(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CreateAthleteRequest {

 String get firstName; String get lastName; String get birthDate;
/// Create a copy of CreateAthleteRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateAthleteRequestCopyWith<CreateAthleteRequest> get copyWith => _$CreateAthleteRequestCopyWithImpl<CreateAthleteRequest>(this as CreateAthleteRequest, _$identity);

  /// Serializes this CreateAthleteRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateAthleteRequest&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,birthDate);

@override
String toString() {
  return 'CreateAthleteRequest(firstName: $firstName, lastName: $lastName, birthDate: $birthDate)';
}


}

/// @nodoc
abstract mixin class $CreateAthleteRequestCopyWith<$Res>  {
  factory $CreateAthleteRequestCopyWith(CreateAthleteRequest value, $Res Function(CreateAthleteRequest) _then) = _$CreateAthleteRequestCopyWithImpl;
@useResult
$Res call({
 String firstName, String lastName, String birthDate
});




}
/// @nodoc
class _$CreateAthleteRequestCopyWithImpl<$Res>
    implements $CreateAthleteRequestCopyWith<$Res> {
  _$CreateAthleteRequestCopyWithImpl(this._self, this._then);

  final CreateAthleteRequest _self;
  final $Res Function(CreateAthleteRequest) _then;

/// Create a copy of CreateAthleteRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firstName = null,Object? lastName = null,Object? birthDate = null,}) {
  return _then(_self.copyWith(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateAthleteRequest].
extension CreateAthleteRequestPatterns on CreateAthleteRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateAthleteRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateAthleteRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateAthleteRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateAthleteRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateAthleteRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateAthleteRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String firstName,  String lastName,  String birthDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateAthleteRequest() when $default != null:
return $default(_that.firstName,_that.lastName,_that.birthDate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String firstName,  String lastName,  String birthDate)  $default,) {final _that = this;
switch (_that) {
case _CreateAthleteRequest():
return $default(_that.firstName,_that.lastName,_that.birthDate);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String firstName,  String lastName,  String birthDate)?  $default,) {final _that = this;
switch (_that) {
case _CreateAthleteRequest() when $default != null:
return $default(_that.firstName,_that.lastName,_that.birthDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateAthleteRequest implements CreateAthleteRequest {
  const _CreateAthleteRequest({required this.firstName, required this.lastName, required this.birthDate});
  factory _CreateAthleteRequest.fromJson(Map<String, dynamic> json) => _$CreateAthleteRequestFromJson(json);

@override final  String firstName;
@override final  String lastName;
@override final  String birthDate;

/// Create a copy of CreateAthleteRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateAthleteRequestCopyWith<_CreateAthleteRequest> get copyWith => __$CreateAthleteRequestCopyWithImpl<_CreateAthleteRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateAthleteRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateAthleteRequest&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,birthDate);

@override
String toString() {
  return 'CreateAthleteRequest(firstName: $firstName, lastName: $lastName, birthDate: $birthDate)';
}


}

/// @nodoc
abstract mixin class _$CreateAthleteRequestCopyWith<$Res> implements $CreateAthleteRequestCopyWith<$Res> {
  factory _$CreateAthleteRequestCopyWith(_CreateAthleteRequest value, $Res Function(_CreateAthleteRequest) _then) = __$CreateAthleteRequestCopyWithImpl;
@override @useResult
$Res call({
 String firstName, String lastName, String birthDate
});




}
/// @nodoc
class __$CreateAthleteRequestCopyWithImpl<$Res>
    implements _$CreateAthleteRequestCopyWith<$Res> {
  __$CreateAthleteRequestCopyWithImpl(this._self, this._then);

  final _CreateAthleteRequest _self;
  final $Res Function(_CreateAthleteRequest) _then;

/// Create a copy of CreateAthleteRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstName = null,Object? lastName = null,Object? birthDate = null,}) {
  return _then(_CreateAthleteRequest(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
