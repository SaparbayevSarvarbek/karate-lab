import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/profile_model.dart';

class SharedPrefsService {
  static SharedPrefsService? _instance;
  static SharedPreferences? _prefs;

  SharedPrefsService._();

  static Future<SharedPrefsService> getInstance() async {
    _instance ??= SharedPrefsService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  Future<bool> isFirstTimeLaunch() async {
    return _prefs?.getBool(AppConstants.isFirstTimeLaunchKey) ?? true;
  }

  Future<void> setFirstTimeLaunchDone() async {
    await _prefs?.setBool(AppConstants.isFirstTimeLaunchKey, false);
  }

  Future<void> saveSelectedRole(String role) async {
    await _prefs?.setString(AppConstants.selectedRoleKey, role);
  }

  Future<String?> getSelectedRole() async {
    return _prefs?.getString(AppConstants.selectedRoleKey);
  }

  Future<bool?> getDarkMode() async {
    return _prefs?.getBool(AppConstants.isDarkModeKey);
  }

  Future<void> setDarkMode(bool value) async {
    await _prefs?.setBool(AppConstants.isDarkModeKey, value);
  }

  Future<void> saveLanguage(String language) async {
    await _prefs?.setString(AppConstants.selectedLanguageKey, language);
  }

  String? getLanguage() {
    return _prefs?.getString(AppConstants.selectedLanguageKey);
  }

  Future<void> saveUserProfile(ProfileModel profile) async {
    await _prefs?.setString(AppConstants.userProfileKey, profile.encode());
  }

  Future<ProfileModel?> getUserProfile() async {
    return ProfileModel.decode(_prefs?.getString(AppConstants.userProfileKey));
  }

  Future<void> saveAccessToken(String token) async {
    await _prefs?.setString(AppConstants.accessTokenKey, token);
  }

  String? getAccessToken() {
    return _prefs?.getString(AppConstants.accessTokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _prefs?.setString(AppConstants.refreshTokenKey, token);
  }

  String? getRefreshToken() {
    return _prefs?.getString(AppConstants.refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await _prefs?.remove(AppConstants.accessTokenKey);
    await _prefs?.remove(AppConstants.refreshTokenKey);
  }

  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
