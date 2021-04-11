import 'package:flutter/material.dart';

enum LoaderType { onlyLoader, both }

class Loader extends StatelessWidget {
  final Widget? loader;
  final Widget child;
  final bool isLoading;
  final LoaderType type;

  const Loader({Key? key, this.loader, required this.child, required this.isLoading, this.type = LoaderType.both})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;
    final loaderWidget = loader ?? CircularSpinner();
    if (type == LoaderType.onlyLoader) return loaderWidget;
    return Stack(
      children: <Widget>[child, Positioned.fill(child: loaderWidget)],
    );
  }
}

class CircularSpinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(child: Center(child: CircularProgressIndicator()));
  }
}
