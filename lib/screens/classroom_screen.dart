import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_yoga_fl/models/classroom_model.dart';
import 'package:my_yoga_fl/stores/asanas_store.dart';
import 'package:my_yoga_fl/widgets/asanas_list.dart';
import 'package:provider/provider.dart';

class ClassroomScreen extends StatelessWidget {
  final ClassroomModel classroom;

  const ClassroomScreen({Key key, @required this.classroom}) : super(key: key);

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
          classroom.title,
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: _ClassroomScreen(classroom: classroom),
    );
  }
}

class _ClassroomScreen extends StatelessWidget {
  final ClassroomModel classroom;

  const _ClassroomScreen({Key key, @required this.classroom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey[100],
                  Colors.grey[200],
                ],
              ),
            ),
            child: Icon(Icons.image, color: Colors.grey[600], size: 32),
          ),
          SizedBox(height: 20),
          (classroom.description != null && classroom.description.isNotEmpty)
              ? Column(
                  children: <Widget>[
                    Text(
                      classroom.description,
                      style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                    ),
                    SizedBox(height: 25),
                  ],
                )
              : SizedBox(), // FIXME: Create empty widget instead SizedBox()
          Container(
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.yellow[300], // TODO: Add glow effect
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.play_arrow),
                SizedBox(width: 5),
                Text(
                  "Начать",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 25),
          Consumer<AsanasStore>(builder: (_, store, __) {
            final asanas = store.getAsanasForClassroom(classroom);
            return AsanasList(asanas: asanas);
          }),
        ],
      ),
    );
  }
}
