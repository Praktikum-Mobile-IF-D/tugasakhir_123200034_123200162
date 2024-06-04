import 'dart:ui';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'DetailPage.dart';
import 'viewbygenre.dart';
import "viewmore.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'fetching/fetch.dart';
import 'model/user.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    Key? key,
  }) : super(key: key);
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late List<dynamic> alldata;
  late List<dynamic> topanime;
  late List<dynamic> genreanime;
  late List<dynamic> favorite;
  late List<dynamic> airing;
  late List<dynamic> popular;
  late List<dynamic> fav;
  late String username = '';
  late Box<UserModel> _myBox;
  bool isLoading = true;
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();

    _myBox = Hive.box(boxName);
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
      });
    });

    _openBox();

    alldata = [];
    topanime = [];
    genreanime = [];
    favorite = [];
    airing = [];
    popular = [];

    int completedProcesses = 0;
    int totalProcesses = 5; // Update the total number of processes

    void checkCompletion() {
      completedProcesses++;
      if (completedProcesses == totalProcesses) {
        setState(() {
          isLoading = false; // Loading completed
          isDataLoaded = true; // All data loaded successfully
        });
      }
    }

    loadUsername();

    getTop.fetchtop().then((data) {
      setState(() {
        topanime = data;
      });
      checkCompletion();
    }).catchError((error) {
      print(error);
      checkCompletion();
    });

    getGenre.fetchGenre().then((data) {
      setState(() {
        genreanime = data;
      });
      checkCompletion();
    }).catchError((error) {
      print(error);
      checkCompletion();
    });

    getFavorites.getfaborites().then((data) {
      setState(() {
        favorite = data;
      });
      checkCompletion();
    }).catchError((error) {
      print(error);
      checkCompletion();
    });

    getAired.getaired().then((data) {
      setState(() {
        airing = data;
      });
      checkCompletion();
    }).catchError((error) {
      print(error);
      checkCompletion();
    });

    getMostpopular.getpopular().then((data) {
      setState(() {
        popular = data;
      });
      checkCompletion();
    }).catchError((error) {
      print(error);
      checkCompletion();
    });
  }

  loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  void _openBox() async {
    await Hive.openBox<UserModel>(boxName);
    _myBox = Hive.box<UserModel>(boxName);
  }

  @override
  Widget build(BuildContext context) {
    print(username);

    final user = _myBox.get(username);
    if (isLoading) {
      // Tampilkan tampilan loading saat data sedang dimuat
      return Scaffold(
        backgroundColor: Background,
        appBar: AppBar(
          backgroundColor: Background,
          elevation: 0,
          title: Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundImage:
                AssetImage(user?.image ?? 'fallback_image_path'),
              ),
              SizedBox(width: 10),
              Text(
                "Hello, ${user?.Name}",
                style: TextStyle(
                  color: fontcollor,
                  fontFamily: "Raleway",
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          actions: [
            InkWell(
              onTap: () {
                setState(() {
                  Darkmode = !Darkmode;
                  Background = Darkmode ? Color(0xFF131313) : Colors.white;
                  fontcollor = Darkmode ? Colors.white : Colors.black;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Darkmode
                    ? Icon(Icons.brightness_3, size: 30)
                    : Icon(
                  Icons.wb_sunny_outlined,
                  size: 30,
                  color: Colors.deepOrangeAccent,
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (!isDataLoaded) {
      // Tampilkan tampilan jika data gagal dimuat
      return Center(
        child: Text('Failed to load data..'),
      );
    } else {
      // Tampilkan tampilan yang diinginkan ketika data berhasil dimuat
      return Scaffold(
          backgroundColor: Background,
          appBar: AppBar(
            backgroundColor: Background,
            elevation: 0,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage:
                  AssetImage(user?.image ?? 'fallback_image_path'),
                ),
                SizedBox(width: 10),
                Text(
                  "Hello, ${user?.Name}",
                  style: TextStyle(
                    color: fontcollor,
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            actions: [
              InkWell(
                onTap: () {
                  setState(() {
                    Darkmode = !Darkmode;
                    Background =
                    Darkmode ? Color(0xFF131313) : Color(0xFFEBEBEB);
                    fontcollor = Darkmode ? Colors.white : Colors.black;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Darkmode
                      ? Icon(Icons.brightness_3, size: 30)
                      : Icon(
                    Icons.wb_sunny_outlined,
                    size: 30,
                    color: Colors.deepOrangeAccent,
                  ),
                ),
              ),
            ],
          ),
          body: ListView(
            children: [
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => viewmore(
                              data: topanime.sublist(0, 25),
                              title: "Top Rating Anime ",
                            )));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Top Rating Anime",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: fontcollor,
                              fontWeight: FontWeight.w400,
                              fontSize: 20),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: fontcollor,
                        size: 35,
                      )
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 25,
                  itemBuilder: (context, index) {
                    final anime = topanime[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _buildAnimeCard(anime),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => viewmore(
                              data: genreanime,
                              title: "Genres",
                            )));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Genres",
                          style: TextStyle(
                              color: fontcollor,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              fontSize: 20),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: fontcollor,
                        size: 35,
                      )
                    ],
                  )),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: genreanime
                      .where((genre) =>
                  genre['mal_id'] >= 1 && genre['mal_id'] <= 10)
                      .length,
                  itemBuilder: (context, index) {
                    final genre1 = genreanime
                        .where((genre) =>
                    genre['mal_id'] >= 1 && genre['mal_id'] <= 10)
                        .toList()[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _Genres(genre1),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => viewmore(
                              data: favorite,
                              title: "Most Favorite",
                            )));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Most Favorite",
                          style: TextStyle(
                              color: fontcollor,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              fontSize: 20),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: fontcollor,
                        size: 35,
                      )
                    ],

                  )),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: favorite.length,
                  itemBuilder: (context, index) {
                    final anime = favorite[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _buildAnimeCard(anime),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => viewmore(
                              data: airing,
                              title: "Currently Airing",
                            )));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Currently Airing",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: fontcollor,
                              fontWeight: FontWeight.w400,
                              fontSize: 20),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: fontcollor,
                        size: 35,
                      )
                    ],
                  )),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: airing.length,
                  itemBuilder: (context, index) {
                    final anime = airing[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Aired(anime),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => viewmore(
                              data: popular,
                              title: "Most Popular",
                            )));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Most Popular",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: fontcollor,
                              fontWeight: FontWeight.w400,
                              fontSize: 20),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: fontcollor,
                        size: 35,
                      )
                    ],
                  )),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: popular.length,
                  itemBuilder: (context, index) {
                    final anime = popular[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _buildAnimeCard(anime),
                    );
                  },
                ),
              ),
            ],
          ));
    }
  }

  Container _Genres(Map<String, dynamic> Gen) {
    final name = Gen['name'] as String;
    // print(topanime.length);
    return Container(
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => viewbygenre(
                      data: topanime,
                      title: name,
                    )));
          },
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Chip(
              label: Text(name),
              backgroundColor: Darkmode ? Color(0xFF4F576F) : Color(0xFF131313),
              labelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  fontFamily: "Raleway"),
            ),
          ),
        ));
  }

  Card _buildAnimeCard(Map<String, dynamic> animeData) {
    final title = animeData['title'] as String?;
    final imageUrl = animeData['images']['jpg']['image_url'] as String?;
    final score = animeData['score'] is int
        ? animeData['score'].toDouble()
        : animeData['score'];
    final url = animeData['url'] as String?;
    final synopsis = animeData['synopsis'] as String?;
    final id = animeData['mal_id'] as int;
    final trailer = animeData['trailer']['url'] as String?;
    final genres = (animeData['genres'] as List)
        .map((genre) => genre['name'] as String)
        .toList();
    final episodes = animeData['episodes'] as int?;
    final duration = animeData['duration'] as String?;
    final rank = animeData['rank'] as int?;
    final favorite = animeData['favorites'] as int?;
    final member = animeData['members'] as int?;
    final popularity = animeData['popularity'] as int?;
    final status = animeData['status'] as String?;
    final season = animeData['season'] as String?;
    final studios = animeData['studios'];
    final studio = studios != null && studios.isNotEmpty && studios[0] != null
        ? studios[0]['name'] as String?
        : '';
    final source = animeData['source'] as String?;
    final rating = animeData['rating'] as String?;
    final idyoutube = animeData['trailer']['youtube_id'] as String?;
    final type = animeData['type'] as String?;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AnimeDetailScreen(
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
                  )));
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl!,
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 20,
                    ),
                    SizedBox(width: 4),
                    Text(
                      score != null ? score.toString() : 'N/A',
                      style: TextStyle(
                        fontSize: 16,
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
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: "Raleway"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container Aired(Map<String, dynamic> animeData) {
    final title = animeData['title'] as String?;
    final imageUrl = animeData['images']['jpg']['image_url'] as String?;
    final score = animeData['score'] is int
        ? animeData['score'].toDouble()
        : animeData['score'];
    final url = animeData['url'] as String?;
    final synopsis = animeData['synopsis'] as String?;
    final id = animeData['mal_id'] as int;
    final trailer = animeData['trailer']['url'] as String?;
    final genres = (animeData['genres'] as List)
        .map((genre) => genre['name'] as String)
        .toList();
    final episodes = animeData['episodes'] as int?;
    final duration = animeData['duration'] as String?;
    final rank = animeData['rank'] as int?;
    final favorite = animeData['favorites'] as int?;
    final member = animeData['members'] as int?;
    final popularity = animeData['popularity'] as int?;
    final status = animeData['status'] as String?;
    final season = animeData['season'] as String?;
    final studios = animeData['studios'];
    final studio = studios != null && studios.isNotEmpty && studios[0] != null
        ? studios[0]['name'] as String?
        : '';
    final source = animeData['source'] as String?;
    final rating = animeData['rating'] as String?;
    final idyoutube = animeData['trailer']['youtube_id'] as String?;
    final type = animeData['type'] as String?;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(horizontal: 8),
      width: 370,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AnimeDetailScreen(
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
                  )));
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl!),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10)),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10)),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.black
                      .withOpacity(0.75), // Menetapkan transparansi sebesar 50%
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 190,
                      width: 130,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(imageUrl),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.7),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    score?.toString() ?? 'N/A',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          height: 90,
                          child: Text(
                            title!,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: "Raleway",
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 90,
              left: 150,
              right: 0,
              child: SizedBox(
                height: 20,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: genres.length,
                  itemBuilder: (context, index) {
                    final genreText = index == (genres.length) - 1
                        ? (genres[index])
                        : '${genres[index]}, ';

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Text(
                        genreText,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: "Raleway",
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}