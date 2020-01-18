// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_classroom_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$NewClassroomStore on _NewClassroomStoreBase, Store {
  Computed<int> _$countOfSelectedAsanasComputed;

  @override
  int get countOfSelectedAsanas => (_$countOfSelectedAsanasComputed ??=
          Computed<int>(() => super.countOfSelectedAsanas))
      .value;

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

  final _$selectedAsanasAtom =
      Atom(name: '_NewClassroomStoreBase.selectedAsanas');

  @override
  BuiltList<AsanaModel> get selectedAsanas {
    _$selectedAsanasAtom.context.enforceReadPolicy(_$selectedAsanasAtom);
    _$selectedAsanasAtom.reportObserved();
    return super.selectedAsanas;
  }

  @override
  set selectedAsanas(BuiltList<AsanaModel> value) {
    _$selectedAsanasAtom.context.conditionallyRunInAction(() {
      super.selectedAsanas = value;
      _$selectedAsanasAtom.reportChanged();
    }, _$selectedAsanasAtom, name: '${_$selectedAsanasAtom.name}_set');
  }

  final _$_NewClassroomStoreBaseActionController =
      ActionController(name: '_NewClassroomStoreBase');

  @override
  void selectAsana(AsanaModel asana) {
    final _$actionInfo = _$_NewClassroomStoreBaseActionController.startAction();
    try {
      return super.selectAsana(asana);
    } finally {
      _$_NewClassroomStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deselectAsana(AsanaModel asana) {
    final _$actionInfo = _$_NewClassroomStoreBaseActionController.startAction();
    try {
      return super.deselectAsana(asana);
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
