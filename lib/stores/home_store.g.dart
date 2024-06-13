// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on _HomeStore, Store {
  late final _$isLoadingAtom =
      Atom(name: '_HomeStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$apiErrorAtom =
      Atom(name: '_HomeStore.apiError', context: context);

  @override
  String get apiError {
    _$apiErrorAtom.reportRead();
    return super.apiError;
  }

  @override
  set apiError(String value) {
    _$apiErrorAtom.reportWrite(value, super.apiError, () {
      super.apiError = value;
    });
  }

  late final _$isErrorAtom = Atom(name: '_HomeStore.isError', context: context);

  @override
  bool get isError {
    _$isErrorAtom.reportRead();
    return super.isError;
  }

  @override
  set isError(bool value) {
    _$isErrorAtom.reportWrite(value, super.isError, () {
      super.isError = value;
    });
  }

  late final _$musicListAtom =
      Atom(name: '_HomeStore.musicList', context: context);

  @override
  ObservableList<MusicDataResponse> get musicList {
    _$musicListAtom.reportRead();
    return super.musicList;
  }

  @override
  set musicList(ObservableList<MusicDataResponse> value) {
    _$musicListAtom.reportWrite(value, super.musicList, () {
      super.musicList = value;
    });
  }

  late final _$filteredMusicListAtom =
      Atom(name: '_HomeStore.filteredMusicList', context: context);

  @override
  ObservableList<MusicDataResponse> get filteredMusicList {
    _$filteredMusicListAtom.reportRead();
    return super.filteredMusicList;
  }

  @override
  set filteredMusicList(ObservableList<MusicDataResponse> value) {
    _$filteredMusicListAtom.reportWrite(value, super.filteredMusicList, () {
      super.filteredMusicList = value;
    });
  }

  late final _$favouriteMusicListAtom =
      Atom(name: '_HomeStore.favouriteMusicList', context: context);

  @override
  ObservableList<MusicDataResponse> get favouriteMusicList {
    _$favouriteMusicListAtom.reportRead();
    return super.favouriteMusicList;
  }

  @override
  set favouriteMusicList(ObservableList<MusicDataResponse> value) {
    _$favouriteMusicListAtom.reportWrite(value, super.favouriteMusicList, () {
      super.favouriteMusicList = value;
    });
  }

  late final _$myPlayListAtom =
      Atom(name: '_HomeStore.myPlayList', context: context);

  @override
  ObservableList<Playlist> get myPlayList {
    _$myPlayListAtom.reportRead();
    return super.myPlayList;
  }

  @override
  set myPlayList(ObservableList<Playlist> value) {
    _$myPlayListAtom.reportWrite(value, super.myPlayList, () {
      super.myPlayList = value;
    });
  }

  late final _$fetchMusicDataAsyncAction =
      AsyncAction('_HomeStore.fetchMusicData', context: context);

  @override
  Future<void> fetchMusicData() {
    return _$fetchMusicDataAsyncAction.run(() => super.fetchMusicData());
  }

  late final _$FetchDataAsyncAction =
      AsyncAction('_HomeStore.FetchData', context: context);

  @override
  Future<void> FetchData() {
    return _$FetchDataAsyncAction.run(() => super.FetchData());
  }

  late final _$_HomeStoreActionController =
      ActionController(name: '_HomeStore', context: context);

  @override
  void clearStatus() {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.clearStatus');
    try {
      return super.clearStatus();
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void performSearch(String query) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.performSearch');
    try {
      return super.performSearch(query);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addFavourites(int index) {
    final _$actionInfo = _$_HomeStoreActionController.startAction(
        name: '_HomeStore.addFavourites');
    try {
      return super.addFavourites(index);
    } finally {
      _$_HomeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
apiError: ${apiError},
isError: ${isError},
musicList: ${musicList},
filteredMusicList: ${filteredMusicList},
favouriteMusicList: ${favouriteMusicList},
myPlayList: ${myPlayList}
    ''';
  }
}
