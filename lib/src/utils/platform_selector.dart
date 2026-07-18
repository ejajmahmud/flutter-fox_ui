import 'dart:io';

import 'package:flutter/foundation.dart';

/// Checks if the current platform is a mobile platform (Android or iOS).
final bool isMobile = Platform.isAndroid || Platform.isIOS;

/// Checks if the current platform is iOS.
final bool isIOS = Platform.isIOS;

/// Checks if the current platform is Android.
final bool isAndroid = Platform.isAndroid;

/// Checks if the current platform is a desktop platform.
final bool isDesktop = !isMobile;

/// Checks if the current platform is macOS.
final bool isMacOS = Platform.isMacOS;

/// Checks if the current platform is Windows.
final bool isWindows = Platform.isWindows;

/// Checks if the current platform is Linux.
final bool isLinux = Platform.isLinux;

/// Checks if the current platform is the web.
const bool isWeb = kIsWeb;

/// Checks if the current platform is a Darwin platform (macOS or iOS).
final bool isDarwin = isMacOS || isIOS;
