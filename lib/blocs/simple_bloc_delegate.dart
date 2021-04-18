import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../resources/resources.dart';

class SimpleCubitObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    App.debug('onTransition: ${bloc.runtimeType}');
    try {
      App.verbose({
        'cubit': bloc.runtimeType.toString(),
        'current': json.decode(transition.currentState.toString()),
        'next': json.decode(transition.nextState.toString())
      });
    } catch (e){
      App.verbose(transition.currentState.toString());
      App.verbose(transition.nextState.toString());
    }
  }

  @override
  void onError(BlocBase cubit, Object error, StackTrace stackTrace) {
    super.onError(cubit, error, stackTrace);
    print('$error, $stackTrace');
  }
}
