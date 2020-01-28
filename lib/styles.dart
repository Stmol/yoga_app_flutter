import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_yoga_fl/extensions/color_extensions.dart';

abstract class Styles {
  static Color accentGreyColor = Colors.grey.shade700;
  static Color shadedGreyColor = Colors.grey.shade300;

  static const Color controlsIconColor = Color(0xFF3C3C59);
  static const Color controlsLightGreyColor = Color(0xFFF1F1F4);

  static const Color timerPauseColor = Color(0xFF405DC3);
  static const Color timerActiveColor = Color(0xFFA52A22);

  static const Color primaryBrandColor = Color.fromRGBO(107, 117, 255, 1);

  // PLAIN BUTTON COLOURS
  static const Color plainButtonColor = Color(0xFFE7E9FF);
  static Color plainButtonHighlightColor = const Color(0xFFE7E9FF).darken(0.1);

  // DANGER BUTTON COLOURS
  static const Color dangerButtonTextColor = Color(0xFFFF695B);
  static const Color dangerButtonColor = Color(0xFFFFE7E5);
  static Color dangerButtonHighlightColor = Color(0xFFFFE7E5).darken(0.1);

  // WARNING BUTTON COLOURS
  static const Color warningButtonTextColor = Color(0xFFFFBE4F);
  static const Color warningButtonColor = Color(0xFFFFF0D5);
  static Color warningButtonHighlightColor = Color(0xFFFFF5E3).darken(0.1);

  // SUCCESS BUTTON COLOURS
  static const Color successButtonTextColor = Color(0xFF3DCC79);
  static const Color successButtonColor = Color(0xFFE0F7EA);
  static Color successButtonHighlightColor = Color(0xFFE0F7EA).darken(0.1);

  static const classroomInfoText = TextStyle(
    color: Colors.grey,
    fontSize: 14,
  );
}
