// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardData {

 String? get role; int? get totalAthletes; int? get activeAthletes; int? get totalTests; int? get totalExercises; double? get avgScore; int? get activeDays; int? get completedTests; List<RecentTestResult>? get recentTests;
/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardDataCopyWith<DashboardData> get copyWith => _$DashboardDataCopyWithImpl<DashboardData>(this as DashboardData, _$identity);

  /// Serializes this DashboardData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardData&&(identical(other.role, role) || other.role == role)&&(identical(other.totalAthletes, totalAthletes) || other.totalAthletes == totalAthletes)&&(identical(other.activeAthletes, activeAthletes) || other.activeAthletes == activeAthletes)&&(identical(other.totalTests, totalTests) || other.totalTests == totalTests)&&(identical(other.totalExercises, totalExercises) || other.totalExercises == totalExercises)&&(identical(other.avgScore, avgScore) || other.avgScore == avgScore)&&(identical(other.activeDays, activeDays) || other.activeDays == activeDays)&&(identical(other.completedTests, completedTests) || other.completedTests == completedTests)&&const DeepCollectionEquality().equals(other.recentTests, recentTests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,totalAthletes,activeAthletes,totalTests,totalExercises,avgScore,activeDays,completedTests,const DeepCollectionEquality().hash(recentTests));

@override
String toString() {
  return 'DashboardData(role: $role, totalAthletes: $totalAthletes, activeAthletes: $activeAthletes, totalTests: $totalTests, totalExercises: $totalExercises, avgScore: $avgScore, activeDays: $activeDays, completedTests: $completedTests, recentTests: $recentTests)';
}


}

