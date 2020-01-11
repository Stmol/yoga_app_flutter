import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  InputDecoration _getInputDecoration() {
    return InputDecoration(
      hintText: "Поиск",
      // border: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(40),
      //   borderSide: BorderSide(width: 1, color: Colors.transparent)
      // ),
      filled: false,
      fillColor: Colors.grey[200],
      // focusColor: Colors.white,
      // hoverColor: Colors.white,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(45),
              color: Colors.grey[100],
            ),
            child: TextField(
              cursorColor: Colors.grey,
              decoration: _getInputDecoration(),
            ),
          ),
        ),
        IconButton(
          // TODO: Splash filling circle is too large
          icon: Icon(Icons.filter_list),
          onPressed: () => {},
        ),
      ],
    );
  }
}
