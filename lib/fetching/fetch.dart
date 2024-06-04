import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../main.dart';
import '../model/user.dart';

class getTop {
  static Future<List<dynamic>> fetchtop() async {
    List<dynamic> animeData = [];
    try {
      for (int page = 1; page <= 150; page++) {
        // ambil data pada halaman 1-5
        final url = "https://api.jikan.moe/v4/top/anime?page=$page";
        final file = await DefaultCacheManager().getSingleFile(url);
        final response = await file
            .readAsString()
            .then((jsonString) => jsonDecode(jsonString));
        final data = response['data'] as List<dynamic>;
        animeData.addAll(data);
      }
    } catch (error) {
      print(error);
    }
    return animeData;
  }
}

class getGenre {
  static Future<List<dynamic>> fetchGenre() async {
    List<dynamic> animeData = [];
    try {
      String url = "https://api.jikan.moe/v4/genres/anime";
      var file = await DefaultCacheManager().getSingleFile(url);
      var response = await file.readAsString();
      final data = jsonDecode(response)['data'] as List<dynamic>;
      animeData.addAll(data);
    } catch (error) {
      print(error);
    }
    return animeData;
  }
}

class getFavorites {
  static Future<List<dynamic>> getfaborites() async {
    List<dynamic> animeData = [];

    try {
      for (int page = 1; page <= 10; page++) {
        // ambil data pada halaman 1-5
        final url =
            "https://api.jikan.moe/v4/top/anime?page=$page&filter=favorite";
        final file = await DefaultCacheManager().getSingleFile(url);
        final response = await file
            .readAsString()
            .then((jsonString) => jsonDecode(jsonString));

        final data = response['data'] as List<dynamic>;
        animeData.addAll(data);
      }
    } catch (error) {
      print(error);
    }

    return animeData;
  }
}

class getAired {
  static Future<List<dynamic>> getaired() async {
    List<dynamic> animeData = [];

    try {
      for (int page = 1; page <= 20; page++) {
        // ambil data pada halaman 1-5
        final url =
            "https://api.jikan.moe/v4/top/anime?page=$page&filter=airing";
        final file = await DefaultCacheManager().getSingleFile(url);
        final response = await file
            .readAsString()
            .then((jsonString) => jsonDecode(jsonString));

        final data = response['data'] as List<dynamic>;
        animeData.addAll(data);
      }
    } catch (error) {
      print(error);
    }

    return animeData;
  }
}

class getMostpopular {
  static Future<List<dynamic>> getpopular() async {
    List<dynamic> animeData = [];

    try {
      for (int page = 1; page <= 10; page++) {
        // ambil data pada halaman 1-5
        final url =
            "https://api.jikan.moe/v4/top/anime?page=$page&filter=bypopularity";
        final file = await DefaultCacheManager().getSingleFile(url);
        final response = await file
            .readAsString()
            .then((jsonString) => jsonDecode(jsonString));

        final data = response['data'] as List<dynamic>;
        animeData.addAll(data);
      }
    } catch (error) {
      print(error);
    }

    return animeData;
  }
}

class GetFavorite {
  late Box<UserModel>? _myBox;

  Future<void> _openBox() async {
    await Hive.openBox<UserModel>(boxName);
    _myBox = Hive.box<UserModel>(boxName);
  }

  Future<List<dynamic>> getFavoritesData(String username) async {
    List<dynamic> animeData = [];

    try {
      await _openBox();
      final user = _myBox!.get(username);

      if (user != null &&
          user.favorites != null &&
          user.favorites!.isNotEmpty) {
        for (int favorite in user.favorites!) {
          print(favorite);
          final url = "https://api.jikan.moe/v4/anime/$favorite";
          final file = await DefaultCacheManager().getSingleFile(url);
          final response = await file
              .readAsString()
              .then((jsonString) => jsonDecode(jsonString));

          final data = response['data'];
          animeData.add(data);
        }
      }
    } catch (error) {
      print(error);
    }

    return animeData;
  }
}