/// @nodoc
abstract mixin class $DashboardDataCopyWith<$Res>  {
  factory $DashboardDataCopyWith(DashboardData value, $Res Function(DashboardData) _then) = _$DashboardDataCopyWithImpl;
@useResult
$Res call({
 String? role, int? totalAthletes, int? activeAthletes, int? totalTests, int? totalExercises, double? avgScore, int? activeDays, int? completedTests, List<RecentTestResult>? recentTests
});




}
/// @nodoc
class _$DashboardDataCopyWithImpl<$Res>
    implements $DashboardDataCopyWith<$Res> {
  _$DashboardDataCopyWithImpl(this._self, this._then);

  final DashboardData _self;
  final $Res Function(DashboardData) _then;

/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = freezed,Object? totalAthletes = freezed,Object? activeAthletes = freezed,Object? totalTests = freezed,Object? totalExercises = freezed,Object? avgScore = freezed,Object? activeDays = freezed,Object? completedTests = freezed,Object? recentTests = freezed,}) {
  return _then(_self.copyWith(
role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,totalAthletes: freezed == totalAthletes ? _self.totalAthletes : totalAthletes // ignore: cast_nullable_to_non_nullable
as int?,activeAthletes: freezed == activeAthletes ? _self.activeAthletes : activeAthletes // ignore: cast_nullable_to_non_nullable
as int?,totalTests: freezed == totalTests ? _self.totalTests : totalTests // ignore: cast_nullable_to_non_nullable
as int?,totalExercises: freezed == totalExercises ? _self.totalExercises : totalExercises // ignore: cast_nullable_to_non_nullable
as int?,avgScore: freezed == avgScore ? _self.avgScore : avgScore // ignore: cast_nullable_to_non_nullable
as double?,activeDays: freezed == activeDays ? _self.activeDays : activeDays // ignore: cast_nullable_to_non_nullable
as int?,completedTests: freezed == completedTests ? _self.completedTests : completedTests // ignore: cast_nullable_to_non_nullable
as int?,recentTests: freezed == recentTests ? _self.recentTests : recentTests // ignore: cast_nullable_to_non_nullable
as List<RecentTestResult>?,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardData].
extension DashboardDataPatterns on DashboardData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardData value)  $default,){
final _that = this;
switch (_that) {
case _DashboardData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardData value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? role,  int? totalAthletes,  int? activeAthletes,  int? totalTests,  int? totalExercises,  double? avgScore,  int? activeDays,  int? completedTests,  List<RecentTestResult>? recentTests)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardData() when $default != null:
return $default(_that.role,_that.totalAthletes,_that.activeAthletes,_that.totalTests,_that.totalExercises,_that.avgScore,_that.activeDays,_that.completedTests,_that.recentTests);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? role,  int? totalAthletes,  int? activeAthletes,  int? totalTests,  int? totalExercises,  double? avgScore,  int? activeDays,  int? completedTests,  List<RecentTestResult>? recentTests)  $default,) {final _that = this;
switch (_that) {
case _DashboardData():
return $default(_that.role,_that.totalAthletes,_that.activeAthletes,_that.totalTests,_that.totalExercises,_that.avgScore,_that.activeDays,_that.completedTests,_that.recentTests);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? role,  int? totalAthletes,  int? activeAthletes,  int? totalTests,  int? totalExercises,  double? avgScore,  int? activeDays,  int? completedTests,  List<RecentTestResult>? recentTests)?  $default,) {final _that = this;
switch (_that) {
case _DashboardData() when $default != null:
return $default(_that.role,_that.totalAthletes,_that.activeAthletes,_that.totalTests,_that.totalExercises,_that.avgScore,_that.activeDays,_that.completedTests,_that.recentTests);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardData implements DashboardData {
  const _DashboardData({this.role, this.totalAthletes, this.activeAthletes, this.totalTests, this.totalExercises, this.avgScore, this.activeDays, this.completedTests, final  List<RecentTestResult>? recentTests}): _recentTests = recentTests;
  factory _DashboardData.fromJson(Map<String, dynamic> json) => _$DashboardDataFromJson(json);

@override final  String? role;
@override final  int? totalAthletes;
@override final  int? activeAthletes;
@override final  int? totalTests;
@override final  int? totalExercises;
@override final  double? avgScore;
@override final  int? activeDays;
@override final  int? completedTests;
 final  List<RecentTestResult>? _recentTests;
@override List<RecentTestResult>? get recentTests {
  final value = _recentTests;
  if (value == null) return null;
  if (_recentTests is EqualUnmodifiableListView) return _recentTests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardDataCopyWith<_DashboardData> get copyWith => __$DashboardDataCopyWithImpl<_DashboardData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardData&&(identical(other.role, role) || other.role == role)&&(identical(other.totalAthletes, totalAthletes) || other.totalAthletes == totalAthletes)&&(identical(other.activeAthletes, activeAthletes) || other.activeAthletes == activeAthletes)&&(identical(other.totalTests, totalTests) || other.totalTests == totalTests)&&(identical(other.totalExercises, totalExercises) || other.totalExercises == totalExercises)&&(identical(other.avgScore, avgScore) || other.avgScore == avgScore)&&(identical(other.activeDays, activeDays) || other.activeDays == activeDays)&&(identical(other.completedTests, completedTests) || other.completedTests == completedTests)&&const DeepCollectionEquality().equals(other._recentTests, _recentTests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,totalAthletes,activeAthletes,totalTests,totalExercises,avgScore,activeDays,completedTests,const DeepCollectionEquality().hash(_recentTests));

@override
String toString() {
  return 'DashboardData(role: $role, totalAthletes: $totalAthletes, activeAthletes: $activeAthletes, totalTests: $totalTests, totalExercises: $totalExercises, avgScore: $avgScore, activeDays: $activeDays, completedTests: $completedTests, recentTests: $recentTests)';
}


}

/// @nodoc
abstract mixin class _$DashboardDataCopyWith<$Res> implements $DashboardDataCopyWith<$Res> {
  factory _$DashboardDataCopyWith(_DashboardData value, $Res Function(_DashboardData) _then) = __$DashboardDataCopyWithImpl;
@override @useResult
$Res call({
 String? role, int? totalAthletes, int? activeAthletes, int? totalTests, int? totalExercises, double? avgScore, int? activeDays, int? completedTests, List<RecentTestResult>? recentTests
});




}
/// @nodoc
class __$DashboardDataCopyWithImpl<$Res>
    implements _$DashboardDataCopyWith<$Res> {
  __$DashboardDataCopyWithImpl(this._self, this._then);

  final _DashboardData _self;
  final $Res Function(_DashboardData) _then;

/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = freezed,Object? totalAthletes = freezed,Object? activeAthletes = freezed,Object? totalTests = freezed,Object? totalExercises = freezed,Object? avgScore = freezed,Object? activeDays = freezed,Object? completedTests = freezed,Object? recentTests = freezed,}) {
  return _then(_DashboardData(
role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,totalAthletes: freezed == totalAthletes ? _self.totalAthletes : totalAthletes // ignore: cast_nullable_to_non_nullable
as int?,activeAthletes: freezed == activeAthletes ? _self.activeAthletes : activeAthletes // ignore: cast_nullable_to_non_nullable
as int?,totalTests: freezed == totalTests ? _self.totalTests : totalTests // ignore: cast_nullable_to_non_nullable
as int?,totalExercises: freezed == totalExercises ? _self.totalExercises : totalExercises // ignore: cast_nullable_to_non_nullable
as int?,avgScore: freezed == avgScore ? _self.avgScore : avgScore // ignore: cast_nullable_to_non_nullable
as double?,activeDays: freezed == activeDays ? _self.activeDays : activeDays // ignore: cast_nullable_to_non_nullable
as int?,completedTests: freezed == completedTests ? _self.completedTests : completedTests // ignore: cast_nullable_to_non_nullable
as int?,recentTests: freezed == recentTests ? _self._recentTests : recentTests // ignore: cast_nullable_to_non_nullable
as List<RecentTestResult>?,
  ));
}


}


/// @nodoc
mixin _$MyStatistics {

 double? get avgScore; int? get activeDays; int? get completedTests; List<RecentTestResult> get recentTests;
/// Create a copy of MyStatistics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyStatisticsCopyWith<MyStatistics> get copyWith => _$MyStatisticsCopyWithImpl<MyStatistics>(this as MyStatistics, _$identity);

  /// Serializes this MyStatistics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyStatistics&&(identical(other.avgScore, avgScore) || other.avgScore == avgScore)&&(identical(other.activeDays, activeDays) || other.activeDays == activeDays)&&(identical(other.completedTests, completedTests) || other.completedTests == completedTests)&&const DeepCollectionEquality().equals(other.recentTests, recentTests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,avgScore,activeDays,completedTests,const DeepCollectionEquality().hash(recentTests));

@override
String toString() {
  return 'MyStatistics(avgScore: $avgScore, activeDays: $activeDays, completedTests: $completedTests, recentTests: $recentTests)';
}


}

/// @nodoc
abstract mixin class $MyStatisticsCopyWith<$Res>  {
  factory $MyStatisticsCopyWith(MyStatistics value, $Res Function(MyStatistics) _then) = _$MyStatisticsCopyWithImpl;
@useResult
$Res call({
 double? avgScore, int? activeDays, int? completedTests, List<RecentTestResult> recentTests
});




}
/// @nodoc
class _$MyStatisticsCopyWithImpl<$Res>
    implements $MyStatisticsCopyWith<$Res> {
  _$MyStatisticsCopyWithImpl(this._self, this._then);

  final MyStatistics _self;
  final $Res Function(MyStatistics) _then;

/// Create a copy of MyStatistics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? avgScore = freezed,Object? activeDays = freezed,Object? completedTests = freezed,Object? recentTests = null,}) {
  return _then(_self.copyWith(
avgScore: freezed == avgScore ? _self.avgScore : avgScore // ignore: cast_nullable_to_non_nullable
as double?,activeDays: freezed == activeDays ? _self.activeDays : activeDays // ignore: cast_nullable_to_non_nullable
as int?,completedTests: freezed == completedTests ? _self.completedTests : completedTests // ignore: cast_nullable_to_non_nullable
as int?,recentTests: null == recentTests ? _self.recentTests : recentTests // ignore: cast_nullable_to_non_nullable
as List<RecentTestResult>,
  ));
}

}


