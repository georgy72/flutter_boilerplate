import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/components/main_drawer.dart';
import 'package:flutter_boilerplate/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
      ),
      drawer: MainAppDrawer(),
      body: Center(
        child: Text('Home page'),
      ),
    );
  }

  Function _getHandleNavigateTo(BuildContext context, String routeName) {
    return () async {
      Navigator.pushNamed(context, routeName);
    };
  }
}