import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import '../../bloc_oracle.dart';

///internal widget
@protected
@immutable
class BlocObserverWidget extends StatelessWidget {
  ///
  const BlocObserverWidget({
    Key key,
    this.opacity = 0.5,
    this.backgroundColor = Colors.red,
    this.bottom,
    this.right,
    this.top,
    this.left,
    this.maxSymbolsLength,
  }) : super(key: key);

  ///
  final double opacity;

  ///
  final double bottom;

  ///
  final double right;

  ///
  final double top;

  ///
  final double left;

  ///
  final Color backgroundColor;

  ///
  final int maxSymbolsLength;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Opacity(
          opacity: opacity,
          child: StreamBuilder<Object>(
              stream: BlocOracleObserver.oracleStream.stream,
              builder: (context, snapshot) {
                final int endIndex =
                    maxSymbolsLength ?? snapshot.data.toString().length;
                return GestureDetector(
                  onTap: () {
                    // ignore: flutter_style_todos
                    // TODO ontap
                  },
                  child: Material(
                      color: backgroundColor,
                      child: Text(snapshot.data.toString().substring(
                          0,
                          endIndex > snapshot.data.toString().length
                              ? snapshot.data.toString().length
                              : endIndex))),
                );
              })),
      bottom: bottom,
      right: right,
      top: top,
      left: left,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) =>
      super.debugFillProperties(
        properties
          ..add(
            StringProperty(
              'description',
              'BlocObserverWidget StatelessWidget',
            ),
          ),
      );
}
