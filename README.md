# Bloc Oracle

<p align="center">
![](https://github.com/4uzhoy/bloc_oracle/blob/master/.img/logo.png)
</p>

## About
A package which allows display the observed result's of Bloc observer on the screen

### Widgets
 * BlocOracle 
 * OverlayBlocOracle

## Example usage:
<p align="center">
![](https://github.com/4uzhoy/bloc_oracle/blob/master/.img/screen.png)
</p>
Set bloc observer

### main.dart

```dart
void main() {
  // you can set Bloc.observer as BlocOracleObserver with specific options
  Bloc.observer = BlocOracleObserver(
      //will creates BlocOracleObserver
      filteredBlocList: [CounterBloc,FooBloc,BarBloc],
      //with filtered CounterBloc,FooBloc,BarBloc
      observeOnClose: false,
      //hide onClose
      observeOnChange: false); //and OnChange object in oracleStream

  // or use Custom bloc observer which extended from BlocOracleObserver
  Bloc.observer = MyBlocObserver();
  runApp(App());
}
```

Then use OverlayBlocOracle to add Overlay and display observed results or just use BlocOracle
to wrap only one page without overlay insert
 
see full [example](https://github.com/4uzhoy/bloc_oracle/blob/master/example/lib/main.dart)

```dart
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
```


## Changelog  
  
Refer to the [Changelog](https://github.com/4uzhoy/bloc_oracle/blob/main/CHANGELOG.md) to get all release notes.  
  
  
## Features and bugs  
  
Please file feature requests and bugs at the [issue tracker][tracker].
  
[tracker]: https://github.com/4uzhoy/bloc_oracle/issues
  
  
## License  
  
[MIT](https://github.com/4uzhoy/bloc_oracle/blob/main/LICENSE)  