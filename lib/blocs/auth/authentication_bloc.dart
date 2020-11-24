import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/profile.dart';
import '../../services/auth_api_provider.dart';
import '../../services/persistent_storage.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final Profile profile;

  LoggedIn(this.profile) : assert(profile != null);

  @override
  List<Object> get props => [profile];
}

class _UpdateProfile extends AuthEvent {
  final Profile profile;

  _UpdateProfile(this.profile) : assert(profile != null);

  @override
  List<Object> get props => [profile];
}

class LoggedOut extends AuthEvent {
  final bool showWelcomeScreen;

  const LoggedOut({this.showWelcomeScreen = true}) : assert(showWelcomeScreen != null);

  @override
  List<Object> get props => [showWelcomeScreen];
}

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

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final PersistentStorage storage;
  final AuthApiProvider _authApiProvider;

  AuthBloc(this.storage, this._authApiProvider)
      : assert(storage != null),
        assert(_authApiProvider != null),
        super(Uninitialized());

  Profile get profile => (state as Authenticated)?.profile;

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
}
