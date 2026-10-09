// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_models.freezed.dart';
part 'category_models.g.dart';

/// Mashq kategoriyasi (UJT, MJT, Texnika, ...).
@freezed
abstract class Category with _$Category {
  const factory Category({
    @Default(0) int id,
    @Default('') String name,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}