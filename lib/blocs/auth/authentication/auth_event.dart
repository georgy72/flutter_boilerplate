part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final Profile profile;

  LoggedIn(this.profile);

  @override
  List<Object> get props => [profile];
}

class _UpdateProfile extends AuthEvent {
  final Profile profile;

  _UpdateProfile(this.profile);

  @override
  List<Object> get props => [profile];
}

class LoggedOut extends AuthEvent {
  final bool showWelcomeScreen;

  const LoggedOut({this.showWelcomeScreen = true});

  @override
  List<Object> get props => [showWelcomeScreen];
}
