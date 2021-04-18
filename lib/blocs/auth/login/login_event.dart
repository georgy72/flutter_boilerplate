part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginWithCredentials extends LoginEvent {
  final String username;
  final String password;

  const LoginWithCredentials(this.username, this.password);

  @override
  List<Object> get props => [username, password];

  @override
  String toString() {
    return '${super.toString()} { username: $username, password: $password }';
  }
}
