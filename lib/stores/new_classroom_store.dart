import 'package:mobx/mobx.dart';
import 'package:built_collection/built_collection.dart';
import 'package:my_yoga_fl/models/asana_model.dart';
import 'package:my_yoga_fl/models/classroom_model.dart';

part 'new_classroom_store.g.dart';

class NewClassroomStore = _NewClassroomStoreBase with _$NewClassroomStore;

abstract class _NewClassroomStoreBase with Store {
  @observable
  BuiltList<AsanaModel> selectedAsanas = BuiltList<AsanaModel>.of([]);

  @computed
  int get countOfSelectedAsanas => selectedAsanas.length;

  @action
  void selectAsana(AsanaModel asana) {
    if (selectedAsanas.contains(asana)) {
      return;
    }

    selectedAsanas = selectedAsanas.rebuild((b) => b.add(asana));
  }

  @action
  void deselectAsana(AsanaModel asana) {
    selectedAsanas = selectedAsanas.rebuild((b) => b.remove(asana));
  }

  void addSelectedAsanasToClassroom(ClassroomModel classroom) {
    if (selectedAsanas.isEmpty) {
      return;
    }

    classroom.asanasUniqueNames.clear(); // TODO: Make clone or immutable update
    selectedAsanas.forEach((c) => classroom.asanasUniqueNames.add(c.uniqueName));
  }
}
