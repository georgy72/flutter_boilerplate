import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'app.dart';
import 'blocs/simple_bloc_delegate.dart';
import 'resources/resources.dart';
import 'services/persistent_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (App.isDebug) Bloc.observer = MyBlocObserver();

  Intl.defaultLocale = 'ru_RU';

  final storage = PersistentStorage();
  runApp(MyApp(storage: storage));
}
