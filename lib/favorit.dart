// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'DetailPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'fetching/fetch.dart';

import 'model/user.dart';

class favorites extends StatefulWidget {


  @override
  _favoritesState createState() => _favoritesState();
}

class _favoritesState extends State<favorites> {
  late Box<UserModel> _myBox;
  late Future<List<dynamic>> favData;
  late SharedPreferences _prefs;
  late String username='';
  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
      });
    });


    _openBox();
    loadUsername().then((_) {
      favData = GetFavorite().getFavoritesData(username).catchError((error) {
        print(error);
        return [];
      });
    });
  }

  loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _prefs = prefs;
      username = prefs.getString('username') ?? '';

    });
  }

  void _openBox() async {
    await Hive.openBox<UserModel>(boxName);
    _myBox = Hive.box<UserModel>(boxName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Background,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: fontcollor, // Atur warna ikon kembali (back) di sini
        ),
        backgroundColor: Background,
        title: Text('Favorite List',
        style: TextStyle(
          fontFamily: "Poppins",
          color: fontcollor
        ),),
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: favData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final fav = snapshot.data ?? [];

            if (fav.isEmpty) {
              return Center(
                child: Text('Tidak ada favorit yang tersimpan.',
                style: TextStyle(
                    color: fontcollor,
                  fontSize: 17,
                  fontFamily: "Raleway"
                ),
                ),
              );
            }

            return ValueListenableBuilder(
              valueListenable: _myBox.listenable(),
              builder: (context, Box<UserModel> box, _) {
                if (box.isEmpty) {
                  return Center(
                    child: Text('Tidak ada favorit yang tersimpan.',
                      style: TextStyle(
                          color: fontcollor,
                          fontSize: 17,
                          fontFamily: "Raleway"
                      ),),
                  );
                }

                final user = _myBox.get(username);

                if (user == null ||
                    user.favorites == null ||
                    user.favorites!.isEmpty) {
                  return Center(
                    child: Text('Tidak ada favorit yang tersimpan.',
                        style: TextStyle(
                            color: fontcollor,
                            fontSize: 17,
                            fontFamily: "Raleway"
                        ),),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: fav.length,
                  itemBuilder: (context, index) {
                    final favoriteId = fav[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 3,
                        vertical: 3,
                      ),
                      child: _buildAnimeCard(favoriteId),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }


  Container _buildAnimeCard(Map<String, dynamic> animeData) {
    // ignore: unused_local_variable
    final temp = animeData;

    final title = animeData['title'] as String?;
    final imageUrl = animeData['images']['jpg']['image_url'] as String?;
    final score = animeData['score'] is int ? animeData['score'].toDouble() : animeData['score'];
    final url = animeData['url'] as String?;
    final synopsis = animeData['synopsis'] as String?;
    final id = animeData['mal_id'] as int;
    final trailer = animeData['trailer']['url'] as String?;
    final genres = (animeData['genres'] as List).map((
        genre) => genre['name'] as String).toList();
    final episodes = animeData['episodes'] as int?;
    final duration = animeData['duration'] as String?;
    final rank = animeData['rank'] as int?;
    final favorite = animeData['favorites'] as int?;
    final member = animeData['members'] as int?;
    final popularity = animeData['popularity'] as int?;
    final status =animeData['status'] as String?;
    final season =animeData['season'] as String?;
    final studios = animeData['studios'];
    final studio = studios != null && studios.isNotEmpty && studios[0] != null ? studios[0]['name'] as String? : '';
    final source =animeData['source'] as String?;
    final rating =animeData['rating'] as String?;
    final idyoutube = animeData['trailer']['youtube_id'] as String?;
    final type =animeData['type'] as String?;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        image: DecorationImage(
          image: NetworkImage(imageUrl!),
          fit: BoxFit.cover,

        ),
      ),

      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AnimeDetailScreen(
                title: title,
                imageUrl: imageUrl,
                url: url,
                synopsis: synopsis,
                id: id,
                score: score,
                trailer: trailer,
                genres: genres,
                episodes: episodes,
                duration: duration,
                ranking: rank,
                favorite: favorite,
                member: member,
                popularity: popularity,
                status: status,
                season: season,
                studio: studio,
                source: source,
                rating: rating,
                idyoutube: idyoutube,
                type: type,
              )
              )
          );
        },
        child: Stack(
          children: [

            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius:BorderRadius.circular(5)
                ),
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 12,
                    ),
                    SizedBox(width: 4),
                    Text(
                      score != null ? score.toString() : 'N/A',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: Text(
                  title!.length > 15 ? '${title.substring(0, 15)}...' : title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: "Raleway"
                  ),
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}

