import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  final String appName;
  final String orgName;
  final String webUrl;
  final String logoUrl;
  final bool isPushEnabled;
  final bool isDeeplinkEnabled;
  final bool isPullToRefreshEnabled;
  final bool isLoadingIndicatorEnabled;
  final bool isBottomMenuEnabled;
  final String bottomMenuBgColor;
  final String bottomMenuIconColor;
  final String bottomMenuTextColor;
  final String bottomMenuActiveTabColor;
  final List<Map<String, dynamic>> bottomMenuItems;
  final bool isCameraEnabled;
  final bool isLocationEnabled;
  final bool isMicrophoneEnabled;
  final bool isNotificationEnabled;
  final bool isContactEnabled;
  final bool isBiometricEnabled;
  final bool isCalendarEnabled;
  final bool isStorageEnabled;

  AppConfig({
    required this.appName,
    required this.orgName,
    required this.webUrl,
    required this.logoUrl,
    required this.isPushEnabled,
    required this.isDeeplinkEnabled,
    required this.isPullToRefreshEnabled,
    required this.isLoadingIndicatorEnabled,
    required this.isBottomMenuEnabled,
    required this.bottomMenuBgColor,
    required this.bottomMenuIconColor,
    required this.bottomMenuTextColor,
    required this.bottomMenuActiveTabColor,
    required this.bottomMenuItems,
    required this.isCameraEnabled,
    required this.isLocationEnabled,
    required this.isMicrophoneEnabled,
    required this.isNotificationEnabled,
    required this.isContactEnabled,
    required this.isBiometricEnabled,
    required this.isCalendarEnabled,
    required this.isStorageEnabled,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      appName: json['APP_NAME'] ?? 'Pixaware App',
      orgName: json['ORG_NAME'] ?? 'Pixaware Technologies',
      webUrl: json['WEB_URL'] ?? 'https://pixaware.co/',
      logoUrl: json['LOGO_URL'] ?? '',
      isPushEnabled: json['PUSH_NOTIFY']?.toString().toLowerCase() == 'true',
      isDeeplinkEnabled:
          json['IS_DEEPLINK']?.toString().toLowerCase() == 'true',
      isPullToRefreshEnabled:
          json['IS_PULLDOWN']?.toString().toLowerCase() == 'true',
      isLoadingIndicatorEnabled:
          json['IS_LOAD_IND']?.toString().toLowerCase() == 'true',
      isBottomMenuEnabled:
          json['IS_BOTTOMMENU']?.toString().toLowerCase() == 'true',
      bottomMenuBgColor: json['BOTTOMMENU_BG_COLOR'] ?? '#FFFFFF',
      bottomMenuIconColor: json['BOTTOMMENU_ICON_COLOR'] ?? '#888888',
      bottomMenuTextColor: json['BOTTOMMENU_TEXT_COLOR'] ?? '#000000',
      bottomMenuActiveTabColor:
          json['BOTTOMMENU_ACTIVE_TAB_COLOR'] ?? '#FF2D55',
      bottomMenuItems: List<Map<String, dynamic>>.from(
        jsonDecode(json['BOTTOMMENU_ITEMS'] ?? '[]'),
      ),
      isCameraEnabled: json['IS_CAMERA']?.toString().toLowerCase() == 'true',
      isLocationEnabled:
          json['IS_LOCATION']?.toString().toLowerCase() == 'true',
      isMicrophoneEnabled: json['IS_MIC']?.toString().toLowerCase() == 'true',
      isNotificationEnabled:
          json['IS_NOTIFICATION']?.toString().toLowerCase() == 'true',
      isContactEnabled: json['IS_CONTACT']?.toString().toLowerCase() == 'true',
      isBiometricEnabled:
          json['IS_BIOMETRIC']?.toString().toLowerCase() == 'true',
      isCalendarEnabled:
          json['IS_CALENDAR']?.toString().toLowerCase() == 'true',
      isStorageEnabled: json['IS_STORAGE']?.toString().toLowerCase() == 'true',
    );
  }

  String get versionName => '1.0.0';
  String get versionCode => '1';
  String get packageName => 'com.pixaware.app';
  String get bundleId => 'com.pixaware.app';
  String get splashUrl => 'https://pixaware.co/splash.png';
  String get splashBgColor => '#FFFFFF';
  String get splashTagline => 'Tagline';
  String get splashTaglineColor => '#000000';
  String get splashAnimation => 'default';
  String get splashDuration => '3000';

  // Feature flags
  bool get isSplashEnabled => true;
}

