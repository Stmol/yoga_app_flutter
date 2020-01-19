import 'package:mobx/mobx.dart';
import 'package:built_collection/built_collection.dart';
import 'package:my_yoga_fl/models/asana_model.dart';
import 'package:my_yoga_fl/models/classroom_model.dart';

part 'new_classroom_store.g.dart';

class NewClassroomStore = _NewClassroomStoreBase with _$NewClassroomStore;

abstract class _NewClassroomStoreBase with Store {
  ///
  /// [classroom] is an instance of existing Classroom for editing
  /// [asanas] is a full list of [AsanaModel] from [AsanasStore]
  ///
  _NewClassroomStoreBase.withClassroom(ClassroomModel classroom, BuiltList<AsanaModel> asanas)
      : assert(classroom != null),
        editableClassroom = classroom {
    selectedAsanas = selectedAsanas.rebuild(
      (b) => b.addAll(classroom.asanasUniqueNames.map(
        (name) => asanas.singleWhere((asana) => asana.uniqueName == name),
      )),
    );
  }

  _NewClassroomStoreBase();

  String formTitle;
  String formDescription;
  int formTimeInterval;

  @observable
  ClassroomModel editableClassroom;

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

  @action
  void reorderSelectedAsana(int fromIndex, int toIndex) {
    final asana = selectedAsanas[fromIndex];
    if (asana == null) {
      return;
    }

    if (toIndex > fromIndex) {
      toIndex -= 1;
    }

    selectedAsanas = selectedAsanas.rebuild((b) =>
    b
      ..removeAt(fromIndex)
      ..insert(toIndex, asana));
  }

  ///
  /// Handle submitting data from form to saving classroom
  ///
  @action
  void saveForm() {
    // TODO: Add validation

    ClassroomModel newClassroom;

    // FIXME: Warning! I should start using built_value in this project
    /// Comment: Why i did it?
    /// Because instance of class List<String> in [asanasUniqueNames] property of [ClassroomModel]
    /// are passing by reference (Surprise!)
    final asanasUniqueNames = selectedAsanas
        .map<String>((asana) => asana.uniqueName)
        .toList(growable: false);

    if (editableClassroom != null) {
      newClassroom = ClassroomModel(
        id: editableClassroom.id,
        title: formTitle ?? editableClassroom.title,
        description: formDescription ?? editableClassroom.description,
        asanasUniqueNames: asanasUniqueNames,
        coverImage: editableClassroom.coverImage,
        isPredefined: editableClassroom.isPredefined,
        timeBetweenAsanas: formTimeInterval ?? editableClassroom.timeBetweenAsanas,
      );
    } else {
      newClassroom = ClassroomModel(
        title: formTitle,
        description: formDescription,
        timeBetweenAsanas: formTimeInterval,
        asanasUniqueNames: asanasUniqueNames,
      );
    }

    //_addSelectedAsanasToClassroom(newClassroom);
    editableClassroom = newClassroom;
  }

  void _addSelectedAsanasToClassroom(ClassroomModel classroom) {
    // TODO: Make clone or immutable update
    classroom.asanasUniqueNames
      ..clear()
      ..addAll(selectedAsanas.map((asana) => asana.uniqueName));
  }
}
