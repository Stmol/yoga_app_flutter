import 'package:flutter/material.dart';

import '../main.dart';

class Button extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String title;

  const Button({Key key, this.onPressed, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(title, style: Theme.of(context).textTheme.button),
      ),
      fillColor: kBrandColorButtonBG,
      splashColor: Colors.transparent,
      // splashColor: BrandColorButtonBG,
      elevation: 0.0,
      highlightElevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
        //side: BorderSide(color: Colors.grey[400], width: 2),
      ),
      onPressed: onPressed,
    );
  }
}
