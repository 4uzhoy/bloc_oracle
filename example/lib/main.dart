import 'dart:async';
import 'package:bloc_oracle/bloc_oracle.dart';
import 'package:example/second_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Custom [BlocOracleObserver] which observes all bloc and cubit instances.
/// and add objects to broadcast stream [BlocOracleObserver.oracleStream]
class MyBlocObserver extends BlocOracleObserver {
  ///Pass the parameters you want to the super constructor
  MyBlocObserver()
      : super(filteredBlocList: [CounterBloc], observeOnChange: false);

  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    // do there what you need
  }

  @override
  void onCreate(Cubit cubit) {
    super.onCreate(cubit);
    // do there what you need
  }

  @override
  void onChange(Cubit cubit, Change change) {
    super.onChange(cubit, change);
    // do there what you need
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    // do there what you need
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    super.onError(cubit, error, stackTrace);
    // do there what you need
  }

  @override
  void onClose(Cubit cubit) {
    super.onClose(cubit);
    // do there what you need
  }
}

void main() {
  // you can set Bloc.observer as BlocOracleObserver with specific options
  Bloc.observer = BlocOracleObserver(
      //will creates BlocOracleObserver
      filteredBlocList: [CounterBloc],
      //with filtered CounterBloc,FooBloc,BarBloc
      observeOnClose: false,
      //and hide onClose
      observeOnChange: false); //and OnChange object in oracleStream

  // or use Custom bloc observer which extended from BlocOracleObserver
  Bloc.observer = MyBlocObserver();
  runApp(App());
}

/// A [StatelessWidget] which uses:
/// * [bloc](https://pub.dev/packages/bloc)
/// * [flutter_bloc](https://pub.dev/packages/flutter_bloc)
/// to manage the state of a counter.
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (_, theme) {
          return MaterialApp(
            theme: theme,
            home: BlocProvider(
              create: (_) => CounterBloc(),
              // OverlayBlocOracle using
              child: OverlayBlocOracle(
                  bottom: 0.0,
                  maxSymbolsLength: 100,
                  // BlocOracle using
                  child: BlocOracle(child: CounterPage())),
            ),
          );
        },
      ),
    );
  }
}

/// A [StatelessWidget] which demonstrates
/// how to consume and interact with a [CounterBloc].
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: BlocBuilder<CounterBloc, int>(
        builder: (_, count) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$count', style: Theme.of(context).textTheme.headline1),
                RaisedButton(
                    color: Theme.of(context).buttonTheme.colorScheme.background,
                    child: Text('to second page',
                        style: Theme.of(context).textTheme.button),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                              value: BlocProvider.of<CounterBloc>(context),
                              child: const SecondPage())));
                    }),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: RaisedButton(
                        child: const Icon(Icons.add),
                        onPressed: () => context
                            .read<CounterBloc>()
                            .add(CounterEvent.increment),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: RaisedButton(
                        child: const Icon(Icons.remove),
                        onPressed: () => context
                            .read<CounterBloc>()
                            .add(CounterEvent.decrement),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: RaisedButton(
                        child: const Icon(Icons.brightness_6),
                        onPressed: () =>
                            context.read<ThemeCubit>().toggleTheme(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: RaisedButton(
                        child: const Icon(Icons.error),
                        onPressed: () => context.read<CounterBloc>().add(null),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Event being processed by [CounterBloc].
enum CounterEvent {
  /// Notifies bloc to increment state.
  increment,

  /// Notifies bloc to decrement state.
  decrement
}

/// {@template counter_bloc}
/// A simple [Bloc] which manages an `int` as its state.
/// {@endtemplate}
class CounterBloc extends Bloc<CounterEvent, int> {
  /// {@macro counter_bloc}
  CounterBloc() : super(0) {
    print('CREATED CounterBloc ');
  }

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    switch (event) {
      case CounterEvent.decrement:
        yield state - 1;
        break;
      case CounterEvent.increment:
        yield state + 1;
        break;
      default:
        addError(Exception('unsupported event'));
    }
  }
}

/// {@template brightness_cubit}
/// A simple [Cubit] which manages the [ThemeData] as its state.
/// {@endtemplate}
class ThemeCubit extends Cubit<ThemeData> {
  /// {@macro brightness_cubit}
  ThemeCubit() : super(_lightTheme);

  static final _lightTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
    ),
    brightness: Brightness.light,
  );

  static final _darkTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.black,
    ),
    brightness: Brightness.dark,
  );

  /// Toggles the current brightness between light and dark.
  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
  }
}
