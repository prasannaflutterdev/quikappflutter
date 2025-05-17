import 'package:flutter/material.dart';

// Feature flags
const bool pushNotify = bool.fromEnvironment(
  'PUSH_NOTIFY',
  defaultValue: false,
);
const bool isDeeplink = bool.fromEnvironment(
  'IS_DEEPLINK',
  defaultValue: false,
);
const bool isPullDown = bool.fromEnvironment(
  'IS_PULLDOWN',
  defaultValue: false,
);
const bool isBottomMenu = bool.fromEnvironment(
  'IS_BOTTOMMENU',
  defaultValue: false,
);
const bool isLoadInd = bool.fromEnvironment('IS_LOAD_IND', defaultValue: false);

// Permissions
const bool isCameraEnabled = bool.fromEnvironment(
  'IS_CAMERA',
  defaultValue: false,
);
const bool isLocationEnabled = bool.fromEnvironment(
  'IS_LOCATION',
  defaultValue: false,
);
const bool isMicEnabled = bool.fromEnvironment('IS_MIC', defaultValue: false);
const bool isNotificationEnabled = bool.fromEnvironment(
  'IS_NOTIFICATION',
  defaultValue: false,
);
const bool isContactEnabled = bool.fromEnvironment(
  'IS_CONTACT',
  defaultValue: false,
);
const bool isBiometricEnabled = bool.fromEnvironment(
  'IS_BIOMETRIC',
  defaultValue: false,
);
const bool isCalendarEnabled = bool.fromEnvironment(
  'IS_CALENDAR',
  defaultValue: false,
);
const bool isStorageEnabled = bool.fromEnvironment(
  'IS_STORAGE',
  defaultValue: false,
);

// Splash screen configuration
const String splashUrl = String.fromEnvironment('SPLASH');
const String splashBgUrl = String.fromEnvironment('SPLASH_BG');
const String splashTagline = String.fromEnvironment('SPLASH_TAGLINE');
const String splashAnimation = String.fromEnvironment(
  'SPLASH_ANIMATION',
  defaultValue: 'zoom',
);
const String splashBgColor = String.fromEnvironment(
  'SPLASH_BG_COLOR',
  defaultValue: "#ffffff",
);
const String splashTaglineColor = String.fromEnvironment(
  'SPLASH_TAGLINE_COLOR',
  defaultValue: "#000000",
);
