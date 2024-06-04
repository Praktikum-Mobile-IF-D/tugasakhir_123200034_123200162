import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';

import 'main.dart';

class countschedule extends StatefulWidget {
  final String? title;
  final String? imageUrl;
  final String? time;
  final String? day;
  final String? timezone;

  const countschedule({Key? key,
    this.title,
    this.imageUrl,
    this.time,
    this.day,
    this.timezone
  }) : super(key: key);

  @override
  State<countschedule> createState() => _countscheduleState();
}


class _countscheduleState extends State<countschedule> {
  DateTime targetDateTime = DateTime.now(); // Inisialisasi dengan waktu saat ini
  Timer? timer;
  Duration countdownDuration = Duration();
  DateTime _dateTime = DateTime.now();
  String dropdownvalue = 'WIB';
  // List of items in our dropdown menu
  var items = ["UTC",'WIB', 'WITA', 'WIT'];
  @override
  void initState() {
    super.initState();
    setTargetDateTime(widget.day!,widget.time!);
    startTimer();
  }

  void setTargetDateTime(String Temp,String tim) {
    final now = DateTime.now();
    final currentWeekday = now.weekday;
    final targetWeekday = getTargetWeekday(Temp);
    // Menghitung selisih hari hingga targetWeekday
    final daysUntilTarget = (targetWeekday - currentWeekday + 7) % 7;
    // Membuat targetDateTime berdasarkan hari dan waktu yang ditentukan
    targetDateTime = DateTime(

      now.year,
      now.month,
      now.day + daysUntilTarget ,
      int.parse(tim.split(":")[0]),
      int.parse(tim.split(":")[1]),
    );

  }
  int getTargetWeekday( String temp) {
    switch (temp) {
      case "Sundays":
        return DateTime.sunday;
      case "Mondays":
        return DateTime.monday;
      case "Tuesdays":
        return DateTime.tuesday;
      case "Wednesdays":
        return DateTime.wednesday;
      case "Thursdays":
        return DateTime.thursday;
      case "Fridays":
        return DateTime.friday;
      case "Saturdays":
        return DateTime.saturday;
      default:
        return DateTime.sunday;
    }
  }
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        final now = DateTime.now();
        if (now.isBefore(targetDateTime)) {
          countdownDuration = targetDateTime.difference(now);
        } else {
          // Waktu tujuan countdown telah lewat
          countdownDuration = Duration.zero;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  String getDays(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }
    final days = duration.inDays;
    return '$days';
  }
  String getHours(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }
    final hours = twoDigits(duration.inHours.remainder(24));

    return '$hours';

  }
  String getMin(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    return '$minutes';
  }
  String getSec(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      body: ListView(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20,left: 10),
                alignment: Alignment.topLeft,
                child:
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_outlined,
                    size: 30,
                    color: fontcollor,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20,right: 10 ),
                child: Text(
                  DateFormat.yMMMEd().format(_dateTime),
                  style: TextStyle(fontSize: 20,color: fontcollor,fontFamily: "Poppins"),
                ),
              ),
            ],
          ),
          Container(
            height: 120,width: 100,
            decoration: BoxDecoration(


            ),
            margin: EdgeInsets.only(top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
                  _dateTime = DateTime.now().toUtc();
                  String formattedTime =
                      (dropdownvalue == 'WIT')? DateFormat('HH:mm:ss').format(_dateTime.add(Duration(hours: 9)))
                      : (dropdownvalue == 'WIB') ? DateFormat('HH:mm:ss ').format(_dateTime.add(Duration(hours: 7)))
                      : (dropdownvalue == 'UTC') ? DateFormat('HH:mm:ss ').format(_dateTime)
                      : DateFormat('HH:mm:ss ').format(_dateTime.add(Duration(hours: 8)));
                  List<String> timeComponents = formattedTime.split(':');
                  return Row(
                    children: timeComponents.map((component) {
                      return Container(
                        alignment: Alignment.center,
                        height: 75,
                        width: 75,
                        margin: EdgeInsets.symmetric(horizontal: 4), // Jarak antara komponen waktu
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Darkmode ?  Colors.white : Colors.black87,
                          // Latar belakang putih
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          component,
                          style: TextStyle(fontSize:40, color: Darkmode ?Colors.black: Colors.white,
                              fontFamily: "Poppins"), // Ukuran font diperbesar
                        ),
                      );
                    }).toList(),
                  );
                }),
                SizedBox(
                  width: 15,
                ),
                Container(
                  alignment: Alignment.center,
                  width: 85,
                  height: 52,
                  decoration: BoxDecoration
                    (
                    borderRadius: BorderRadius.circular(8),
                    color: Darkmode ?  Colors.white : Colors.black87,
                  ),
                  child: DropdownButton(
                    dropdownColor:   Darkmode ?  Colors.white : Colors.black87,
                    iconEnabledColor: Darkmode? Colors.black: Colors.white, // Mengubah warna ikon menjadi hitam
                    value: dropdownvalue,
                    borderRadius: BorderRadius.circular(8),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    // Mengubah warna dan ukuran font
                    underline: Container(), // Menghilangkan garis bawah

                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: TextStyle(color: Darkmode? Colors.black: Colors.white,
                              fontFamily: "Poppins",
                          fontSize: 20),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ),

              ],
            ),
          ),
          Stack(
            children: [
              Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.imageUrl!),
                    fit: BoxFit.cover,
                  ),

                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 800,
                  decoration: BoxDecoration(

                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.9), // Warna gradasi pertama dengan transparansi 75%
                        Colors.transparent, // Warna gradasi kedua (transparan)
                      ],
                    ),
                  ),
                ),
              ),


              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: 30,),
                    count(getDays(countdownDuration), "DAYS"),
                    count(getHours(countdownDuration), "HOURS"),
                    count(getMin(countdownDuration), "MIN"),
                    count(getSec(countdownDuration), "SECS"),
                    SizedBox(width: 30,),
                  ],
                ),
              ),
              Positioned(
                bottom: 140,
                left: 0,
                right: 0,
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(Icons.calendar_month_sharp,
                         color: Colors.white,),
                         Text(
                           " ${widget.day?.toUpperCase()} , ${widget.time?.toUpperCase()} ${widget.timezone?.toUpperCase()}",
                           style: TextStyle(
                             fontSize: 20,
                             color: Colors.white,
                             fontFamily: "Oswald",
                             letterSpacing: 1,
                           ),
                         ),
                       ],
                     ),
                      Text(
                        (widget.title!.length <= 40) ? widget.title!.toUpperCase() : widget.title!.substring(0, 40).toUpperCase(),
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontFamily: "Oswald",
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                ),
              ),


            ],
          ),
        ],
      ),

    );
  }


  Widget count(String time, String title){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Text(
            time,
            style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontFamily: "Oswald",
                letterSpacing: 1,
                fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontFamily: "Oswald",
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

