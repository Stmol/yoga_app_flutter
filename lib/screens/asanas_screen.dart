import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_yoga_fl/screens/asana_screen.dart';
import 'package:my_yoga_fl/widgets/asanas_list.dart';
import '../models/asana_model.dart';

class AsanasScreen extends StatelessWidget {
  static const routeName = '/asanas';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.grey,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Асаны и позы",
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: _AsanasScreen(),
    );
  }
}

class _AsanasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 18),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SearchAsanasForm(),
          SizedBox(height: 15),
          AsanasList(asanas: asanas),
        ],
      ),
    );
  }
}

class SearchAsanasForm extends StatelessWidget {
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
          icon: Icon(Icons.filter_list),
          onPressed: () => {},
        ),
      ],
    );
  }
}
