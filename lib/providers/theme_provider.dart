import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ThemeMode { system, light, dark }

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.dark);

  final lightTheme = const CupertinoThemeData(
    brightness: Brightness.light,
  );
  final darkTheme = const CupertinoThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: CupertinoColors.black,
    barBackgroundColor: CupertinoColors.black,
  );

  switchTheme() {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
    } else if (state == ThemeMode.dark) {
      state = ThemeMode.system;
    } else {
      state = ThemeMode.light;
    }
  }

  CupertinoThemeData getThemeData() {
    if (state == ThemeMode.system) {
      if (SchedulerBinding.instance!.window.platformBrightness ==
          Brightness.light) {
        return lightTheme;
      } else {
        return darkTheme;
      }
    } else if (state == ThemeMode.light) {
      return lightTheme;
    } else {
      return darkTheme;
    }
  }
}

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((_) => ThemeNotifier());
