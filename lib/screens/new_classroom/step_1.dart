import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:my_yoga_fl/models/asana_model.dart';
import 'package:my_yoga_fl/screens/new_classroom/step_2.dart';
import 'package:my_yoga_fl/stores/asanas_store.dart';
import 'package:my_yoga_fl/stores/new_classroom_store.dart';
import 'package:my_yoga_fl/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../../extensions/duration_extensions.dart';

class NewClassroomStep1Screen extends StatelessWidget {
  static const TABS_COUNT = 2;

  final NewClassroomStore newClassroomStore;

  const NewClassroomStep1Screen({
    Key key,
    @required this.newClassroomStore,
  }) : super(key: key);

  void _nextStepButtonHandler(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return NewClassroomStep2Screen(newClassroomStore: newClassroomStore);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: TABS_COUNT,
      child: Scaffold(
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
          actions: [
            Observer(
              builder: (_) => IconButton(
                icon: const Icon(Icons.arrow_forward),
                color: Theme.of(context).accentColor,
                onPressed: newClassroomStore.classroomRoutines.isNotEmpty
                    ? () => _nextStepButtonHandler(context)
                    : null,
              ),
            ),
          ],
          title: Text(
            "Позы",
            style: Theme.of(context).textTheme.title,
          ),
          bottom: TabBar(
            labelColor: Colors.black,
            tabs: [
              Consumer<AsanasStore>(builder: (_, store, __) {
                return Tab(text: "Все позы (${store.asanas.length})");
              }),
              Observer(builder: (_) {
                return Tab(text: "Выбранные (${newClassroomStore.classroomRoutines.length})");
              }),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _AllAsanasListTabView(newClassroomStore: newClassroomStore),
            _ClassroomRoutinesListTabView(newClassroomStore: newClassroomStore),
          ],
        ),
      ),
    );
  }
}

class _AllAsanasListTabView extends StatelessWidget {
  final NewClassroomStore newClassroomStore;

  const _AllAsanasListTabView({
    Key key,
    @required this.newClassroomStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final asanasStore = Provider.of<AsanasStore>(context, listen: false);

    return ListView.builder(
      itemCount: asanasStore.sortedAsanasList.length,
      itemBuilder: (_, index) {
        final asana = asanasStore.sortedAsanasList[index];

        return Container(
          child: _AsanaListItem(
            asana: asana,
            onAsanaAdd: () => newClassroomStore.addRoutineToClassroomWithAsana(asana),
          ),
        );
      },
    );
  }
}

class _ClassroomRoutinesListTabView extends StatelessWidget {
  final NewClassroomStore newClassroomStore;

  const _ClassroomRoutinesListTabView({
    Key key,
    @required this.newClassroomStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final asanasStore = Provider.of<AsanasStore>(context, listen: false);

    return Observer(
      // TODO: [ReorderableListView] are bad choice for complex large lists
      // FIXME: Should find another solution for reorderable list
      builder: (_) => ReorderableListView(
        children: [
          for (final routine in newClassroomStore.classroomRoutines)
            _ClassroomRoutineListItem(
              key: UniqueKey(),
              // TODO: UniqueKey
              asanaInRoutine: asanasStore.asanas[routine.asanaUniqueName],
              routineAsanaDuration: routine.asanaDuration,
              isShowReorderIcon: newClassroomStore.classroomRoutines.length > 1,
              onRoutineRemove: () => newClassroomStore.removeRoutineFromClassroom(routine),
              onDurationTap: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (_) {
                    return DurationPicker(
                      title: asanasStore.asanas[routine.asanaUniqueName].title,
                      initialDuration: routine.asanaDuration,
                      isZeroDurationAvailable: false,
                      onSave: (duration) {
                        newClassroomStore.updateRoutineDuration(routine, duration);
                      },
                    );
                  },
                );
              },
            ),
        ],
        onReorder: (prevIdx, newIdx) {
          newClassroomStore.reorderClassroomRoutine(prevIdx, newIdx);
        },
      ),
    );
  }
}

class _ClassroomRoutineListItem extends StatelessWidget {
  final AsanaModel asanaInRoutine;
  final Duration routineAsanaDuration;

  final VoidCallback onRoutineRemove;
  final VoidCallback onDurationTap;

  final isShowReorderIcon;

  _ClassroomRoutineListItem({
    Key key,
    @required this.asanaInRoutine,
    this.isShowReorderIcon = false,
    @required this.onRoutineRemove,
    @required this.routineAsanaDuration,
    @required this.onDurationTap,
  })  : assert(asanaInRoutine != null),
        super(key: key);

  Widget _getReorderIcon() {
    if (isShowReorderIcon == false) {
      return SizedBox.shrink();
    }

    return Row(
      children: [
        Icon(Icons.reorder, color: Colors.grey),
        SizedBox(width: 5),
      ],
    );
  }

  Widget _getDurationTimer() {
    return GestureDetector(
      onTap: onDurationTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(children: [
          Icon(Icons.edit, color: Colors.blue[600], size: 18),
          SizedBox(width: 2),
          Text(
            routineAsanaDuration.toTimeString(),
            style: TextStyle(color: Colors.blue[600]),
          ),
        ]),
      ),
    );
  }

  Widget _getAsanaImage() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.grey[300],
      ),
    );
  }

  Widget _getTrailingWidget() {
    return Row(
      children: [
        _getDurationTimer(),
        SizedBox(width: 5),
        _getReorderIcon(),
      ],
    );
  }

  Widget _getLeadingWidget() {
    return IconButton(
      icon: Align(
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.remove_circle,
          color: Colors.red[300],
        ),
      ),
      onPressed: onRoutineRemove,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100], width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                _getLeadingWidget(),
                _getAsanaImage(),
                SizedBox(width: 5),
                Flexible(
                  child: Text(
                    asanaInRoutine.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 5),
          _getTrailingWidget(),
        ],
      ),
    );
  }
}

class _AsanaListItem extends StatelessWidget {
  final AsanaModel asana;
  final VoidCallback onAsanaAdd;

  _AsanaListItem({
    Key key,
    @required this.asana,
    @required this.onAsanaAdd,
  })  : assert(asana != null),
        assert(onAsanaAdd != null),
        super(key: key);

  Widget _getAsanaImage() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.grey[300],
      ),
    );
  }

  Widget _getTrailingWidget(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add_circle, color: Colors.green),
      onPressed: onAsanaAdd,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100], width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                _getAsanaImage(),
                SizedBox(width: 5),
                Flexible(
                  child: Text(
                    asana.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 5),
          _getTrailingWidget(context),
        ],
      ),
    );
  }
}
