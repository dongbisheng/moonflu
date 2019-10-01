import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/item_model.dart';
import '../models/trailer_model.dart';

class MovieApiProvider {
  Client client = Client();
  static final _apiKey = 'd177ab70124809ebad1e06d5ef1019fb';
  final base_url = 'http://api.themoviedb.org/3/movie';

  Future<ItemModel> fetchMovieList() async {
    print('entered');
    final response = await client.get('$base_url/popular?api_key=$_apiKey');
    print(response.toString());
    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<TrailerModel> fetchTrailer(int movieId) async {
    final response = await client.get('$base_url/$movieId/videos?api_key=$_apiKey');
    if (response.statusCode == 200) {
      return TrailerModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load trailers');
    }
  }
}