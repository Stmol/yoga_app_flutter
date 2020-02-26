import 'package:flutter/material.dart';
import 'package:my_yoga_fl/screens/new_classroom/step_1.dart';
import 'package:my_yoga_fl/screens/new_classroom/step_2.dart';
import 'package:my_yoga_fl/stores/new_classroom_store.dart';

class NewClassroomScreen extends StatelessWidget {
  static const STEP_1_ROUTE_NAME = 'new_classroom/step_1';
  static const STEP_2_ROUTE_NAME = 'new_classroom/step_2';

  final NewClassroomStore newClassroomStore;

  const NewClassroomScreen({
    Key key,
    @required this.newClassroomStore,
  })  : assert(newClassroomStore != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: STEP_1_ROUTE_NAME,
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;

        switch (settings.name) {
          case STEP_1_ROUTE_NAME:
            builder = (_) => NewClassroomStep1Screen(
                  newClassroomStore: newClassroomStore,
                  onCancel: () => Navigator.pop(context),
                );
            break;

          case STEP_2_ROUTE_NAME:
            builder = (_) => NewClassroomStep2Screen(
                  newClassroomStore: newClassroomStore,
                  onCreationComplete: () => Navigator.pop(context),
                );
            break;

          default:
            throw Exception('Invalid route: ${settings.name}');
        }

        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
