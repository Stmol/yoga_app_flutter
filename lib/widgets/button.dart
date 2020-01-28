import 'package:flutter/material.dart';
import 'package:my_yoga_fl/styles.dart';

enum ButtonStyle {
  plain,
  success,
  danger,
  warning,
}

class Button extends StatelessWidget {
  final GestureTapCallback onTap;
  final String title;
  final ButtonStyle buttonStyle;

  const Button(
    this.title, {
    Key key,
    this.onTap,
    ButtonStyle style = ButtonStyle.plain,
  })  : assert(title != null),
        buttonStyle = style,
        super(key: key);

  Color get fillColor {
    switch(buttonStyle) {
      case ButtonStyle.plain:
        return Styles.plainButtonColor;
      case ButtonStyle.success:
        return Styles.successButtonColor;
      case ButtonStyle.danger:
        return Styles.dangerButtonColor;
      case ButtonStyle.warning:
        return Styles.warningButtonColor;
    }

    return Styles.plainButtonColor;
  }

  Color get highlightColor {
    switch(buttonStyle) {
      case ButtonStyle.plain:
        return Styles.plainButtonHighlightColor;
      case ButtonStyle.success:
        return Styles.successButtonHighlightColor;
      case ButtonStyle.danger:
        return Styles.dangerButtonHighlightColor;
      case ButtonStyle.warning:
        return Styles.warningButtonHighlightColor;
    }

    return Styles.plainButtonHighlightColor;
  }

  Color get textColor {
    switch(buttonStyle) {
      case ButtonStyle.plain:
        return Styles.primaryBrandColor;
      case ButtonStyle.success:
        return Styles.successButtonTextColor;
      case ButtonStyle.danger:
        return Styles.dangerButtonTextColor;
      case ButtonStyle.warning:
        return Styles.warningButtonTextColor;
    }

    return Styles.primaryBrandColor;
  }

  bool get isEnabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.button.copyWith(color: textColor);

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.4,
      child: RawMaterialButton(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(title, style: textStyle),
        ),
        fillColor: fillColor,
        splashColor: Colors.transparent,
        highlightColor: highlightColor,
        highlightElevation: 0.0,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        onPressed: onTap,
      ),
    );
  }
}
