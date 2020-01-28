// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classrooms_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ClassroomsStore on ClassroomsStoreBase, Store {
  Computed<List<ClassroomModel>> _$predefinedClassroomsComputed;

  @override
  List<ClassroomModel> get predefinedClassrooms =>
      (_$predefinedClassroomsComputed ??=
              Computed<List<ClassroomModel>>(() => super.predefinedClassrooms))
          .value;
  Computed<List<ClassroomModel>> _$usersClassroomsComputed;

  @override
  List<ClassroomModel> get usersClassrooms => (_$usersClassroomsComputed ??=
          Computed<List<ClassroomModel>>(() => super.usersClassrooms))
      .value;

  final _$_classroomsAtom = Atom(name: 'ClassroomsStoreBase._classrooms');

  @override
  BuiltList<ClassroomModel> get _classrooms {
    _$_classroomsAtom.context.enforceReadPolicy(_$_classroomsAtom);
    _$_classroomsAtom.reportObserved();
    return super._classrooms;
  }

  @override
  set _classrooms(BuiltList<ClassroomModel> value) {
    _$_classroomsAtom.context.conditionallyRunInAction(() {
      super._classrooms = value;
      _$_classroomsAtom.reportChanged();
    }, _$_classroomsAtom, name: '${_$_classroomsAtom.name}_set');
  }

  final _$initAsyncAction = AsyncAction('init');

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  final _$ClassroomsStoreBaseActionController =
      ActionController(name: 'ClassroomsStoreBase');

  @override
  void addClassroom(ClassroomModel classroom) {
    final _$actionInfo = _$ClassroomsStoreBaseActionController.startAction();
    try {
      return super.addClassroom(classroom);
    } finally {
      _$ClassroomsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateClassroom(ClassroomModel classroom) {
    final _$actionInfo = _$ClassroomsStoreBaseActionController.startAction();
    try {
      return super.updateClassroom(classroom);
    } finally {
      _$ClassroomsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteClassroom(ClassroomModel classroom) {
    final _$actionInfo = _$ClassroomsStoreBaseActionController.startAction();
    try {
      return super.deleteClassroom(classroom);
    } finally {
      _$ClassroomsStoreBaseActionController.endAction(_$actionInfo);
    }
  }
}
