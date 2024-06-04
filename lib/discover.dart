import 'dart:math';
import 'package:flutter/material.dart';
import 'fetching/fetch.dart';
import 'main.dart';
import 'DetailPage.dart';

// ignore: camel_case_types
class discover extends StatefulWidget {

  const discover({Key? key ,}) : super(key: key);

  @override
  State<discover> createState() => _discoverState();
}
String search = "";
String cek ="";

class _discoverState extends State<discover> with TickerProviderStateMixin{
  late List<dynamic> topanime;
  late List<dynamic> alldata;
late bool isLoading;

  List<dynamic> getFilteredData( ) {

      if (search.isEmpty ) {
      var anime = topanime;
     var random = Random();
      anime.shuffle(random);
      return anime;
    }
    else {

      var filteredAnime = topanime.where((anime) => anime['title'].toString().toLowerCase().contains(search)  
      || anime['title_english'].toString().toLowerCase().contains(search) ).toList();
      return filteredAnime;
    }
  }
  List<dynamic> getScoreFilteredData( ) {

      if (search.isEmpty ) {
      var anime = topanime;
      anime.sort((a, b) => (b['score'] ?? 0).compareTo(a['score'] ?? 0));
      return anime;
    }
    else {
        var anime = topanime;
        anime.sort((a, b) => (b['score'] ?? 0).compareTo(a['score'] ?? 0));
      var filteredAnime = anime.where((anime) => anime['title'].toString().toLowerCase().contains(search) || anime['title_english'].toString().toLowerCase().contains(search) ).toList();
      return filteredAnime;
    }
  }
  List<dynamic> getTVFilteredData( ) {

      if (search.isEmpty ) {
      var anime = topanime.where((anime) => anime['type'] == "TV").toList();
      return anime;
    }
    else {
        var anime = topanime.where((anime) => anime['type'] == "TV").toList();
      var filteredAnime = anime.where((anime) => anime['title'].toString().toLowerCase().contains(search)|| anime['title_english'].toString().toLowerCase().contains(search) ).toList();
      return filteredAnime;
    }
  }
  List<dynamic> getMovieFilteredData( ) {

      if (search.isEmpty ) {
      var anime = topanime.where((anime) => anime['type'] == "Movie").toList();
      return anime;
    }
    else {
        var anime = topanime.where((anime) => anime['type'] == "Movie").toList();
      var filteredAnime = anime.where((anime) => anime['title'].toString().toLowerCase().contains(search)|| anime['title_english'].toString().toLowerCase().contains(search) ).toList();
      return filteredAnime;
    }
  }
  List<dynamic> getOVAFilteredData( ) {

      if (search.isEmpty ) {
      var anime = topanime.where((anime) => anime['type'] == "OVA").toList();
      return anime;
    }
    else {
        var anime = topanime.where((anime) => anime['type'] == "OVA").toList();
      var filteredAnime = anime.where((anime) => anime['title'].toString().toLowerCase().contains(search)|| anime['title_english'].toString().toLowerCase().contains(search) ).toList();
      return filteredAnime;
    }
  }
  List<dynamic> getPopularityFilteredData( ) {

      if (search.isEmpty ) {
      var anime = topanime;
      anime.sort((a, b) => (a['popularity'] ?? 0).compareTo(b['popularity'] ?? 0));
      return anime;
    }
    else {
        var anime = topanime;
        anime.sort((a, b) => (a['popularity'] ?? 0).compareTo(b['popularity'] ?? 0));
      var filteredAnime = anime.where((anime) => anime['title'].toString().toLowerCase().contains(search)|| anime['title_english'].toString().toLowerCase().contains(search) ).toList();
      return filteredAnime;
    }
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    alldata = [];
    topanime = [];
    isLoading = true;

    getTop.fetchtop().then((data) {
      setState(() {
        topanime = data;
        isLoading = false;
      });
    }).catchError((error) {
      print(error);
      isLoading = false;
    });



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      appBar: AppBar(
        backgroundColor: Background,
        elevation: 0,
        title: Container(

          decoration: BoxDecoration(
            color: Darkmode ? Colors.white : Colors.grey[400],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextFormField(

                    onChanged: (value) {
                      setState(() {
                        search = value.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search Anime '+topanime.length.toString(),
                      border: InputBorder.none,
                      suffixIcon:Icon( Icons.search),

                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
         InkWell(
           onTap: (){
             popup();
           },
           child: Container(
             margin: EdgeInsets.only(right: 10),
             child:
             Icon(Icons.filter_list ,
               color:fontcollor,
               size: 35,),
           ),
         )
        ],

      ),
      body: isLoading // Tampilkan loading jika sedang mengambil data
          ? Center(child: CircularProgressIndicator()) :  ListView(
        children: [
          SizedBox(
              height: 701,
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 0.75,
                children: List.generate( cek == "score" ? getScoreFilteredData().length :
                cek == "popularity" ? getPopularityFilteredData().length :
                cek=="TV" ? getTVFilteredData().length :
                cek=="OVA" ? getOVAFilteredData().length :
                cek=="Movie"?getMovieFilteredData().length : getFilteredData().length
        , (index) {
                  final anime = cek=="score" ? getScoreFilteredData()[index] :
                  cek == "popularity" ? getPopularityFilteredData()[index]:
                  cek=="TV" ? getTVFilteredData()[index]:
                  cek=="OVA" ? getOVAFilteredData()[index]:
                  cek=="Movie"?getMovieFilteredData()[index]:getFilteredData()[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3,vertical: 3),
                    child: _buildAnimeCard(anime),
                  );
                }),
              )),
        ],
      ),
    );
  }

  void popup() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
            color: Background,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20,top: 10),
                    child: Text(
                      'Filter',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Raleway",
                        color: fontcollor,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  IconButton(
                    icon: Icon(Icons.close,
                        color: fontcollor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Divider(
                thickness: 1,
                color: Colors.grey[600]?.withAlpha(40),
              ),
              listile("Rating", "score"),
              listile("Popularity", "popularity"),
              listile("TV", "TV"),
              listile("Movie", "Movie"),
              listile("OVA", "OVA"),
              Divider(),
              ListTile(
                title: Text(
                  'Reset',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  setState(() {
                    cek = "";
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }


  Widget listile(String title , String value){
    return Container(
      decoration: BoxDecoration(
        color: cek == value ? Color(0xFF865DFF).withOpacity(0.3) : null,
        borderRadius: BorderRadius.circular(25)
      ),
      child: ListTile(
        title: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: fontcollor,
              ),
            ),
            Spacer(),
            cek == value
                ? Icon(
              Icons.check,
              color: Colors.green,
            )
                : Container(),
          ],
        ),
        onTap: () {
          setState(() {
            cek = value;
          });
          Navigator.pop(context);
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

