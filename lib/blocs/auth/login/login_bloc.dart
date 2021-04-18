import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/api.dart';
import '../../../models/profile.dart';
import '../../../services/auth_api_provider.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, BaseLoginState> {
  final AuthApiProvider _authApiProvider;
  final Function(Profile profile) _onLogin;
  final Function _getLocalizations;

  LoginBloc(this._onLogin, this._authApiProvider, this._getLocalizations) : super(SignInState());

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
