import 'package:flutter/material.dart';

class ActivityIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeWidth: 2,
      backgroundColor: Colors.deepPurple[50],
    );
  }
}
