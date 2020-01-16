import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:my_yoga_fl/models/asana_model.dart';
import 'package:my_yoga_fl/screens/new_classroom/step_2.dart';
import 'package:my_yoga_fl/stores/asanas_store.dart';
import 'package:my_yoga_fl/stores/new_classroom_store.dart';
import 'package:provider/provider.dart';

class NewClassroomStep1Screen extends StatelessWidget {
  static const TAB_BAR_LENGTH = 2;

  final NewClassroomStore newClassroomStore = NewClassroomStore();

  void _nextStepButtonHandler(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return NewClassroomStep2Screen(newClassroomStore: newClassroomStore);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: TAB_BAR_LENGTH,
      child: Scaffold(
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
          actions: <Widget>[
            Observer(
              builder: (_) => IconButton(
                icon: const Icon(Icons.arrow_forward),
                color: Theme.of(context).accentColor,
                onPressed: newClassroomStore.selectedAsanas.isEmpty
                    ? null
                    : () => _nextStepButtonHandler(context),
              ),
            ),
          ],
          title: Text(
            "Позы",
            style: Theme.of(context).textTheme.title,
          ),
          bottom: TabBar(
            labelColor: Colors.black,
            tabs: <Widget>[
              Consumer<AsanasStore>(builder: (_, store, __) {
                return Tab(text: "Все позы (${store.asanas.length})");
              }),
              Observer(
                builder: (_) => Tab(text: "Выбранные (${newClassroomStore.selectedAsanas.length})"),
              ),
            ],
          ),
        ),
//        floatingActionButton: FloatingActionButton.extended(
//          label: Text("Дальше"),
//          icon: Icon(Icons.arrow_forward_ios),
//          elevation: 0,
//          onPressed: () {},
//        ),
        body: TabBarView(
          children: <Widget>[
            _AllAsanasListTabView(newClassroomStore: newClassroomStore),
            _SelectedAsanasListTabView(newClassroomStore: newClassroomStore),
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
    final asanasStore = Provider.of<AsanasStore>(context);

    return Observer(
      builder: (_) {
        return ListView.builder(
          itemCount: asanasStore.asanas.length,
          itemBuilder: (_, index) {
            return Container(
              child: _AsanaListItem(
                asana: asanasStore.asanas[index],
                newClassroomStore: newClassroomStore,
              ),
            );
          },
        );
      },
    );
  }
}

class _SelectedAsanasListTabView extends StatelessWidget {
  final NewClassroomStore newClassroomStore;

  const _SelectedAsanasListTabView({
    Key key,
    @required this.newClassroomStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => ListView.builder(
        itemCount: newClassroomStore.countOfSelectedAsanas,
        itemBuilder: (_, index) {
          return Container(
            child: _AsanaListItem(
              asana: newClassroomStore.selectedAsanas[index],
              newClassroomStore: newClassroomStore,
            ),
          );
        },
      ),
    );
  }
}

class _AsanaListItem extends StatelessWidget {
  final AsanaModel asana;
  final NewClassroomStore newClassroomStore;

  _AsanaListItem({
    @required this.asana,
    @required this.newClassroomStore,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[100], width: 1)),
          color: newClassroomStore.selectedAsanas.contains(asana)
              ? Colors.deepPurple[50]
              : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey[300],
                    ),
                  ),
                  SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      asana.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Checkbox(
              value: newClassroomStore.selectedAsanas.contains(asana),
              onChanged: (isSelected) {
                if (isSelected == true) {
                  newClassroomStore.selectAsana(asana);
                } else {
                  newClassroomStore.deselectAsana(asana);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
