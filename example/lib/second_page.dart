import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'main.dart';

///Second Page
@immutable
class SecondPage extends StatelessWidget {
  ///
  const SecondPage({
    Key key,
  }) : super(key: key);

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
                  child: const Icon(Icons.add),
                  onPressed: () =>
                      context.read<CounterBloc>().add(CounterEvent.increment),
                ),
                RaisedButton(
                  color: Theme.of(context).buttonTheme.colorScheme.background,
                  child: const Icon(Icons.remove),
                  onPressed: () =>
                      context.read<CounterBloc>().add(CounterEvent.decrement),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
