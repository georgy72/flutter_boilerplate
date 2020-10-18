import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/blocs/auth/authentication_bloc.dart';
import 'package:flutter_boilerplate/generated/l10n.dart';

import '../app.dart';
import '../routes.dart';

class MainAppDrawer extends StatefulWidget {
  final bool permanentlyDisplay;

  const MainAppDrawer({this.permanentlyDisplay = false, Key key}) : super(key: key);

  @override
  _MainAppDrawerState createState() => _MainAppDrawerState();
}

class _MainAppDrawerState extends State<MainAppDrawer> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (AuthState previous, AuthState current) => current is Authenticated,
      listener: (BuildContext context, AuthState state) {},
      builder: (BuildContext context, AuthState state) {
        String selectedRoute = ModalRoute.of(context).settings.name;
        return AppDrawer(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(state is Authenticated ? state.profile.fullName ?? '' : ''),
            ),
            Divider(color: Colors.grey, endIndent: 16, indent: 0, thickness: 0.8),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(S.of(context).home_page),
              onTap: _getHandleNavigateTo(Routes.root),
              selected: selectedRoute == Routes.root,
            ),
            ListTile(
              leading: Icon(Icons.wash_outlined),
              title: Text(S.of(context).first_page),
              onTap: _getHandleNavigateTo(Routes.firstPage),
              selected: selectedRoute == Routes.firstPage,
            ),
            ListTile(
              leading: Icon(Icons.wash_rounded),
              title: Text(S.of(context).second_page),
              onTap: _getHandleNavigateTo(Routes.secondPage),
              selected: selectedRoute == Routes.secondPage,
            ),
            Container(
              width: 2,
              color: Colors.black,
            ),
            if (widget.permanentlyDisplay)
              const VerticalDivider(
                width: 1,
                color: Colors.black,
              )
          ],
        );
      },
    );
  }

  Function _getHandleNavigateTo(String routeName) {
    return () async {
      Navigator.pushNamed(context, routeName);
    };
  }
}

class AppDrawer extends StatelessWidget {
  final List<Widget> children;

  const AppDrawer({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: children,
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(S.of(context).sign_out),
            onTap: () => _handleLogoutTap(context),
          ),
        ],
      ),
    );
  }

  void _handleLogoutTap(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(LoggedOut());
  }
}
