import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobx/mobx.dart';
import 'package:my_yoga_fl/assets.dart';
import 'package:my_yoga_fl/i18n/plural.dart';
import 'package:my_yoga_fl/models/classroom_model.dart';
import 'package:my_yoga_fl/screens/classroom_screen.dart';
import 'package:my_yoga_fl/screens/new_classroom/new_classroom_screen.dart';
import 'package:my_yoga_fl/stores/classrooms_store.dart';
import 'package:my_yoga_fl/stores/new_classroom_store.dart';
import 'package:my_yoga_fl/styles.dart';
import 'package:my_yoga_fl/utils/local_notification.dart';
import 'package:my_yoga_fl/utils/log.dart';
import 'package:my_yoga_fl/widgets/button.dart';
import 'package:provider/provider.dart';

const List<String> emojiForClassroom = [
  '🙏',
  '😌',
  '😬',
  '😮',
  '💪',
  '✌️',
  '👀',
  '🐰',
  '🐼',
  '🐵',
];

class ClassroomsScreen extends StatelessWidget {
  static const routeName = '/classes';

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
        brightness: Brightness.light,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.grey,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Classes',
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: _ClassroomsScreenContent(),
    );
  }
}

class _ClassroomsScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          _PredefinedClassesList(),
          SizedBox(height: 15),
          _ActiveClassesList(),
        ],
      ),
    );
  }
}

class _PredefinedClassesList extends StatelessWidget {
  Widget _getListItem(String title, Color bgColor, String imageAsset) {
    return Container(
      height: 150,
      width: 120,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(imageAsset),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: GoogleFonts.pTSansCaption(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16, // TODO: Words wrapping by letter
              shadows: [
                Shadow(
                  blurRadius: 6.0,
                  color: Colors.grey[600],
                  offset: Offset(0, 1.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Consumer<ClassroomsStore>(
        builder: (_, store, __) {
          return Observer(
            builder: (_) {
              if (store.predefinedClassrooms.isEmpty) {
                return SizedBox.shrink(); // TODO: Empty list
              }

              return ListView.builder(
                itemCount: store.predefinedClassrooms.length,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                itemBuilder: (context, index) {
                  final classroom = store.predefinedClassrooms[index];

                  final images = <String>[
                    ImageAssets.classroomMeditateImage,
                    ImageAssets.classroomVitalityImage,
                    ImageAssets.classroomMomsImage,
                  ];

                  return Row(
                    children: [
                      GestureDetector(
                        child: _getListItem(
                          classroom.title,
                          Colors.amber[200],
                          images[index],
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ClassroomScreen(classroom: classroom);
                            },
                          ));
                        },
                      ),
                      SizedBox(width: index == store.predefinedClassrooms.length - 1 ? 0 : 28),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _ActiveClassesList extends StatelessWidget {
  Widget _classroomListItem(ClassroomModel classroom, BuildContext context) {
    final rand = Random();

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200], width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: LinearGradient(
//                colors: [Color(0x99FF7D14), Color(0x99F94327)],
                colors: [Color(0x99E1DADA), Color(0x99BDCAD9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                emojiForClassroom[rand.nextInt(9)],
                textScaleFactor: 1.6,
              ),
            ),
          ),
          SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  classroom.title,
                  style: Theme.of(context).textTheme.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Text(
                      '${asanasCount(classroom.classroomRoutines.length)}'
                      ' • ${classroomTimeRounded(classroom.totalDuration)}',
                      maxLines: 1,
                      style: Styles.classroomInfoText,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onCreateButtonTap(BuildContext context) {
    final route = MaterialPageRoute(
      // TODO: What about insane rebuilding widgets below?
      fullscreenDialog: true,
      builder: (context) {
        final newClassroomStore = NewClassroomStore();

        when(
          (_) => newClassroomStore.editableClassroom != null,
          () {
            Provider.of<ClassroomsStore>(context, listen: false)
                .addClassroom(newClassroomStore.editableClassroom);

            LocalNotification.success(
              context,
              message: 'Class was created',
              // TODO: Its possible to do in promise callback of Navigator push method
              inPostCallback: true,
            );
          },
          onError: (error, _) {
            LocalNotification.error(context, inPostCallback: true);
            Log.error(error);
          },
        );

        return NewClassroomScreen(newClassroomStore: newClassroomStore);
      },
    );

    Navigator.push(context, route);
    //.then((v) => print(v)); TODO: Check this method to pass a result
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Observer(
          builder: (_) {
            final store = Provider.of<ClassroomsStore>(context, listen: false);
            final reversedClassrooms = store.usersClassrooms.reversed.toList(growable: false);

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: reversedClassrooms.length,
              itemBuilder: (_, index) {
                final classroom = reversedClassrooms[index]; // FIXME: Possible out of a range

                return GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) {
                        // TODO: Add confirmDismiss with popup
                        store.deleteClassroom(classroom);
                      },
                      background: Container(
                        padding: EdgeInsets.only(right: 20),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          color: Colors.red[200],
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                      child: _classroomListItem(classroom, context),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ClassroomScreen(classroom: classroom);
                      },
                    ));
                  },
                );
              },
            );
          },
        ),
        Container(
          width: double.infinity,
          child: Button(
            'Create new class',
            onTap: () => _onCreateButtonTap(context),
          ),
        ),
      ],
    );
  }
}
