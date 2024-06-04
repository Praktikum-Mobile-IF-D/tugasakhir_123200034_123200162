import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:hive/hive.dart';
import 'login.dart';
import '../model/user.dart';
import '../main.dart';
import 'function/encrypt.dart';

class RegisterPage extends StatefulWidget {
  final String image;
  const RegisterPage({Key? key ,required this.image}) : super(key: key);


  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _formKey = GlobalKey<FormState>();
  String _inputUsername = "";
  String _inputPassword = "";
  String _inputYourname = "";
  bool _obscureText = true;
  // ignore: unused_field
  late final encrypt.Key _key;
  // ignore: unused_field
  final _iv = encrypt.IV.fromLength(16);
  late Box<UserModel> _myBox;
  @override
  void initState() {
    super.initState();
    _myBox = Hive.box(boxName);
  }


  void _submit() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();

      // Check if the username is already used
      if (_myBox.containsKey(_inputUsername)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Username already taken')),
        );
        return;
      }

      final encryptedPassword = EncryptData.encryptAES(_inputPassword);
      final user = UserModel(password: encryptedPassword, Name: _inputYourname, image: widget.image ,subs:false);
print(encryptedPassword);
      _myBox.put(_inputUsername, user);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User registered successfully.')),
      );
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:Background,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color:fontcollor, // Atur warna ikon kembali (back) di sini
        ),

        backgroundColor: Background,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 80,),
              Container(
                width: 70,
                height: 70,
                child:
                Image.asset("assets/splash.png"),
              ),
              Text("Register" ,
              style: TextStyle(
                fontSize: 50,
                color: fontcollor,
                fontFamily: "Raleway"
              ),),
              SizedBox(height: 30,),
              Container(

                width: MediaQuery.of(context).size.width/1.09,
                child:
                Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person,
                          color: Colors.grey,),
                        labelText: 'YourName',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0), // Set border radius
                        ),
                        labelStyle: TextStyle(color:fontcollor), // Set label text color
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400]!), // Set border color
                          borderRadius: BorderRadius.circular(30.0), // Set border radius
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Darkmode? Colors.white :Colors.deepOrange), // Set focused border color
                          borderRadius: BorderRadius.circular(20.0), // Set border radius
                        ),
                      ),
                      style: TextStyle(color: fontcollor),
                      validator: (value) =>
                      value!.isEmpty ? 'Please enter a Your Name' : null,
                      onSaved: (value) => _inputYourname = value!,
                    ),
                    SizedBox(height: 30,),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person,
                          color: Colors.grey,),
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0), // Set border radius
                        ),
                        labelStyle: TextStyle(color: fontcollor), // Set label text color
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400]!), // Set border color
                          borderRadius: BorderRadius.circular(30.0), // Set border radius
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Darkmode? Colors.white :Colors.deepOrange), // Set focused border color
                          borderRadius: BorderRadius.circular(20.0), // Set border radius
                        ),
                      ),
                      style: TextStyle(color: fontcollor),
                      validator: (value) =>
                      value!.isEmpty ? 'Please enter a username' : null,
                      onSaved: (value) => _inputUsername = value!.toLowerCase(),
                    ),
                    SizedBox(height: 30,),
                    TextFormField(

                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400]!), // Set border color
                          borderRadius: BorderRadius.circular(30.0), // Set border radius
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Darkmode? Colors.white :Colors.deepOrange), // Set focused border color
                          borderRadius: BorderRadius.circular(20.0), // Set border radius
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: fontcollor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0), // Set border radius
                        ),

                        prefixIcon: Icon(Icons.lock,color: Colors.grey,),

                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(color: fontcollor),
                      validator: (value) =>
                      value!.isEmpty ? 'Please enter a password' : null,
                      onSaved: (value) => _inputPassword = value!,
                      obscureText: _obscureText,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50,),
              Container(

                width: 350,

                child:
                ElevatedButton(
                  onPressed: _submit,
                  child: Text('Register',style: TextStyle(
                    fontSize: 19,
                      fontFamily: "Poppins"
                  ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor:Darkmode? Color(0xFF865DFF) :Colors.deepOrange // Set button background color
                  ),
                ),
              ),

            ],
          ),
        ) ,
      )
    );
  }

 
}
