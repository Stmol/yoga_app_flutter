// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asanas_search_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AsanasSearchStore on AsanasSearchStoreBase, Store {
  Computed<BuiltList<AsanaModel>> _$asanasComputed;

  @override
  BuiltList<AsanaModel> get asanas =>
      (_$asanasComputed ??= Computed<BuiltList<AsanaModel>>(() => super.asanas))
          .value;

  final _$_asanasListAtom = Atom(name: 'AsanasSearchStoreBase._asanasList');

  @override
  BuiltList<AsanaModel> get _asanasList {
    _$_asanasListAtom.context.enforceReadPolicy(_$_asanasListAtom);
    _$_asanasListAtom.reportObserved();
    return super._asanasList;
  }

  @override
  set _asanasList(BuiltList<AsanaModel> value) {
    _$_asanasListAtom.context.conditionallyRunInAction(() {
      super._asanasList = value;
      _$_asanasListAtom.reportChanged();
    }, _$_asanasListAtom, name: '${_$_asanasListAtom.name}_set');
  }

  final _$_searchTextAtom = Atom(name: 'AsanasSearchStoreBase._searchText');

  @override
  String get _searchText {
    _$_searchTextAtom.context.enforceReadPolicy(_$_searchTextAtom);
    _$_searchTextAtom.reportObserved();
    return super._searchText;
  }

  @override
  set _searchText(String value) {
    _$_searchTextAtom.context.conditionallyRunInAction(() {
      super._searchText = value;
      _$_searchTextAtom.reportChanged();
    }, _$_searchTextAtom, name: '${_$_searchTextAtom.name}_set');
  }

  final _$_isSearchInProgressAtom =
      Atom(name: 'AsanasSearchStoreBase._isSearchInProgress');

  @override
  bool get _isSearchInProgress {
    _$_isSearchInProgressAtom.context
        .enforceReadPolicy(_$_isSearchInProgressAtom);
    _$_isSearchInProgressAtom.reportObserved();
    return super._isSearchInProgress;
  }

  @override
  set _isSearchInProgress(bool value) {
    _$_isSearchInProgressAtom.context.conditionallyRunInAction(() {
      super._isSearchInProgress = value;
      _$_isSearchInProgressAtom.reportChanged();
    }, _$_isSearchInProgressAtom,
        name: '${_$_isSearchInProgressAtom.name}_set');
  }
}
