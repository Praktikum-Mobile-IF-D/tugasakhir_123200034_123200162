import 'package:flutter/material.dart';
import 'register.dart';

import 'main.dart';

class choseprofile extends StatelessWidget {
  const choseprofile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> image=["assets/tanjiro.png","assets/deku.jpg","assets/gojo.jpg","assets/luffy.jpg","assets/naruto.png",];
    return Scaffold(
      backgroundColor: Background,
      appBar: AppBar(

        iconTheme: IconThemeData(
          color:fontcollor, // Atur warna ikon kembali (back) di sini
        ),
        backgroundColor: Background,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Welcome",
              style: TextStyle(
                fontFamily: "Raleway",
                fontSize: 40,
                color: fontcollor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              "Choose Your Profile",
              style: TextStyle(
                fontFamily: "Raleway",
                fontSize: 30,
                color:fontcollor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20,),
          Container(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                for (int i = 0; i < image.length; i++)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  RegisterPage(image: image[i]),
                          ),
                        );
                      },
                      child:Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3), // Atur offset bayangan jika diperlukan
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(image[i]),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          )



        ],
      ),
    );
  }
}

