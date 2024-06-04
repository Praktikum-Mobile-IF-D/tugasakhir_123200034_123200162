import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'bottomnavbar.dart';
import 'choseprofile.dart';
import '../main.dart';
import '../model/user.dart';
import 'function/encrypt.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Box<UserModel> _myBox;
  late SharedPreferences _prefs;
  bool _rememberMe = true;

  final _formKey = GlobalKey<FormState>();
  String _inputUsername = "";
  String _inputPassword = "";
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _openBox();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
      });
    });
  }

  // @override
  // void dispose() {
  //   _myBox.close();
  //   super.dispose();
  // }

  void _openBox() async {
    await Hive.openBox<UserModel>(boxName);
    _myBox = Hive.box<UserModel>(boxName);
  }

  void _submit() {
    print("masuk");
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();

      if (!_myBox.containsKey(_inputUsername)) {
        // Check if username exists during login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username')),
        );
        return;
      }

      final user = _myBox.get(_inputUsername);
      print(user?.subs);
      final encryptedPassword = EncryptData.decryptAES(user!.password);
      if (_inputPassword == encryptedPassword) {
        // Save user's session
        Nameuser = _inputUsername;

        print(encryptedPassword);

        if (_rememberMe) {
          _prefs.setBool('isLoggedIn', true);
          _prefs.setString('username', _inputUsername);
        } else {
          _prefs.remove('isLoggedIn');

          _prefs.setString('username', _inputUsername);
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavbar()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid password')),
        );
      }
    }
  }

  void _register() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const choseprofile(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFF131313),
        body: Form(
          key: _formKey,
          child: Stack(
            children: [
              Container(
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
                    "assets/deku.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 250),
                height: 600,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  color: Background,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: Image.asset("assets/splash.png"),
                    ),
                    Text(
                      "Login",
                      style: TextStyle(
                          color: fontcollor,
                          fontSize: 35,
                          fontFamily: "Poppins"),
                    ),

                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.08,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                              labelText: 'Username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Set border radius
                              ),
                              labelStyle: TextStyle(
                                  color: fontcollor), // Set label text color
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.grey[400]!), // Set border color
                                borderRadius: BorderRadius.circular(
                                    30.0), // Set border radius
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Darkmode
                                        ? Colors.white
                                        : Colors
                                            .deepOrange), // Set focused border color
                                borderRadius: BorderRadius.circular(
                                    20.0), // Set border radius
                              ),
                            ),
                            style: TextStyle(color: fontcollor),
                            validator: (value) => value!.isEmpty
                                ? 'Please enter a username '
                                : null,
                            onSaved: (value) =>
                                _inputUsername = value!.toLowerCase(),
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.grey,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),

                              labelStyle: TextStyle(
                                  color: fontcollor), // Set label text color
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.grey[400]!), // Set border color
                                borderRadius: BorderRadius.circular(
                                    30.0), // Set border radius
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Darkmode
                                        ? Colors.white
                                        : Colors
                                            .deepOrange), // Set focused border color
                                borderRadius: BorderRadius.circular(
                                    20.0), // Set border radius
                              ),
                            ),
                            style: TextStyle(color: fontcollor),
                            validator: (value) => value!.isEmpty
                                ? 'Please enter a password'
                                : null,
                            onSaved: (value) => _inputPassword = value!,
                            obscureText: _obscureText,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 25.0),
                    Container(
                      width: 350,
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: Text(
                          'Login',
                          style: TextStyle(fontFamily: "Poppins"),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Darkmode
                                ? Color(0xFF865DFF)
                                : Colors
                                    .deepOrange // Set button background color
                            ),
                      ),
                    ),
                    CheckboxListTile(
                      title: Text(
                        "Remember me",
                        style: TextStyle(
                            color: fontcollor,
                            fontFamily: "Poppins"), // Set checkbox text color
                      ),
                      value: _rememberMe,
                      onChanged: (newValue) {
                        setState(() {
                          _rememberMe = newValue!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      tileColor: Colors.white,
                      activeColor:
                          Colors.green, // Set checkbox fill color when checked
                      checkColor: Colors.white, // Set checkbox border color
                    ),

                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?",
                            style: TextStyle(
                                color: fontcollor, fontFamily: "Poppins")),
                        InkWell(
                            onTap: _register,
                            child: Text(
                              "Sign in",
                              style: TextStyle(
                                  color: fontcollor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Poppins"),
                            ))
                      ],
                    )), // Set text color
                    SizedBox(height: 8.0),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
