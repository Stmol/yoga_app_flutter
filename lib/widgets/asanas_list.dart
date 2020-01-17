import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_yoga_fl/models/asana_model.dart';
import 'package:my_yoga_fl/screens/asana_screen.dart';

// TODO: Delete
class AsanasList extends StatelessWidget {
  final List<AsanaModel> asanas;

  const AsanasList({Key key, @required this.asanas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (asanas.isEmpty) {
      return Container(); // TODO: Empty list
    }

    return Expanded(
      child: Container(
        child: NotificationListener<OverscrollIndicatorNotification>(
          // TODO Check this method for disabling Android like scroll glow
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowGlow();
            return true;
          },
          child: ListView.builder(
            itemCount: asanas.length,
            itemBuilder: (context, index) {
              var asana = asanas[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: GestureDetector(
                  child: AsanaListItem(
                    title: asana.title,
                    imageUrl: asana.imageUrl,
                    level: asana.level,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return AsanaScreen(asana);
                      }),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class AsanaListItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double level;
  final Function onTap;

  const AsanaListItem({
    Key key,
    @required this.title,
    this.imageUrl,
    this.level,
    this.onTap,
  }) : super(key: key);

  Widget _getImage() {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[300],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey[100],
            Colors.grey[300],
          ],
        ),
      ),
      // child: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _getImage(),
            SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              title,
                              style: GoogleFonts.pTSans(
                                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            child: Text(
                              "$level",
                              style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      child: Text(
                        "для начинающих",
                        style: TextStyle(
                          color: Color.fromRGBO(13, 92, 210, 0.9),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Color.fromRGBO(96, 159, 253, 0.3),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
