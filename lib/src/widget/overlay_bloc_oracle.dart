import 'package:bloc_oracle/src/bloc_oracle_observer/internal_bloc_oracle_observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../bloc_oracle_observer/bloc_oracle_observer.dart';
import 'bloc_observer_widget.dart';

/// Widget which allows insert [OverlayEntry], and display bloc
/// [Transition], [Error], [Event], [Change], [onClose], [onCreate]
/// on the screen in this overlay
/// See also:
///
///  * [BlocOracle], which don't insert overlay, but put child in stack with [Text] widget on top position.

@immutable
class OverlayBlocOracle extends StatefulWidget {
  /// Creates a overlay widget which display bloc
  /// [Transition], [Error], [Event], [Change], [onClose], [onCreate]
  /// on the screen
  ///
  /// The [child] parameter must not be null.
  ///
  /// If the [bottom], [right], [top], [left] arguments is null, overlay will expand on full size of screen,
  /// that's means you should set at least one argument, for example:
  ///
  /// ```
  ///  OverlayBlocOracle(
  ///  bottom:0.0,
  ///  right:0.0,)
  /// ```
  ///
  /// By default [showOnlyInDebugMode] setted as true, that allows display overlay only on debug mode
  ///
  /// The [opacity] is param of overlay visibility, opacity should be in range [0...1]
  ///
  /// The [maxSymbolsLength] allows сut string in overlay to this value, or if value>string.length,
  /// maxSymbolsLength will be setted as string.length
  ///
  const OverlayBlocOracle({
    @required this.child,
    this.bottom,
    this.right,
    this.top,
    this.left,
    this.showOnlyInDebugMode = true,
    this.opacity = 0.5,
    this.maxSymbolsLength,
    this.backgroundColor = Colors.green,
    Key key,
  })  : assert(
            child != null, 'Field child in widget BlocOracle must not be null'),
        super(key: key);

  ///root widget under MaterialApp
  final Widget child;

  ///overlay opacity, by default = 0.5
  final double opacity;

  ///bottom position
  final double bottom;

  ///right position
  final double right;

  ///top position
  final double top;

  ///left position
  final double left;

  ///overlay background color, by default =Colors.green
  final Color backgroundColor;

  ///maximum length of lines that the bloc oracle will display on the screen
  final int maxSymbolsLength;

  ///should display in debug mode
  final bool showOnlyInDebugMode;

  @override
  State<OverlayBlocOracle> createState() => _OverlayBlocOracleState();

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

class _OverlayBlocOracleState extends State<OverlayBlocOracle> {
  bool displayOracle = true;

  @override
  void initState() {
    super.initState();
    if (Bloc.observer is BlocOracleObserver) {
    } else if (Bloc.observer is BlocObserver &&
        Bloc.observer is! BlocOracleObserver) {
      throw Exception(
          'Application uses custom bloc observer implementation without extending BlocOracleObserver, to resolve it'
          'please extend your BlocObserver implementation from BlocOracleObserver, or remove OverlayBlocOracle from widget tree');
    } else if (Bloc.observer is BlocObserver) {
      Bloc.observer = BlocOracleObserverImpl();
    }

    if (widget.showOnlyInDebugMode) {
      if (kReleaseMode) {
        displayOracle = false;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (displayOracle) {
          WidgetsBinding.instance.addPostFrameCallback((_) =>
              Overlay.of(context).insert(OverlayEntry(builder: (context) {
                return BlocObserverWidget(
                  opacity: widget.opacity,
                  left: widget.left,
                  right: widget.right,
                  top: widget.top,
                  bottom: widget.bottom,
                  backgroundColor: widget.backgroundColor,
                  maxSymbolsLength: widget.maxSymbolsLength,
                );
              })));
        }
        return widget.child;
      },
    );
  }
}
