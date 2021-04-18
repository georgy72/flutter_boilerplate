import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../models/profile.dart';
import '../../../services/auth_api_provider.dart';
import '../../../services/persistent_storage.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final PersistentStorage storage;
  final AuthApiProvider _authApiProvider;

  AuthBloc(this.storage, this._authApiProvider) : super(Uninitialized());

  Profile get profile => (state as Authenticated).profile;

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield Authenticated(event.profile);
    } else if (event is LoggedOut) {
      _handleLogout();
      yield Unauthenticated(showWelcomeScreen: event.showWelcomeScreen);
    } else if (event is _UpdateProfile) {
      yield Authenticated(event.profile);
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    try {
      final profile = await _authApiProvider.fetchProfile();
      if (profile != null) {
        yield Authenticated(profile);
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Future<void> _handleLogout() async {
    if (state is! Authenticated) return;
    await storage.clearAuthToken();
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try {
      return Authenticated(json['profile']);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    if (state is Authenticated) return <String, dynamic>{'profile': state.profile};
    return null;
  }
}
