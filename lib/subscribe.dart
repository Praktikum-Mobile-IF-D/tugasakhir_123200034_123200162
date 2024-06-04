import 'package:flag/flag_enum.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottomnavbar.dart';
import 'main.dart';
import 'model/user.dart';

class SubscribePage extends StatefulWidget {
  @override
  State<SubscribePage> createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {
  @override
  // ignore: override_on_non_overriding_member
  String _currency = 'USD';
  double price =2.99;
  // ignore: unused_field
  late SharedPreferences _prefs;
  late String username = '';
  late Box<UserModel> _myBox;
  @override
  void initState() {
    super.initState();
    _openBox();
    loadUsername().then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openBox());
    });

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
      });
    });

  }
  void _openBox() async {
    await Hive.openBox<UserModel>(boxName);
    _myBox = Hive.box<UserModel>(boxName);
  }

  Future<void> loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _prefs = prefs;
      username = prefs.getString('username') ?? '';
    });
  }

  void _updateFavoriteStatus() {
    final userModel = _myBox.get(username);
    if (userModel != null) {
      userModel.subs = true; // Memperbarui nilai subs menjadi true
      userModel.save(); // Menyimpan perubahan ke database Hive
      _myBox.put(username, userModel); // Mengganti objek lama dengan objek yang diperbarui
      print("Berhasil menambahkan ke Subscribe");
    }
  }



  Widget build(BuildContext context) {
    final user = _myBox.get(username);
    return Scaffold(
      backgroundColor: Color(0xFF131313),
      body:ListView(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.zero,
                height: 399,
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.transparent],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.asset(
                    "assets/nami.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 503,
                decoration: BoxDecoration(
                    color: Background,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
                ),
                margin: EdgeInsets.only(top:340),
                child: user?.subs ==false ? Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20,top: 20),
                      alignment: Alignment.topLeft,
                      child:
                      InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.arrow_back,
                          color: fontcollor,
                          size: 30,),
                      ),
                    ),

                    Text(
                      'AniVerse Subscription',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: fontcollor,fontFamily: "Poppins"),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Unlock premium content, exclusive features, and more!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: fontcollor,fontFamily: "Poppins"),
                    ),
                    SizedBox(height: 20),
                    advantage( 'Access to exclusive anime series'),
                    advantage( 'Early access to new episodes'),
                    advantage( 'Get verified account'),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [

                            Text(
                              price.toString(),
                              style: TextStyle(
                                fontSize: 23,
                                color: fontcollor,
                                fontFamily: "Poppins",
                              ),
                            ),
                            SizedBox(
                              width:20 ,
                            ),
                            DropdownButton<String>(
                              value: _currency,
                              items: <DropdownMenuItem<String>>[
                                DropdownMenuItem(
                                    value: 'USD',
                                    child:Row(
                                      children: [
                                        Text(
                                          'USD',
                                          style: TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
                                        ),
                                        SizedBox(width: 10,),
                                        Flag.fromCode(
                                          FlagsCode.US,
                                          height: 20,
                                          width: 30,
                                          fit: BoxFit.fill,
                                        ),
                                      ],
                                    )
                                ),
                                DropdownMenuItem(
                                    value: 'EUR',
                                    child:Row(
                                      children: [
                                        Text(
                                          'EUR',
                                          style: TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
                                        ),
                                        SizedBox(width: 10,),
                                        Flag.fromCode(
                                          FlagsCode.DE,
                                          height: 20,
                                          width: 30,
                                          fit: BoxFit.fill,
                                        ),
                                      ],
                                    )
                                ),
                                DropdownMenuItem(
                                    value: 'IDR',
                                    child: Row(
                                      children: [
                                        Text(
                                          'IDR',
                                          style: TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
                                        ),
                                        SizedBox(width: 10,),
                                        Flag.fromCode(
                                          FlagsCode.ID,
                                          height: 20,
                                          width: 30,
                                          fit: BoxFit.fill,
                                        ),
                                      ],
                                    )
                                ), DropdownMenuItem(
                                    value: 'JPY',
                                    child: Row(
                                      children: [
                                        Text(
                                          'JPY',
                                          style: TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
                                        ),
                                        SizedBox(width: 10,),
                                        Flag.fromCode(
                                          FlagsCode.JP,
                                          height: 20,
                                          width: 30,
                                          fit: BoxFit.fill,
                                        ),
                                      ],
                                    )
                                ),
                              ],
                              onChanged: (String? value) {
                                if (value != null) {
                                  setState(() {
                                    _currency = value;
                                    if(_currency=="USD"){
                                      price=2.99;
                                    }
                                    else if(_currency=="IDR"){
                                      price=(2.99*14936).roundToDouble();
                                    }
                                    else if(_currency=="EUR"){
                                      price=(2.99*0.92).roundToDouble();
                                    }
                                    else if(_currency=="JPY"){
                                      price=(2.99*137.97).roundToDouble();
                                    }
                                  });

                                }
                              },
                              style: TextStyle(color: Colors.white), // Ubah warna teks dropdown menjadi putih
                              dropdownColor: Colors.grey[800], // Ubah warna latar belakang dropdown
                              underline: Container(), // Hilangkan garis bawah
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:Darkmode? Color(0xFF865DFF) :Colors.deepOrange// Set button background color
                      ),
                      onPressed: () {
                        _updateFavoriteStatus();
                        final snackBar = SnackBar(
                          content: Text('You Have Subscribed'), // Pesan yang akan ditampilkan di Snackbar
                          duration: Duration(seconds: 2),
                          // Durasi tampilan Snackbar (dalam detik)
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomNavbar()), (route) => false);
                      },
                      child: Text(
                        'Subscribe Now',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ) : Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20,top: 20),
                      alignment: Alignment.topLeft,
                      child:
                      InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.arrow_back,
                          color: fontcollor,
                          size: 30,),
                      ),
                    ),
                    Container(

                      height: 430,

                      child: Column (

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Thank You',
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: fontcollor,fontFamily: "Poppins"),
                          ),
                          Text(
                            'You Have Subscribe',
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: fontcollor,fontFamily: "Poppins"),
                          ),
                          SizedBox(height: 30,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:Darkmode? Color(0xFF865DFF) :Colors.deepOrange// Set button background color
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Back',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),


                    SizedBox(height: 10),


                    SizedBox(height: 10),



                  ],
                ),
              )
            ],
          ),


        ],
      ),

    );
  }
  Widget advantage (String data){
    return  ListTile(
      leading: Icon(
        Icons.check,
        color: Colors.green,
      ),
      title: Text(
        data,
        style: TextStyle(fontSize: 20,color: fontcollor,fontFamily: "Poppins"),
      ),
    );
  }
}