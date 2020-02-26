import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocalNotification {
  static const DEFAULT_DISPLAY_DURATION = Duration(milliseconds: 2000);

  static void success(
    BuildContext context, {
    @required String message,
    bool inPostCallback = false,
    Duration duration = DEFAULT_DISPLAY_DURATION,
  }) {
    final flushbar = Flushbar(
      message: message,
      icon: Icon(Icons.done, color: Colors.lightGreenAccent),
      shouldIconPulse: false,
      margin: EdgeInsets.all(8),
      borderRadius: 8.0,
      duration: duration,
      animationDuration: Duration(milliseconds: 350),
      flushbarPosition: FlushbarPosition.TOP,
      barBlur: 1,
      backgroundColor: Color(0xCC000000),
    );

    if (inPostCallback == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) => flushbar.show(context));
    } else {
      flushbar.show(context);
    }
  }

  static void error(
    BuildContext context, {
    String message = 'Произошла ошибка',
    bool inPostCallback = false,
    Duration duration = DEFAULT_DISPLAY_DURATION,
  }) {
    final flushbar = Flushbar(
      message: message,
      icon: Icon(Icons.error_outline, color: Colors.red),
      shouldIconPulse: false,
      margin: EdgeInsets.all(8),
      borderRadius: 8.0,
      duration: duration,
      animationDuration: Duration(milliseconds: 350),
      flushbarPosition: FlushbarPosition.TOP,
      barBlur: 1,
      backgroundColor: Color(0xCC000000),
    );

    if (inPostCallback == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) => flushbar.show(context));
    } else {
      flushbar.show(context);
    }
  }
}
