import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/blocs/auth/authentication_bloc.dart';
import 'package:flutter_boilerplate/blocs/auth/login_bloc.dart';
import 'package:flutter_boilerplate/components/loader.dart';
import 'package:flutter_boilerplate/models/profile.dart';
import 'package:flutter_boilerplate/services/api_provider.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;
  TextEditingController _usernameController;
  TextEditingController _passwordController;
  String _appVersion;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(_handleLoggedIn, RepositoryProvider.of<ApiProvider>(context).auth);
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _loginBloc.close();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, BaseLoginState>(
      cubit: _loginBloc,
      builder: (BuildContext context, BaseLoginState state) {
        return Scaffold(
          body: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              constraints: BoxConstraints(maxWidth: 400.0),
              child: Column(
                children: <Widget>[
                  Card(
                    child: Loader(
                      isLoading: state.isLoading,
                      child: LoginForm(
                        usernameController: _usernameController,
                        passwordController: _passwordController,
                        onLogin: _handleLoginTap,
                      ),
                    ),
                  ),
                  if (_loginBloc.state.errorText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        '${_loginBloc.state.errorText}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).buttonTheme.colorScheme.error,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  Container(height: 32),
                  if (_appVersion != null) Text('Версия $_appVersion'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleLoggedIn(Profile profile) {
    BlocProvider.of<AuthBloc>(context).add(LoggedIn(profile));
  }

  void _handleLoginTap() {
    final username = _usernameController.text;
    final password = _passwordController.text;
    _loginBloc.add(LoginWithCredentials(username, password));
  }
}

class LoginForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final Function() onLogin;

  const LoginForm({Key key, this.onLogin, this.usernameController, this.passwordController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Вход', style: Theme.of(context).textTheme.headline4),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: usernameController,
              decoration: InputDecoration(hintText: 'Логин'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onEditingComplete: onLogin,
              controller: passwordController,
              obscureText: true,
              autocorrect: false,
              decoration: InputDecoration(hintText: 'Пароль'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              color: Theme.of(context).buttonTheme.colorScheme.primary,
              onPressed: onLogin,
              textColor: Colors.white,
              child: Text('Войти'),
            ),
          ),
        ],
      ),
    );
  }
}
