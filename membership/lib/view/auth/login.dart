import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:membership/config/Myconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../homePage.dart';
import 'forgotPass.dart';
import 'login_api.dart';
import 'register.dart';
import 'dart:developer';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  TextEditingController emailtxt = new TextEditingController();
  TextEditingController passtxt = new TextEditingController();
  bool rememberMe = false;
  bool _obscureText = true;
  bool emailCheck = false;
  bool passCheck = false;
 

  
  Future googleSignIn() async {
    try {
      final user = await GoogleSignInService.login();
      await user?.authentication;
      log(user!.displayName.toString());
      log(user.email);
      log(user.id);
      log(user.photoUrl.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Column(
          children: [
            Text(
                "Name: ${user.displayName}\nEmail: ${user.email}\nId: ${user.id}\nPhotoUrl: ${user.photoUrl}"),
            Image.network(user.photoUrl.toString()),
          ],
        )));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePageScreen()),
        );
      }
    } catch (exception) {
      log(exception.toString());
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    loadPref();
  }
  

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("image/login.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: 350,
                  height: 600,
                  decoration: BoxDecoration(
                    // border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color.fromRGBO(46, 49, 146, 1).withOpacity(0.7),
                        const Color.fromRGBO(27, 255, 255, 1).withOpacity(0.3),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 20,
                        blurRadius: 29,
                        offset: const Offset(10, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Login to your account",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "Enter your detail to login",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: emailtxt,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (text) {
                            setState(() {
                              // Update the border color based on whether the text contains @gmail.com
                              emailCheck = text.contains("@gmail.com");
                            });
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              gapPadding: 10,
                              borderSide: BorderSide(
                                  color: emailCheck ? Colors.green : Colors.red,
                                  width: 3),
                            ),
                            filled: true, // Enables background color
                            fillColor: Colors.grey
                                .withOpacity(0.2), // Background color
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.white
                                  .withOpacity(0.5), // Set icon color
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              gapPadding: 10,
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0),
                            ),
                            labelText: 'Email',
                            labelStyle:
                                TextStyle(color: Colors.white.withOpacity(0.5)),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: passtxt,
                          obscureText: _obscureText,
                          onChanged: (text) {
                            setState(() {
                              // Update the border color based on whether the text contains @gmail.com
                              if (passtxt.text.length >= 8 &&
                                  RegExp(r'[0-9]').hasMatch(passtxt
                                      .text) && // Check for at least one numeric character
                                  RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                      .hasMatch(passtxt.text)) {
                                // Check for at least one special character
                                passCheck = true;
                              } else {
                                passCheck = false;
                              }
                            });
                          },
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                gapPadding: 10,
                                borderSide: BorderSide(
                                    color:
                                        passCheck ? Colors.green : Colors.red,
                                    width: 3),
                              ),
                              filled: true, // Enables background color
                              fillColor: Colors.grey
                                  .withOpacity(0.3), // Background color
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                gapPadding: 10,
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1.0),
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.white
                                    .withOpacity(0.5), // Set icon color
                              ),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5)),
                              suffixIcon: IconButton(
                                icon: _obscureText
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                                color: Colors.white.withOpacity(0.5),
                                onPressed: () {
                                  _obscureText = !_obscureText;
                                  setState(() {});
                                },
                              )),
                          style: const TextStyle(color: Colors.white),
                        ),
                        Row(
                          children: [
                            const Text("Remember Me",
                                style: TextStyle(color: Colors.grey)),
                            Checkbox(
                              value: rememberMe,
                              onChanged: (bool? value) {
                                setState(() {
                                  String email = emailtxt.text;
                                  String pass = passtxt.text;
                                  if (value!) {
                                    if (email.isNotEmpty && pass.isNotEmpty) {
                                      sharedPrefs(value, email, pass);
                                    } else {
                                      rememberMe = false;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "Please enter your credentials"),
                                        backgroundColor: Colors.red,
                                      ));
                                      return;
                                    }
                                  } else {
                                    email = "";
                                    pass = "";
                                    sharedPrefs(value, email, pass);
                                  }
                                  rememberMe = value ?? false;
                                  setState(() {});
                                });
                              },
                              activeColor: const Color.fromRGBO(27, 255, 255, 1),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: MaterialButton(
                            onPressed: login,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            height: 50,
                            color: const Color.fromRGBO(27, 255, 255, 1),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (content) => const ForgotPasswordScreen()));

                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 200),
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Color.fromRGBO(27, 255, 255, 1),
                                fontSize: 12,
                                shadows: [
                                  Shadow(
                                    blurRadius: 1.0,
                                    color: Colors.black,
                                    offset: Offset(2, 2.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.white,
                                thickness: 1,
                                endIndent:
                                    10, // Space between divider and "OR" text
                              ),
                            ),
                            Text(
                              "or",
                              style: TextStyle(color: Colors.white),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.white,
                                thickness: 1,
                                indent:
                                    10, // Space between divider and "OR" text
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: MaterialButton(
                            onPressed: googleSignIn,
                            color: const Color.fromRGBO(46, 49, 146, 1),
                            height: 50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'image/google.png', // Use your asset path here
                                  height: 20,
                                  width: 20,
                                ),
                                const SizedBox(
                                    width: 10), // Space between icon and text
                                const Text(
                                  "Google",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40, left: 55),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) => const RegisterScreen()));
                            },
                            child: const Row(
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  "Sign up",
                                  style: TextStyle(
                                    color: Color.fromRGBO(27, 255, 255, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 1.0,
                                        color: Colors.black,
                                        offset: Offset(2, 2.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void login() {
    String email = emailtxt.text;
    String password = passtxt.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "Please fill in  your detail!"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    http.post(Uri.parse("${Myconfig.server}/mymemberlink/logindb.php"),
        body: {"email": email, "password": password}).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Success"),
            backgroundColor: Colors.green,
          ));
          Navigator.push(context,
              MaterialPageRoute(builder: (content) => const HomePageScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }

  Future<void> sharedPrefs(bool value, String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      prefs.setString("email", email);
      prefs.setString("password", password);
      prefs.setBool("RememberMe", value);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Your email and password have saved"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ));
    } else {
      prefs.setString("email", email);
      prefs.setString("password", password);
      emailtxt.text = "";
      passtxt.text = "";
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Your email and password have deleted"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ));
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailtxt.text = prefs.getString("email")!;
    passtxt.text = prefs.getString("password")!;
    rememberMe = prefs.getBool("RememberMe")!;
    setState(() {});
  }
}
