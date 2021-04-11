import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/api.dart';
import '../../models/profile.dart';
import '../../services/auth_api_provider.dart';

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
  final String? errorText;
  final ApiErrors? errors;

  const BaseLoginState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isFailure = false,
    this.errorText,
    this.errors,
  });

  BaseLoginState.loading() : this(isLoading: true);

  BaseLoginState.success() : this(isSuccess: true);

  BaseLoginState.error({String? errorText, ApiErrors? errors})
      : this(isFailure: true, errorText: errorText, errors: errors);

  @override
  List<Object?> get props => [isLoading, isSuccess, isFailure, errorText, errors];

  @override
  String toString() {
    return '${super.toString()} { isLoading: $isLoading, isSuccess: $isSuccess, isFailure: $isFailure, errorText: $errorText }';
  }
}

class SignInState extends BaseLoginState {
  SignInState() : super();

  SignInState.loading() : super.loading();

  SignInState.success() : super.success();

  SignInState.error({String? errorText, ApiErrors? errors}) : super.error(errorText: errorText, errors: errors);
}

class LoginBloc extends Bloc<LoginEvent, BaseLoginState> {
  final AuthApiProvider _authApiProvider;
  final Function(Profile profile) _onLogin;
  final Function _getLocalizations;

  LoginBloc(
    this._onLogin,
    this._authApiProvider,
    this._getLocalizations,
  )   : assert(_onLogin != null && _authApiProvider != null && _getLocalizations != null),
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
      final Profile? profile = await _authApiProvider.signIn(event.username, event.password);
      if (profile != null) {
        yield SignInState.success();
        _handleLoggedIn(profile);
      } else {
        yield SignInState.error(errorText: _getLocalizations().incorrect_username_or_password);
      }
    } catch (e) {
      yield SignInState.error(errorText: _getLocalizations().something_went_wrong);
    }
  }

  void _handleLoggedIn(Profile profile) {
    _onLogin(profile);
  }
}