class ConfigService {
  static const String _configKey = 'app_config';
  static ConfigService? _instance;
  late AppConfig _config;

  ConfigService._();

  static ConfigService get instance {
    _instance ??= ConfigService._();
    return _instance!;
  }

  AppConfig get config => _config;

  Future<void> initialize(String configEndpoint) async {
    try {
      // For now, we'll use build-time configuration
      // In a real app, you might want to fetch this from an API
      _config = AppConfig(
        appName: const String.fromEnvironment('APP_NAME',
            defaultValue: 'Pixaware App'),
        orgName: const String.fromEnvironment('ORG_NAME',
            defaultValue: 'Pixaware Technologies'),
        webUrl: const String.fromEnvironment('WEB_URL',
            defaultValue: 'https://pixaware.co/'),
        logoUrl: const String.fromEnvironment('LOGO_URL', defaultValue: ''),
        isPushEnabled:
            const bool.fromEnvironment('PUSH_NOTIFY', defaultValue: true),
        isDeeplinkEnabled:
            const bool.fromEnvironment('IS_DEEPLINK', defaultValue: true),
        isPullToRefreshEnabled:
            const bool.fromEnvironment('IS_PULLDOWN', defaultValue: true),
        isLoadingIndicatorEnabled:
            const bool.fromEnvironment('IS_LOAD_IND', defaultValue: true),
        isBottomMenuEnabled:
            const bool.fromEnvironment('IS_BOTTOMMENU', defaultValue: true),
        bottomMenuBgColor: const String.fromEnvironment('BOTTOMMENU_BG_COLOR',
            defaultValue: '#FFFFFF'),
        bottomMenuIconColor: const String.fromEnvironment(
            'BOTTOMMENU_ICON_COLOR',
            defaultValue: '#888888'),
        bottomMenuTextColor: const String.fromEnvironment(
            'BOTTOMMENU_TEXT_COLOR',
            defaultValue: '#000000'),
        bottomMenuActiveTabColor: const String.fromEnvironment(
            'BOTTOMMENU_ACTIVE_TAB_COLOR',
            defaultValue: '#FF2D55'),
        bottomMenuItems: List<Map<String, dynamic>>.from(
          jsonDecode(
            const String.fromEnvironment(
              'BOTTOMMENU_ITEMS',
              defaultValue:
                  '[{"label": "Home", "icon": "home", "url": "https://pixaware.co/"}, {"label": "services", "icon": "services", "url": "https://pixaware.co/solutions/"}, {"label": "About", "icon": "info", "url": "https://pixaware.co/who-we-are/"}, {"label": "Contact", "icon": "phone", "url": "https://pixaware.co/lets-talk/"}]',
            ),
          ),
        ),
        isCameraEnabled:
            const bool.fromEnvironment('IS_CAMERA', defaultValue: false),
        isLocationEnabled:
            const bool.fromEnvironment('IS_LOCATION', defaultValue: false),
        isMicrophoneEnabled:
            const bool.fromEnvironment('IS_MIC', defaultValue: false),
        isNotificationEnabled:
            const bool.fromEnvironment('IS_NOTIFICATION', defaultValue: true),
        isContactEnabled:
            const bool.fromEnvironment('IS_CONTACT', defaultValue: false),
        isBiometricEnabled:
            const bool.fromEnvironment('IS_BIOMETRIC', defaultValue: false),
        isCalendarEnabled:
            const bool.fromEnvironment('IS_CALENDAR', defaultValue: false),
        isStorageEnabled:
            const bool.fromEnvironment('IS_STORAGE', defaultValue: true),
      );
    } catch (e) {
      debugPrint('Error initializing config: $e');
      rethrow;
    }
  }
}
