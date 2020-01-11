import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_yoga_fl/screens/classroom_screen.dart';
import 'package:my_yoga_fl/screens/new_classroom_screen.dart';
import 'package:my_yoga_fl/widgets/button.dart';
import 'package:my_yoga_fl/widgets/search_field.dart';
import 'package:my_yoga_fl/models/classroom_model.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.grey,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Классы",
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: _ClassroomsScreen(),
    );
  }
}

class _ClassroomsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 18),
      child: Column(
        children: <Widget>[
          SearchField(),
          SizedBox(height: 15),
          Expanded(
            child: ListView(
              children: <Widget>[
                _PredefinedClassesList(),
                SizedBox(height: 15),
                _ActiveClassesList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PredefinedClassesList extends StatelessWidget {
  Widget _getListItem(String title, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      height: 150,
      width: 120,
      padding: EdgeInsets.all(10),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: GoogleFonts.pTSansCaption(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16, // TODO: Words wrapping by letter
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var classroom = classrooms[0];

    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),

        itemBuilder: (context, index) {
          if (index >= classrooms.length) {
            return null;
          }

          var classroom = classrooms[index];

          return Row(
            children: <Widget>[
              GestureDetector(
                child: _getListItem(classroom.title, classroom.color),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ClassroomScreen(classroomModel: classroom);
                    },
                  ));
                },
              ),
              SizedBox(width: 20),
            ],
          );
        },
      ),
    );
  }
}

class _ActiveClassesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Button(
        title: "Создать свой класс",
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NewClassroomScreen();
          }));
        },
      ),
    );
    // return ListView(
    //   physics: NeverScrollableScrollPhysics(),
    //   children: <Widget>[
    //     Button(
    //       title: "Создать свой класс",
    //       onPressed: () {},
    //     )
    //   ],
    // );
  }
}
