part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthState {}

class Authenticated extends AuthState {
  final Profile profile;

  Authenticated(this.profile);

  @override
  List<Object> get props => [profile];
}

class Unauthenticated extends AuthState {
  final bool showWelcomeScreen;

  const Unauthenticated({this.showWelcomeScreen = true});

  @override
  List<Object> get props => [showWelcomeScreen];
}
