
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';
import 'model/user.dart';


class AnimeDetailScreen extends StatefulWidget {

  const AnimeDetailScreen({
    Key? key,
    this.title,
    this.imageUrl,
    this.url,
    this.synopsis,
    required this.id,
    this.score,
    this.trailer,
    this.genres,
    this.episodes,
    this.duration,
    this.ranking,
    this.favorite,
    this.member,
    this.popularity,
    this.status,
    this.season,
    this.studio,
    this.source,
    this.rating,
    this.idyoutube,
    this.type


  }) : super(key: key);

  final String? title;
  final String? imageUrl;
  final String? url;
  final String? synopsis;
  final int id;
  final double? score;
  final String? trailer;
  final List<String>? genres;
  final int? episodes ;
  final String? duration ;
  final int? ranking ;
  final int? favorite ;
  final int? member ;
  final int? popularity ;
  final String? status;
  final String? season;
  final String? studio;
  final String? source;
  final String? rating;
  final String? idyoutube;
  final String? type;



  @override
  _AnimeDetailScreenState createState() => _AnimeDetailScreenState();
}
class _AnimeDetailScreenState extends State<AnimeDetailScreen> {
  bool _isExpanded = false;
  bool _isFavorite = false;
  // ignore: unused_field
  bool _showAppBar = false;

