import 'package:mobx/mobx.dart';
import 'package:music_player/modals/api_service_album.dart';
import 'package:music_player/modals/music_data_response.dart';
import 'package:music_player/modals/api_service.dart';
import 'package:music_player/modals/playlist_data.dart';

part 'home_store.g.dart';

class HomeStore extends _HomeStore with _$HomeStore {}

abstract class _HomeStore with Store {
  _HomeStore() {
    _setUpValidations();
  }

  List<ReactionDisposer> _disposers = [];

  void _setUpValidations() {
    _disposers = [];
  }

  // store variables:-----------------------------------------------------------
  @observable
  bool isLoading = false;

  @observable
  String apiError = "";

  @observable
  bool isError = false;

  @observable
  ObservableList<MusicDataResponse> musicList = ObservableList.of([]);

  @observable
  ObservableList<MusicDataResponse> filteredMusicList = ObservableList.of([]);

  @observable
  ObservableList<MusicDataResponse> favouriteMusicList = ObservableList.of([]);

  @observable
  ObservableList<Playlist> myPlayList = ObservableList.of([]);

  // actions:-----------------------------------------------------------

  @action
  void clearStatus() {
    isError = false;
    apiError = "";
  }

  @action
  Future<void> fetchMusicData() async {
    isLoading = true;
    clearStatus();
    try {
      final musiclist = await ApiService().getAllFetchMusicData();
      musicList.clear();
      musicList.addAll(musiclist);
    } catch (error) {
      isError = true;
      apiError = error.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  void performSearch(String query) {
    var list = musicList.where((element) =>
        element.title!.toLowerCase().contains(query.toLowerCase()));
    filteredMusicList.clear();
    filteredMusicList.addAll(list);
  }

  @action
  void addFavourites(int index) {
    favouriteMusicList.add(musicList[index]);
  }

  @action
  Future<void> FetchData() async {
    APIManager apiManager = APIManager();
    try {
      final playlist = await apiManager.fetchPlaylists();
      myPlayList.clear();
      myPlayList.addAll(playlist);
      print('Fetched ${myPlayList.length} playlistss');
      for (var value in myPlayList) {
        print('Title: ${value.title}, Duration: ${value.duration}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void getdata() {
    fetchMusicData();
  }

// general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
