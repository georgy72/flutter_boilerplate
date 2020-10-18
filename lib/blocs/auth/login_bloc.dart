import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/models/api.dart';
import 'package:flutter_boilerplate/models/profile.dart';
import 'package:flutter_boilerplate/services/auth_api_provider.dart';

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

abstract class BaseLoginState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;
  final String errorText;
  final ApiErrors errors;

  const BaseLoginState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isFailure = false,
    this.errorText,
    this.errors,
  });

  BaseLoginState.loading() : this(isLoading: true);

  BaseLoginState.success() : this(isSuccess: true);

  BaseLoginState.error({String errorText, ApiErrors errors})
      : this(isFailure: true, errorText: errorText, errors: errors);

  @override
  List<Object> get props => [isLoading, isSuccess, isFailure, errorText, errors];

  @override
  String toString() {
    return '${super.toString()} { isLoading: $isLoading, isSuccess: $isSuccess, isFailure: $isFailure, errorText: $errorText }';
  }
}

class SignInState extends BaseLoginState {
  SignInState() : super();

  SignInState.loading() : super.loading();

  SignInState.success() : super.success();

  SignInState.error({String errorText, ApiErrors errors}) : super.error(errorText: errorText, errors: errors);
}

class LoginBloc extends Bloc<LoginEvent, BaseLoginState> {
  final AuthApiProvider _authApiProvider;
  final Function(Profile profile) _onLogin;

  LoginBloc(this._onLogin, this._authApiProvider)
      : assert(_onLogin != null, _authApiProvider != null),
        super(SignInState());

  @override
  Stream<BaseLoginState> mapEventToState(LoginEvent event) async* {
    if (state.isLoading) return;

    if (event is LoginWithCredentials) {
      yield* _mapLoginWithCredentialsToState(event);
    }
  }

  Stream<BaseLoginState> _mapLoginWithCredentialsToState(LoginWithCredentials event) async* {
    try {
      yield SignInState.loading();
      final profile = await _authApiProvider.signIn(event.username, event.password);
      if (profile != null) {
        yield SignInState.success();
        _handleLoggedIn(profile);
      } else {
        yield SignInState.error(errorText: 'Неверный логин или пароль.');
      }
    } catch (e) {
      yield SignInState.error(errorText: 'Что-то пошло не так.');
    }
  }

  void _handleLoggedIn(Profile profile) {
    _onLogin(profile);
  }
}