  final String boxName = 'userBox';
  late String username = '';
  late Future<List<dynamic>> favData;
  late Box<UserModel> _myBox;
  @override
  void initState() {
    super.initState();

    loadUsername().then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openBox());
    });

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
      });
    });
  }

  Future<void> loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }



  void _openBox() async {
    await Hive.openBox<UserModel>(boxName);
    _myBox = Hive.box<UserModel>(boxName);
    print(username);
    final userModel = _myBox.get(username);
    if (userModel != null && userModel.favorites != null) {
      setState(() {
        _isFavorite = userModel.favorites!.contains(widget.id);
      });
    } else {
      _isFavorite = false;
    }
    print(_isFavorite);
  }
  void _updateFavoriteStatus() {
    final userModel = _myBox.get(username);
    if (userModel != null) {
      final favoritesList = userModel.favorites ?? [];
      if (_isFavorite) {
        favoritesList.add(widget.id);
        userModel.favorites = favoritesList;
        userModel.save();
        _myBox.put(username, userModel);
        print("Berhasil menambahkan ke favorit");
      } else {
        favoritesList.remove(widget.id);
        userModel.favorites = favoritesList;
        userModel.save();
        _myBox.put(Nameuser, userModel);
        print("Berhasil menghapus dari favorit");
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,

      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              Container(
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),

                child: Container(
                  color: Colors.black.withOpacity(0.8),
                ),

              ),
              Positioned(
                  top: 50,
                  left: 15,
                  child:InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child:  Icon(Icons.arrow_back_outlined,
                      size: 35,
                      color: Colors.white,),
                  )
              ),
              Positioned(
                top: 50,
                right: 15,
                child:   InkWell(
                  child: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 35,
                    color: Colors.white,),
                  onTap: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                    _updateFavoriteStatus();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(_isFavorite ? 'Ditambahkan ke Favorit' : 'Dihapus dari Favorit'),
                      duration: Duration(seconds: 2),
                    ));

                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 110,left: 16,right: 16),
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 190,
                        width: 120,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.imageUrl!),
                          ),
                        ),
                      ),
                      SizedBox(width: 17),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title!,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: "Raleway",
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Icon(Icons.play_circle, color: Colors.white),
                                Text(
                                  widget.episodes.toString() == "null"
                                      ? "N/A"
                                      : widget.episodes.toString() + " EP",
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.access_time_filled, color: Colors.white),
                                Text(widget.duration!, style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: widget.score != null
                          ? CircularProgressIndicator(
                        value: widget.score! / 10,
                        strokeWidth: 3,
                        color: Colors.green[600],
                        backgroundColor: Colors.grey[300],
                      )
                          : CircularProgressIndicator(
                        value: 0 / 10,
                        strokeWidth: 3,
                        color: Colors.green[600],
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    Text(
                      widget.score != null ? widget.score.toString() : 'N/A',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 380),
                child: Divider(
                  indent: 20,
                  endIndent: 20,
                  thickness: 1,
                  color: Colors.grey[300]?.withAlpha(50),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 335),
                  child:Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:ElevatedButton(
                              onPressed: widget.trailer != null ? () {
                                _launchUrl(widget.trailer!);
                              } : null, // Disable button if trailer == null
                              style: ButtonStyle(
                                backgroundColor: widget.trailer != null
                                    ? MaterialStateProperty.all<Color>(Colors.red)
                                    : MaterialStateProperty.all<Color>(Colors.grey), // Disable button color if trailer == null
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.play_circle, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    widget.trailer != null ? "Trailer" : "Unknown",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
              ),
              SizedBox(height: 20),
            ],
          ),


          SizedBox(height: 20,),
          Padding(padding:  const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                icon( widget.ranking!= null ? "#"+widget.ranking.toString() : "N/A", "Ranking", Icons.bar_chart_outlined),
                icon(widget.favorite.toString(), "Favorites", Icons.thumb_up_sharp),
                icon(widget.member.toString(), "Members", Icons.people_alt),
                icon("#"+widget.popularity.toString(), "Popularity", Icons.auto_graph),


              ],
            ),),
          SizedBox(height: 20,),
          Divider(
            indent: 20,
            endIndent: 20,
            thickness: 1,
            color: Colors.grey[300],
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            alignment:Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Synopsis",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: fontcollor

                  ),textAlign: TextAlign.left,


                ),
                Text(widget.synopsis ?? "-",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: fontcollor,
                    fontSize: 15,
                  ),

                  overflow: TextOverflow.ellipsis,
                  maxLines: _isExpanded ? 100 : 3,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Text(
                    _isExpanded ? "close" : "read more",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 15,
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Text("Genres",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    color:fontcollor,
                    fontSize: 20,

                  ),textAlign: TextAlign.left,


                ),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    physics: PageScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.genres!.length,
                    itemBuilder: (context, index) {

                      return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child:  Container(

                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Chip(
                                label: Text(widget.genres![index]),
                                backgroundColor: Darkmode? Color(0xFF4F576F) :Color(0xFF131313),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: "Raleway",

                                ),
                              ),
                            ),
                          )
                      );
                    },
                  ),
                ),
                SizedBox(height: 20,),
                Text("More Info",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    color: fontcollor,
                    fontSize: 20,

                  ),textAlign: TextAlign.left,
                ),
                SizedBox(height: 20,),
                info("Status", widget.status ?? "-",),
                Container(
                  child:
                  Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                ),
                info("Season", widget.season ?? "-"),
                Container(
                  child:
                  Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                ),
                info("Studios", widget.studio ?? "-"),
                Container(
                  child:
                  Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                ),
                info("Source", widget.source ?? "-"),
                Container(
                  child:
                  Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                ),
                info("Rating", widget.rating ?? "-"),
                Container(
                  child:
                  Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                ),
                info("Type", widget.type ?? "-"),
                Container(

                  child:
                  Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(height: 50,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could Not Launch $_url');
    }
  }

  Widget info (String title , String data){
    return Padding(padding:  const EdgeInsets.only(left: 2,right: 7,bottom: 4,top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
            style: TextStyle(
                fontFamily: "Poppins",
                color: fontcollor
            ),),
          Text(data ,
            style: TextStyle(
                fontFamily: "Poppins",
                color: fontcollor

            ),),

        ],
      ),);
  }

  Widget icon (String data, String judul , IconData icon){
    return Column(
      children: [
        Icon(icon,
          size: 35,
          color: fontcollor,),
        Text(data,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
              color: fontcollor
          ),),

        Text(judul,
          style: TextStyle(
            fontSize: 15,
            color: Darkmode? Colors.white54 :Colors.black54,
            fontFamily: "Poppins",


          ),)
      ],
    );
  }
}
