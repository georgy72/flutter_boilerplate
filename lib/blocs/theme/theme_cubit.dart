import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(ThemeState(themeMode: ThemeMode.system));

  setThemeMode(ThemeMode themeMode) async {
    emit(ThemeState(themeMode: themeMode));
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    try {
      final ThemeMode themeMode = EnumToString.fromString(ThemeMode.values, json['theme_mode'])!;
      return ThemeState(themeMode: themeMode);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return <String, dynamic>{'theme_mode': EnumToString.convertToString(state.themeMode)};
  }
}
