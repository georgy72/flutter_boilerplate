import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/components/main_drawer.dart';
import 'package:flutter_boilerplate/generated/l10n.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final title = S.of(context).home_page;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: MainAppDrawer(),
      body: Center(
        child: Text(title),
      ),
    );
  }
}
