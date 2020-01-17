import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_yoga_fl/models/classroom_model.dart';
import 'package:my_yoga_fl/screens/asana_screen.dart';
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
      body: _ClassroomScreenContent(classroom: classroom),
    );
  }
}

class _ClassroomScreenContent extends StatelessWidget {
  static const HEIGHT_BETWEEN_WIDGETS = 25.0;

  final ClassroomModel classroom;

  const _ClassroomScreenContent({Key key, @required this.classroom}) : super(key: key);

  Widget _getClassroomImage() {
    if (classroom.coverImage == null) {
      return Container();
    }

    return Container(
      width: double.infinity,
      height: 150,
      margin: EdgeInsets.only(bottom: HEIGHT_BETWEEN_WIDGETS),
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
    );
  }

  Widget _getClassroomDescription() {
    if (classroom.description == null || classroom.description.isEmpty) {
      return Container();
    }

    return Container(
      margin: EdgeInsets.only(bottom: HEIGHT_BETWEEN_WIDGETS),
      child: Text(
        classroom.description,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 18, color: Colors.blueGrey),
      ),
    );
  }

  Widget _getStartButton() {
    return Container(
      height: 55,
      margin: EdgeInsets.only(bottom: HEIGHT_BETWEEN_WIDGETS),
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
    );
  }

  Widget _getAsanasList(BuildContext context) {
    final store = Provider.of<AsanasStore>(context);
    final asanas = store.getAsanasForClassroom(classroom);

    if (asanas.isEmpty) {
      return Container(); // TODO: Empty list
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final asana = asanas[index]; // FIXME: Out of a range

        return Column(
          children: <Widget>[
            AsanaListItem(
              title: asana.title,
              imageUrl: asana.imageUrl,
              level: asana.level,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AsanaScreen(asana);
                }));
              },
            ),
            SizedBox(height: 15),
          ],
        );
      }, childCount: asanas.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: NotificationListener<OverscrollIndicatorNotification>(
        // TODO Check this method for disabling Android like scroll glow
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowGlow();
          return true;
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                _getClassroomImage(),
                _getClassroomDescription(),
                _getStartButton(),
              ]),
            ),
            _getAsanasList(context),
          ],
        ),
      ),
    );
  }
}