/// Adds pattern-matching-related methods to [MyStatistics].
extension MyStatisticsPatterns on MyStatistics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyStatistics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyStatistics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyStatistics value)  $default,){
final _that = this;
switch (_that) {
case _MyStatistics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyStatistics value)?  $default,){
final _that = this;
switch (_that) {
case _MyStatistics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? avgScore,  int? activeDays,  int? completedTests,  List<RecentTestResult> recentTests)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyStatistics() when $default != null:
return $default(_that.avgScore,_that.activeDays,_that.completedTests,_that.recentTests);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? avgScore,  int? activeDays,  int? completedTests,  List<RecentTestResult> recentTests)  $default,) {final _that = this;
switch (_that) {
case _MyStatistics():
return $default(_that.avgScore,_that.activeDays,_that.completedTests,_that.recentTests);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? avgScore,  int? activeDays,  int? completedTests,  List<RecentTestResult> recentTests)?  $default,) {final _that = this;
switch (_that) {
case _MyStatistics() when $default != null:
return $default(_that.avgScore,_that.activeDays,_that.completedTests,_that.recentTests);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyStatistics implements MyStatistics {
  const _MyStatistics({this.avgScore, this.activeDays, this.completedTests, final  List<RecentTestResult> recentTests = const []}): _recentTests = recentTests;
  factory _MyStatistics.fromJson(Map<String, dynamic> json) => _$MyStatisticsFromJson(json);

@override final  double? avgScore;
@override final  int? activeDays;
@override final  int? completedTests;
 final  List<RecentTestResult> _recentTests;
@override@JsonKey() List<RecentTestResult> get recentTests {
  if (_recentTests is EqualUnmodifiableListView) return _recentTests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentTests);
}


/// Create a copy of MyStatistics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyStatisticsCopyWith<_MyStatistics> get copyWith => __$MyStatisticsCopyWithImpl<_MyStatistics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyStatisticsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyStatistics&&(identical(other.avgScore, avgScore) || other.avgScore == avgScore)&&(identical(other.activeDays, activeDays) || other.activeDays == activeDays)&&(identical(other.completedTests, completedTests) || other.completedTests == completedTests)&&const DeepCollectionEquality().equals(other._recentTests, _recentTests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,avgScore,activeDays,completedTests,const DeepCollectionEquality().hash(_recentTests));

@override
String toString() {
  return 'MyStatistics(avgScore: $avgScore, activeDays: $activeDays, completedTests: $completedTests, recentTests: $recentTests)';
}


}

/// @nodoc
abstract mixin class _$MyStatisticsCopyWith<$Res> implements $MyStatisticsCopyWith<$Res> {
  factory _$MyStatisticsCopyWith(_MyStatistics value, $Res Function(_MyStatistics) _then) = __$MyStatisticsCopyWithImpl;
@override @useResult
$Res call({
 double? avgScore, int? activeDays, int? completedTests, List<RecentTestResult> recentTests
});




}
/// @nodoc
class __$MyStatisticsCopyWithImpl<$Res>
    implements _$MyStatisticsCopyWith<$Res> {
  __$MyStatisticsCopyWithImpl(this._self, this._then);

  final _MyStatistics _self;
  final $Res Function(_MyStatistics) _then;

/// Create a copy of MyStatistics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? avgScore = freezed,Object? activeDays = freezed,Object? completedTests = freezed,Object? recentTests = null,}) {
  return _then(_MyStatistics(
avgScore: freezed == avgScore ? _self.avgScore : avgScore // ignore: cast_nullable_to_non_nullable
as double?,activeDays: freezed == activeDays ? _self.activeDays : activeDays // ignore: cast_nullable_to_non_nullable
as int?,completedTests: freezed == completedTests ? _self.completedTests : completedTests // ignore: cast_nullable_to_non_nullable
as int?,recentTests: null == recentTests ? _self._recentTests : recentTests // ignore: cast_nullable_to_non_nullable
as List<RecentTestResult>,
  ));
}


}


