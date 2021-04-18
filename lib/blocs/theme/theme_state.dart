part of 'theme_cubit.dart';

@immutable
class ThemeState extends Equatable {
  final ThemeMode themeMode;

  ThemeState({this.themeMode = ThemeMode.light});

  @override
  List<Object> get props => [themeMode];

  @override
  String toString() {
    return '$runtimeType { themeMode: $themeMode }';
  }
}
