import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'blocs/auth/authentication_bloc.dart';
import 'components/loader.dart';
import 'generated/l10n.dart';
import 'pages/home_page/home_page.dart';
import 'pages/login_page/login_page.dart';
import 'resources/resources.dart';
import 'routes.dart';
import 'services/api_provider.dart';
import 'services/persistent_storage.dart';
import 'theme.dart';
import 'utils/requests/auth_middleware.dart';
import 'utils/requests/log_middleware.dart';
import 'utils/requests/middleware.dart';

class MyApp extends StatefulWidget {
  final PersistentStorage storage;

  const MyApp({Key? key, required this.storage}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get _navigator => _navigatorKey.currentState;
  AuthBloc? authBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    authBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storage = widget.storage;
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PersistentStorage>.value(value: storage),
        RepositoryProvider<ApiProvider>(
          create: (BuildContext context) {
            final client = MiddlewareClient.build(
              ApiProvider.createDefaultClient(),
              [
                AuthMiddleware(storage, onUnauthorized: _handleUnauthorized),
                if (App.isDebug && !kIsWeb) LogMiddleware()
              ],
            );
            return ApiProvider(client: client);
          },
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: _createAuthBloc),
        ],
        child: MaterialApp(
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          navigatorKey: _navigatorKey,
          theme: theme,
          builder: (context, child) {
            return BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is Authenticated)
                  _navigator!
                      .pushAndRemoveUntil<void>(MaterialPageRoute<void>(builder: (_) => HomePage()), (route) => false);
                if (state is Unauthenticated)
                  _navigator!
                      .pushAndRemoveUntil<void>(MaterialPageRoute<void>(builder: (_) => LoginPage()), (route) => false);
                if (state is Uninitialized)
                  _navigator!.pushAndRemoveUntil<void>(
                      MaterialPageRoute<void>(builder: (_) => CircularSpinner()), (route) => false);
              },
              child: child,
            );
          },
          onGenerateRoute: generateRoute,
        ),
      ),
    );
  }

  AuthBloc _createAuthBloc(BuildContext context) {
    final storage = RepositoryProvider.of<PersistentStorage>(context);
    final apiProvider = RepositoryProvider.of<ApiProvider>(context);
    authBloc = AuthBloc(storage, apiProvider.auth)..add(AppStarted());
    return authBloc!;
  }

  void _handleUnauthorized() {
    if (authBloc == null) return;
    authBloc?.add(LoggedOut());
  }
}
