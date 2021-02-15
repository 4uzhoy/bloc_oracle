import 'package:bloc_oracle/src/bloc_oracle_observer/internal_bloc_oracle_observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../bloc_oracle_observer/bloc_oracle_observer.dart';
import 'bloc_observer_widget.dart';

/// Widget which creates a [Stack] of [child] and [Text] widget which display bloc
/// [Transition], [Error], [Event], [Change], [onClose], [onCreate]
/// on the screen
/// See also:
///
///  * [OverlayBlocOracle], which creates a [Stack], but create [OverlayEntry] with [Text] widget
@immutable
class BlocOracle extends StatefulWidget {
  /// Creates a [Stack] of [child] and [Text] widget which display bloc
  /// [Transition], [Error], [Event], [Change], [onClose], [onCreate]
  /// on the screen
  ///
  /// The [child] parameter must not be null.
  ///
  /// By default [showOnlyInDebugMode] setted as true, that allows display overlay only on debug mode
  ///
  /// The [opacity] is param of overlay visibility, opacity should be in range [0...1]
  ///
  /// The [maxSymbolsLength] allows сut string in overlay to this value, or if value>string.length,
  /// maxSymbolsLength will be setted as string.length
  const BlocOracle({
    @required this.child,
    this.opacity = 0.5,
    this.backgroundColor = Colors.red,
    this.bottom,
    this.right,
    this.top,
    this.left,
    this.maxSymbolsLength,
    Key key,
  })  : assert(
            child != null, 'Field child in widget BlocOracle must not be null'),
        super(key: key);

  ///[child] will put under [Text] widget in [Stack]
  final Widget child;

  ///overlay opacity
  final double opacity;

  ///bottom position
  final double bottom;

  ///right position
  final double right;

  ///top position
  final double top;

  ///left position
  final double left;

  ///overlay background color, by default =Colors.red
  final Color backgroundColor;

  ///maximum length of lines that the bloc oracle will display on the screen
  final int maxSymbolsLength;

  @override
  State<BlocOracle> createState() => _BlocOracleState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) =>
      super.debugFillProperties(
        properties
          ..add(
            StringProperty(
              'description',
              'BlocOracle StatefulWidget',
            ),
          ),
      );
}

class _BlocOracleState extends State<BlocOracle> {
  @override
  void initState() {
    super.initState();
    if (Bloc.observer is BlocOracleObserver) {
    } else if (Bloc.observer is BlocObserver &&
        Bloc.observer is! BlocOracleObserver) {
      throw Exception(
          'Application uses custom bloc observer implementation without extending BlocOracleObserver, to resolve it'
          'please extend your BlocObserver implementation from BlocOracleObserver, or remove BlocOracle from widget tree');
    } else if (Bloc.observer is BlocObserver) {
      Bloc.observer = BlocOracleObserverImpl();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) =>
      super.debugFillProperties(
        properties
          ..add(
            StringProperty(
              'description',
              '_BlocOracleState State<BlocOracle>',
            ),
          ),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        BlocObserverWidget(
          opacity: widget.opacity,
          left: widget.left,
          right: widget.right,
          top: widget.top,
          bottom: widget.bottom,
          backgroundColor: widget.backgroundColor,
          maxSymbolsLength: widget.maxSymbolsLength,
        )
      ],
    );
  }
}
