import 'package:dio/dio.dart';
import 'package:music_player/modals/playlist_data.dart';

class APIManager {
  final Dio _dio = Dio();

  Future<List<Playlist>> fetchPlaylists() async {
    //const String url = 'https://api.deezer.com/playlist/908622995';
    const String url = 'https://api.deezer.com/user/2529/playlists';
    try {
      Response response = await _dio.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        return data.map((json) => Playlist.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load playlists');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // The server responded with a non-200 status code
        print(
            'Error: ${e.response?.statusCode} - ${e.response?.statusMessage}');
        print('Response data: ${e.response?.data}');
      } else {
        // There was an error setting up or sending the request
        print('Error: ${e.message}');
      }
      throw Exception('Failed to load playlists');
    }
  }
}
