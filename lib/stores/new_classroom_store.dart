import 'package:mobx/mobx.dart';
import 'package:built_collection/built_collection.dart';
import 'package:my_yoga_fl/models/asana_model.dart';
import 'package:my_yoga_fl/models/classroom_model.dart';
import 'package:my_yoga_fl/models/classroom_routine_model.dart';
import 'package:my_yoga_fl/utils/log.dart';

part 'new_classroom_store.g.dart';

class NewClassroomStore = _NewClassroomStoreBase with _$NewClassroomStore;

abstract class _NewClassroomStoreBase with Store {
  static const MAX_CLASSROOM_ROUTINES_COUNT = 50;

  ///
  /// [classroom] is an instance of existing Classroom for editing
  /// [allAsanas] is a full list of [AsanaModel] from [AsanasStore]
  ///
  _NewClassroomStoreBase.withClassroom(ClassroomModel classroom)
      : assert(classroom != null),
        editableClassroom = classroom {
    assert(editableClassroom.classroomRoutines.isNotEmpty);

    formIntervalDuration = editableClassroom.durationBetweenAsanas;
    formTitle = editableClassroom.title;
    formDescription = editableClassroom.description;

    classroomRoutines =
        ListBuilder<ClassroomRoutineModel>(editableClassroom.classroomRoutines).build();
  }

  _NewClassroomStoreBase();

  String formTitle;
  String formDescription;
  Duration formIntervalDuration = ClassroomModel.DEFAULT_DURATION_BETWEEN_ASANAS;

  @observable
  ClassroomModel editableClassroom;

  @observable
  BuiltList<ClassroomRoutineModel> classroomRoutines = BuiltList<ClassroomRoutineModel>.of([]);

  @action
  void addRoutineToClassroomWithAsana(AsanaModel asana) {
    if (classroomRoutines.length >= MAX_CLASSROOM_ROUTINES_COUNT) {
      // TODO: Show snackbar
      Log.info('Max classroom routines count reached');

      return;
    }

    final classroomRoutine = ClassroomRoutineModel(
      asanaUniqueName: asana.uniqueName,
      asanaDuration: ClassroomRoutineModel.DEFAULT_ASANA_DURATION,
    );

    classroomRoutines = classroomRoutines.rebuild((b) => b.add(classroomRoutine));
  }

  @action
  void updateRoutineDuration(ClassroomRoutineModel classroomRoutine, Duration newDuration) {
    final indexOfRoutine = classroomRoutines.indexOf(classroomRoutine);
    if (indexOfRoutine == -1) {
      return;
    }

    final newRoutine = ClassroomRoutineModel(
      uid: classroomRoutine.uid,
      asanaUniqueName: classroomRoutine.asanaUniqueName,
      asanaDuration: newDuration,
    );

    classroomRoutines = classroomRoutines.rebuild((b) => b[indexOfRoutine] = newRoutine);
  }

  @action
  void removeRoutineFromClassroom(ClassroomRoutineModel classroomRoutine) {
    classroomRoutines = classroomRoutines.rebuild((b) => b.remove(classroomRoutine));
  }

  @action
  void reorderClassroomRoutine(int fromIndex, int toIndex) {
    if (classroomRoutines.length < 2) {
      return;
    }

    final routine = classroomRoutines[fromIndex];
    if (routine == null) {
      return;
    }

    if (toIndex > fromIndex) {
      toIndex -= 1;
    }

    classroomRoutines = classroomRoutines.rebuild((b) => b
      ..removeAt(fromIndex)
      ..insert(toIndex, routine));
  }

  ///
  /// Handle submitting data from form to saving classroom
  ///
  @action
  void saveForm() {
    // TODO: Add validation
    final description = formDescription?.trim();

    ClassroomModel newClassroom;

    if (editableClassroom != null) {
      newClassroom = ClassroomModel(
        id: editableClassroom.id,
        title: formTitle ?? editableClassroom.title,
        description: description ?? editableClassroom.description,
        coverImage: editableClassroom.coverImage,
        isPredefined: editableClassroom.isPredefined,
        timeBetweenAsanas: formIntervalDuration.inSeconds,
        classroomRoutines: classroomRoutines.toList(growable: false),
      );
    } else {
      newClassroom = ClassroomModel(
        title: formTitle,
        description: description,
        timeBetweenAsanas: formIntervalDuration.inSeconds,
        classroomRoutines: classroomRoutines.toList(growable: false),
      );
    }

    editableClassroom = newClassroom;
  }
}
