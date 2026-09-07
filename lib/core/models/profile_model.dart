import 'dart:convert';

/// Foydalanuvchi tahrirlashi mumkin bo'lgan profil ma'lumotlari.
/// SharedPrefs'da JSON ko'rinishida saqlanadi.
class ProfileModel {
  final String firstName;
  final String lastName;
  final String phone;
  final String? dateOfBirth;
  final int? heightCm;
  final int? weightKg;

  const ProfileModel({
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.dateOfBirth,
    this.heightCm,
    this.weightKg,
  });

  String get fullName => '$firstName $lastName';

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] as String?,
      heightCm: json['heightCm'] as int?,
      weightKg: json['weightKg'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'phone': phone,
    'dateOfBirth': dateOfBirth,
    'heightCm': heightCm,
    'weightKg': weightKg,
  };

  String encode() => jsonEncode(toJson());

  static ProfileModel? decode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return ProfileModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
