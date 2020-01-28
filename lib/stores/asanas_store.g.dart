// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asanas_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AsanasStore on AsanasStoreBase, Store {
  Computed<BuiltList<AsanaModel>> _$sortedAsanasListComputed;

  @override
  BuiltList<AsanaModel> get sortedAsanasList => (_$sortedAsanasListComputed ??=
          Computed<BuiltList<AsanaModel>>(() => super.sortedAsanasList))
      .value;

  final _$asanasAtom = Atom(name: 'AsanasStoreBase.asanas');

  @override
  BuiltMap<String, AsanaModel> get asanas {
    _$asanasAtom.context.enforceReadPolicy(_$asanasAtom);
    _$asanasAtom.reportObserved();
    return super.asanas;
  }

  @override
  set asanas(BuiltMap<String, AsanaModel> value) {
    _$asanasAtom.context.conditionallyRunInAction(() {
      super.asanas = value;
      _$asanasAtom.reportChanged();
    }, _$asanasAtom, name: '${_$asanasAtom.name}_set');
  }

  final _$initAsyncAction = AsyncAction('init');

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }
}
