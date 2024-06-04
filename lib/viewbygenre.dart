
import 'package:flutter/material.dart';
import 'DetailPage.dart';

import 'main.dart';



class viewbygenre extends StatefulWidget {
  final List<dynamic> data;
  final String title;

  const viewbygenre({Key? key , required this.data , required this.title }) : super(key: key);

  @override
  State<viewbygenre> createState() => _viewbygenreState();
}
class _viewbygenreState extends State<viewbygenre> {

  late int tes =widget.data.where((anime) =>
      anime['genres'].any((genre) => genre['name'] == widget.title)).length;

  @override
  void initState() {
    super.initState();
print(tes);
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor: Background,
      appBar: AppBar(
        backgroundColor:Background,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white, // Ubah warna icon menjadi hitam
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Poppins",

            fontSize: 20,
          ),
        ),

      ),
      body: ListView(
        children: [


          SizedBox(
              height: 700,
              child:  GridView.count(
                crossAxisCount: 3,
                // Menentukan jumlah item per baris
                childAspectRatio:0.75,
                children: List.generate(widget.data.where((anime) =>
                    anime['genres'].any((genre) => genre['name'] == widget.title)).length, (index) {

                  final List<dynamic> data = widget.data.where((anime) =>
                      anime['genres'].any((genre) => genre['name'] == widget.title)).toList();

                  final anime =data[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                    child: _buildAnimeCard(anime),
                  );
                })
                , // Mengacak data topanime
              )



          )



        ],
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
