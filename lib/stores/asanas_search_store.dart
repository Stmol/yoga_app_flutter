import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:my_yoga_fl/models/asana_model.dart';

part 'asanas_search_store.g.dart';

class AsanasSearchStore = AsanasSearchStoreBase with _$AsanasSearchStore;

abstract class AsanasSearchStoreBase with Store {
  final BuiltList<AsanaModel> initialAsanasList;

  @observable
  BuiltList<AsanaModel> _asanasList = BuiltList<AsanaModel>();

  @observable
  String _searchText;

  @observable
  bool _isSearchInProgress = false;

  ReactionDisposer _searchTextReaction;
  ReactionDisposer _searchProgressReaction;

  @computed
  BuiltList<AsanaModel> get asanas => _asanasList;

  AsanasSearchStoreBase({@required this.initialAsanasList}) : assert(initialAsanasList != null) {
    _searchTextReaction = reaction((_) => _searchText, (text) => _updateAsanasBySearchText(text));

    _searchProgressReaction = reaction((_) => _isSearchInProgress, (isInProgress) {
      if (isInProgress == true) {
        _asanasList = _asanasList.rebuild((b) => b.clear());
      } else {
        _searchText = '';
        _asanasList = initialAsanasList;
      }
    });

    _asanasList = initialAsanasList;
  }

  void _updateAsanasBySearchText(String text) {
    if (_isSearchInProgress == false) {
      return;
    }

    final searchText = text.trim().toLowerCase();
    if (searchText.isEmpty) {
      _asanasList = _asanasList.rebuild((b) => b.clear());

      return;
    }

    final titleStartWith = List<AsanaModel>();
    final titleContain = List<AsanaModel>();
    final hindiContain = List<AsanaModel>();

    initialAsanasList.forEach((asana) {
      if (asana.title.toLowerCase().startsWith(searchText)) {
        titleStartWith.add(asana);
      } else if (asana.title.toLowerCase().contains(searchText)) {
        titleContain.add(asana);
      } else if (asana.hindiTitle.toLowerCase().contains(searchText)) {
        hindiContain.add(asana);
      }
    });

    _asanasList = (titleStartWith + titleContain + hindiContain).toBuiltList();
  }

  void onTextFieldWidgetFocusChanged(bool hasFocus) {
    if (hasFocus && _isSearchInProgress == false && _searchText.isEmpty) {
      _isSearchInProgress = true;
    }
  }

  void onTextFieldWidgetCancelTap() {
    _isSearchInProgress = false;
  }

  void onTextFieldWidgetTextChanged(String text) {
    _searchText = text;
  }

  void dispose() {
    _searchProgressReaction();
    _searchTextReaction();
  }
}
