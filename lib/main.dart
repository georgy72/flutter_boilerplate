import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'blocs/simple_bloc_delegate.dart';
import 'resources/resources.dart';
import 'services/persistent_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : await getApplicationDocumentsDirectory(),
  );

  if (App.isDebug) Bloc.observer = SimpleCubitObserver();

  Intl.defaultLocale = 'ru_RU';

  final storage = PersistentStorage();
  runApp(MyApp(storage: storage));
}