/// @nodoc
mixin _$RecentTestResult {

 String get testName; double get score; DateTime? get completedAt;
/// Create a copy of RecentTestResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentTestResultCopyWith<RecentTestResult> get copyWith => _$RecentTestResultCopyWithImpl<RecentTestResult>(this as RecentTestResult, _$identity);

  /// Serializes this RecentTestResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentTestResult&&(identical(other.testName, testName) || other.testName == testName)&&(identical(other.score, score) || other.score == score)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,testName,score,completedAt);

@override
String toString() {
  return 'RecentTestResult(testName: $testName, score: $score, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $RecentTestResultCopyWith<$Res>  {
  factory $RecentTestResultCopyWith(RecentTestResult value, $Res Function(RecentTestResult) _then) = _$RecentTestResultCopyWithImpl;
@useResult
$Res call({
 String testName, double score, DateTime? completedAt
});




}
/// @nodoc
class _$RecentTestResultCopyWithImpl<$Res>
    implements $RecentTestResultCopyWith<$Res> {
  _$RecentTestResultCopyWithImpl(this._self, this._then);

  final RecentTestResult _self;
  final $Res Function(RecentTestResult) _then;

/// Create a copy of RecentTestResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? testName = null,Object? score = null,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
testName: null == testName ? _self.testName : testName // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecentTestResult].
extension RecentTestResultPatterns on RecentTestResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecentTestResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecentTestResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecentTestResult value)  $default,){
final _that = this;
switch (_that) {
case _RecentTestResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecentTestResult value)?  $default,){
final _that = this;
switch (_that) {
case _RecentTestResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String testName,  double score,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecentTestResult() when $default != null:
return $default(_that.testName,_that.score,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String testName,  double score,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _RecentTestResult():
return $default(_that.testName,_that.score,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String testName,  double score,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _RecentTestResult() when $default != null:
return $default(_that.testName,_that.score,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecentTestResult implements RecentTestResult {
  const _RecentTestResult({this.testName = '', this.score = 0, this.completedAt});
  factory _RecentTestResult.fromJson(Map<String, dynamic> json) => _$RecentTestResultFromJson(json);

@override@JsonKey() final  String testName;
@override@JsonKey() final  double score;
@override final  DateTime? completedAt;

/// Create a copy of RecentTestResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecentTestResultCopyWith<_RecentTestResult> get copyWith => __$RecentTestResultCopyWithImpl<_RecentTestResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecentTestResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecentTestResult&&(identical(other.testName, testName) || other.testName == testName)&&(identical(other.score, score) || other.score == score)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,testName,score,completedAt);

@override
String toString() {
  return 'RecentTestResult(testName: $testName, score: $score, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$RecentTestResultCopyWith<$Res> implements $RecentTestResultCopyWith<$Res> {
  factory _$RecentTestResultCopyWith(_RecentTestResult value, $Res Function(_RecentTestResult) _then) = __$RecentTestResultCopyWithImpl;
@override @useResult
$Res call({
 String testName, double score, DateTime? completedAt
});




}
/// @nodoc
class __$RecentTestResultCopyWithImpl<$Res>
    implements _$RecentTestResultCopyWith<$Res> {
  __$RecentTestResultCopyWithImpl(this._self, this._then);

  final _RecentTestResult _self;
  final $Res Function(_RecentTestResult) _then;

/// Create a copy of RecentTestResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? testName = null,Object? score = null,Object? completedAt = freezed,}) {
  return _then(_RecentTestResult(
testName: null == testName ? _self.testName : testName // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
