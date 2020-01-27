// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_classroom_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$NewClassroomStore on _NewClassroomStoreBase, Store {
  final _$editableClassroomAtom =
      Atom(name: '_NewClassroomStoreBase.editableClassroom');

  @override
  ClassroomModel get editableClassroom {
    _$editableClassroomAtom.context.enforceReadPolicy(_$editableClassroomAtom);
    _$editableClassroomAtom.reportObserved();
    return super.editableClassroom;
  }

  @override
  set editableClassroom(ClassroomModel value) {
    _$editableClassroomAtom.context.conditionallyRunInAction(() {
      super.editableClassroom = value;
      _$editableClassroomAtom.reportChanged();
    }, _$editableClassroomAtom, name: '${_$editableClassroomAtom.name}_set');
  }

  final _$classroomRoutinesAtom =
      Atom(name: '_NewClassroomStoreBase.classroomRoutines');

  @override
  BuiltList<ClassroomRoutineModel> get classroomRoutines {
    _$classroomRoutinesAtom.context.enforceReadPolicy(_$classroomRoutinesAtom);
    _$classroomRoutinesAtom.reportObserved();
    return super.classroomRoutines;
  }

  @override
  set classroomRoutines(BuiltList<ClassroomRoutineModel> value) {
    _$classroomRoutinesAtom.context.conditionallyRunInAction(() {
      super.classroomRoutines = value;
      _$classroomRoutinesAtom.reportChanged();
    }, _$classroomRoutinesAtom, name: '${_$classroomRoutinesAtom.name}_set');
  }

  final _$_NewClassroomStoreBaseActionController =
      ActionController(name: '_NewClassroomStoreBase');

  @override
  void addRoutineToClassroomWithAsana(AsanaModel asana) {
    final _$actionInfo = _$_NewClassroomStoreBaseActionController.startAction();
    try {
      return super.addRoutineToClassroomWithAsana(asana);
    } finally {
      _$_NewClassroomStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateRoutineDuration(
      ClassroomRoutineModel classroomRoutine, Duration newDuration) {
    final _$actionInfo = _$_NewClassroomStoreBaseActionController.startAction();
    try {
      return super.updateRoutineDuration(classroomRoutine, newDuration);
    } finally {
      _$_NewClassroomStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeRoutineFromClassroom(ClassroomRoutineModel classroomRoutine) {
    final _$actionInfo = _$_NewClassroomStoreBaseActionController.startAction();
    try {
      return super.removeRoutineFromClassroom(classroomRoutine);
    } finally {
      _$_NewClassroomStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reorderClassroomRoutine(int fromIndex, int toIndex) {
    final _$actionInfo = _$_NewClassroomStoreBaseActionController.startAction();
    try {
      return super.reorderClassroomRoutine(fromIndex, toIndex);
    } finally {
      _$_NewClassroomStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void saveForm() {
    final _$actionInfo = _$_NewClassroomStoreBaseActionController.startAction();
    try {
      return super.saveForm();
    } finally {
      _$_NewClassroomStoreBaseActionController.endAction(_$actionInfo);
    }
  }
}
