import 'dart:async';

import 'package:bloc_oracle/bloc_oracle.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Descendant of [BlocObserver] which adds objects to [oracleStream]
/// if you want implement custom [BlocObserver] and use [BlocOracle],
/// then you should extend your [BlocObserver] implementation by [BlocOracleObserver]
///
/// for example:
///   ```
///   class MyBlocObserver extends BlocOracleObserver {}
///   ```
class BlocOracleObserver extends BlocObserver {
  /// The [filteredBlocList] contains the types of bloc whose events should be added to the stream and adds to [oracleStream]
  /// if [filteredBlocList] is null or empty, this filter will not work.
  /// By default [BlocOracleObserver] observe all bloc event types,
  /// but you can set argument as false for everyone their own
  /// to avoid adding bloc events,errors,creates,closes,changes,transitions objects in [oracleStream]
  ///
  /// for example:
  /// ```
  /// void main() {
  ///   Bloc.observer = BlocOracleObserver(
  ///       //will creates BlocOracleObserver
  ///       filteredBlocList: [CounterBloc, FooBloc, BarBloc],
  ///       //with filtered CounterBloc,FooBloc,BarBloc
  ///       observeOnClose: false,
  ///       //and hide onClose
  ///       observeOnChange: false); //and OnChange object in oracleStream
  ///   runApp(App());
  /// }
  /// ```
  BlocOracleObserver({
    this.filteredBlocList,
    this.observeOnCreate = true,
    this.observeOnChange = true,
    this.observeOnClose = true,
    this.observeOnError = true,
    this.observeOnTransition = true,
    this.observeOnEvent = true,
  });

  ///list of filtered blocs
  final List<Type> filteredBlocList;

  /// should observer add to oracleStream bloc creating events
  final bool observeOnCreate;

  /// should observer add to oracleStream bloc closing events
  final bool observeOnClose;

  /// should observer add to oracleStream bloc errors
  final bool observeOnError;

  /// should observer add to oracleStream bloc event
  final bool observeOnEvent;

  /// should observer add to oracleStream bloc transitions
  final bool observeOnTransition;

  /// should observer add to oracleStream bloc changes
  final bool observeOnChange;

  ///Stream of bloc events
  static StreamController<Object> oracleStream = StreamController.broadcast();

  ///close [oracleStream]
  static void close() {
    if (!oracleStream.isClosed) {
      oracleStream.close();
    }
  }

  @mustCallSuper
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    _toOracleStream(observeOnEvent, bloc, event);
  }

  @mustCallSuper
  @override
  void onClose(Cubit cubit) {
    super.onClose(cubit);
    _toOracleStream(observeOnClose, cubit, cubit);
  }

  @mustCallSuper
  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    super.onError(cubit, error, stackTrace);
    _toOracleStream(observeOnError, cubit, error);
  }

  @mustCallSuper
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _toOracleStream(observeOnTransition, bloc, transition);
  }

  @mustCallSuper
  @override
  void onChange(Cubit cubit, Change change) {
    super.onChange(cubit, change);
    _toOracleStream(observeOnChange, cubit, change);
  }

  @mustCallSuper
  @override
  void onCreate(Cubit cubit) {
    super.onCreate(cubit);
    _toOracleStream(observeOnCreate, cubit, cubit);
  }

  void _toOracleStream(bool observe, Cubit cubit, [Object object]) {
    if (!observe) {
      return;
    }
    if (filteredBlocList?.isNotEmpty ?? false) {
      if (filteredBlocList.contains(cubit.runtimeType)) {
        oracleStream.sink.add(object);
      }
    } else {
      oracleStream.sink.add(object);
    }
  }
}
