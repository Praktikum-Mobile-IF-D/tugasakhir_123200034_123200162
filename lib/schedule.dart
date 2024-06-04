
import 'package:flutter/material.dart';
import 'count.dart';
import 'fetching/fetch.dart';
import 'viewmore.dart';


import 'main.dart';

class schedule extends StatefulWidget {
  const schedule({Key? key}) : super(key: key);

  @override
  State<schedule> createState() => _scheduleState();
}

class _scheduleState extends State<schedule> {
  late List<dynamic> monday;
  late List<dynamic> tuesday;
  late List<dynamic> wednesday;
  late List<dynamic> thursday;
  late List<dynamic> friday;
  late List<dynamic> saturday;
  late List<dynamic> sunday;
  late List<dynamic> airing;
  bool isLoading = true;
  bool isDataLoaded = false;


  @override
  void initState() {
    super.initState();
    monday = [];
    tuesday = [];
    wednesday = [];
    thursday = [];
    friday = [];
    saturday = [];
    sunday = [];
    airing = [];
    // ignore: unused_local_variable
    int completedProcesses = 0;
    // ignore: unused_local_variable
    int totalProcesses = 1; // Update the total number of processes

    isLoading = true;
    getAired.getaired().then((data) {
      setState(() {
        airing = data;
      });
     isLoading=false;
    }).catchError((error) {
      print(error);
      isLoading=false;
    });


  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      body:isLoading // Tampilkan loading jika sedang mengambil data
          ? Center(child: CircularProgressIndicator()) : ListView(
        padding: EdgeInsets.only(top: 50),
        children: [
         tile("Sunday", airing.where((item) => (item["broadcast"]["time"] != null) && item["broadcast"]["day"]=="Sundays").toList()),
          SizedBox(height: 20,),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:  airing.where((item) => (item["broadcast"]["time"] != null) && item["broadcast"]["day"]=="Sundays").toList().length,
              itemBuilder: (context, index) {
                final anime = airing.where((item) => (item["broadcast"]["time"] != null) && item["broadcast"]["day"]=="Sundays").toList()[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Aired(anime),
                );
              },
            ),
          ),
          // Senin
          tile("Monday", airing.where((item) => (item["broadcast"]["time"] != null) && item["broadcast"]["day"]=="Mondays").toList()),
          SizedBox(height: 20,),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:  airing.where((item) => (item["broadcast"]["time"] != null) && item["broadcast"]["day"]=="Mondays").toList().length,
              itemBuilder: (context, index) {
                final anime = airing.where((item) => (item["broadcast"]["time"] != null) && item["broadcast"]["day"]=="Mondays").toList()[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Aired(anime),
                );
              },
            ),
          ),

// Selasa
          tile("Tuesday", airing.where((item) => (item["broadcast"]["time"] != null) && item["broadcast"]["day"]=="Tuesdays").toList()),
          SizedBox(height: 20,),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:  airing.where((item) => (item["broadcast"]["time"] != null) && item["broadcast"]["day"]=="Tuesdays").toList().length,
              itemBuilder: (context, index) {
                final anime = airing.where((item) => (item["broadcast"]["time"] != null) && item["broadcast"]["day"]=="Tuesdays").toList()[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Aired(anime),
                );
              },
            ),
          ),

// Rabu
          tile("Wednesday", airing.where((item) => (item["broadcast"]["time"] != null) && item["broadcast"]["day"]=="Wednesdays").toList()),
          SizedBox(height: 20,),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:  airing.where((item) => (item["broadcast"]["time"] != null) && item["broadcast"]["day"]=="Wednesdays").toList().length,
              itemBuilder: (context, index) {
                final anime = airing.where((item) => (item["broadcast"]["time"] != null) && item["broadcast"]["day"]=="Wednesdays").toList()[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Aired(anime),
                );
              },
            ),
          ),

// Kamis
          tile("Thursday", airing.where((item) => (item["broadcast"]["time"] != null) && item["broadcast"]["day"]=="Thursdays").toList()),
          SizedBox(height: 20,),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:  airing.where((item) => (item["broadcast"]["time"] != null) && item["broadcast"]["day"]=="Thursdays").toList().length,
              itemBuilder: (context, index) {
                final anime = airing.where((item) => (item["broadcast"]["time"] != null) && item["broadcast"]["day"]=="Thursdays").toList()[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Aired(anime),
                );
              },
            ),
          ),

// Jumat
          tile("Friday", airing.where((item) => (item["broadcast"]["time"] != null) && item["broadcast"]["day"]=="Fridays").toList()),
          SizedBox(height: 20,),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:  airing.where((item) => (item["broadcast"]["time"] != null) && item["broadcast"]["day"]=="Fridays").toList().length,
              itemBuilder: (context, index) {
                final anime = airing.where((item) => (item["broadcast"]["time"] != null) && item["broadcast"]["day"]=="Fridays").toList()[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Aired(anime),
                );
              },
            ),
          ),

// Sabtu
          tile("Saturday", airing.where((item) => (item["broadcast"]["time"] != null) && item["broadcast"]["day"]=="Saturdays").toList()),
          SizedBox(height: 20,),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:  airing.where((item) => (item["broadcast"]["time"] != null) && item["broadcast"]["day"]=="Saturdays").toList().length,
              itemBuilder: (context, index) {
                final anime = airing.where((item) => (item["broadcast"]["time"] != null) && item["broadcast"]["day"]=="Saturdays").toList()[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Aired(anime),
                );
              },
            ),
          ),

        ],
      ),
    );
  }

  Widget tile(String title, List<dynamic> data){
    return InkWell(
        onTap: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => viewmore(
                data: data,
                title: title,

              )));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(title ,
                style: TextStyle(
                    fontFamily: "Raleway",
                    color: fontcollor,
                    fontWeight: FontWeight.w400,
                    fontSize: 25
                ),),
            ),
            Icon(Icons.chevron_right,
              color: fontcollor,
              size: 35,)
          ],
        )
    );
  }

  Container Aired(Map<String, dynamic> animeData) {
    final title = animeData['title'] as String?;
    final imageUrl = animeData['images']['jpg']['image_url'] as String?;
    final day = animeData['broadcast']['day'] as String?;
    final time = animeData['broadcast']['time'] as String?;
    final timezone = animeData['broadcast']['timezone'] as String?;
    final string = animeData['broadcast']['string'] as String?;
    // ignore: unused_local_variable
    final score = animeData['score'] is int ? animeData['score'].toDouble() : animeData['score'];


    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(horizontal: 8),
      width: 370,
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => countschedule(
                title: title,
                day: day,
                time: time,
                imageUrl: imageUrl,
                timezone: timezone,
              )
              )
          );
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl!),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15)
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15)),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.85), // Warna gradasi pertama dengan transparansi 75%
                      Colors.transparent, // Warna gradasi kedua (transparan)
                    ],
                  ),
                ),
              )
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Opacity(
                opacity: 0.8, // Menetapkan transparansi sebesar 80%
                child: Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        color: Colors.yellow,
                      ),
                      SizedBox(width: 4),
                      Text(
                        time!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(

                    child: Text(
                      (title!.length <= 40) ? title.toUpperCase() : title.substring(0, 40).toUpperCase(),
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontFamily: "Oswald",
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ),
                ],
              )
            ),
            Positioned(
              bottom: 10,
              left: 0,
              child: Text(
              timezone!,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Raleway",
              ),
            ),
            ),
            Positioned(
              bottom: 35,
              left: 0,
              right: 0,
              child: Text(
              string!,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: "Raleway",
                  letterSpacing: 1,
                ),
            ),
            )
          ],
        )
      ),
    );


  }



}

