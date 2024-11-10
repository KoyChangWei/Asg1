import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:membership/config/Myconfig.dart';
import 'homePage.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'login_api.dart';
import 'dart:developer';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  TextEditingController usernametxt = new TextEditingController();
  TextEditingController emailtxt = new TextEditingController();
  TextEditingController passtxt = new TextEditingController();
  TextEditingController phonetxt = new TextEditingController();
  TextEditingController passRepeattxt = new TextEditingController();
  bool _obscureText = true;
  bool _obscureText2 = true;
  bool emailissuccess = false;
  bool passissuccess = false;
  bool usernameissuccess = false;
  bool phoneissuccess = false;
  bool repeatpassissuccess = false;
  bool emailExist = true;

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePageScreen()),
        );
      }
    } catch (exception) {
      log(exception.toString());
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("image/register.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    // border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(198, 234, 141, 1).withOpacity(0.7),
                        Color.fromRGBO(254, 144, 175, 1).withOpacity(0.3),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 20,
                        blurRadius: 29,
                        offset: Offset(10, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Create an account",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Fill your detail or continue with social media",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: usernametxt,
                          onChanged: (text) {
                            setState(() {
                              // Update the border color based on whether the text contains @gmail.com
                              usernameissuccess = text.isNotEmpty;
                            });
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              gapPadding: 10,
                              borderSide: BorderSide(
                                  color: usernameissuccess
                                      ? Colors.green
                                      : Colors.red,
                                  width: 3),
                            ),
                            filled: true, // Enables background color
                            fillColor: Colors.white
                                .withOpacity(0.2), // Background color
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black
                                  .withOpacity(0.5), // Set icon color
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              gapPadding: 10,
                            ),
                            labelText: 'Username',
                            labelStyle:
                                TextStyle(color: Colors.black.withOpacity(0.5)),
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: emailtxt,
                          onChanged: (text) {
                            setState(() {
                              // Update the border color based on whether the text contains @gmail.com
                              emailissuccess = text.contains("@gmail.com");
                            });
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              gapPadding: 10,
                              borderSide: BorderSide(
                                  color: emailissuccess
                                      ? Colors.green
                                      : Colors.red,
                                  width: 3),
                            ),

                            filled: true, // Enables background color
                            fillColor: Colors.white
                                .withOpacity(0.2), // Background color
                            prefixIcon: Icon(
                              Icons.email_rounded,
                              color: Colors.black
                                  .withOpacity(0.5), // Set icon color
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelText: 'Email',
                            labelStyle:
                                TextStyle(color: Colors.black.withOpacity(0.5)),
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: phonetxt,
                          keyboardType: TextInputType.phone,
                          onChanged: (text) {
                            setState(() {
                              // Update the border color based on whether the text contains @gmail.com
                              if (phonetxt.text.isNotEmpty &&
                                  phonetxt.text.length == 10) {
                                phoneissuccess = true;
                              } else {
                                phoneissuccess = false;
                              }
                            });
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              gapPadding: 10,
                              borderSide: BorderSide(
                                  color: phoneissuccess
                                      ? Colors.green
                                      : Colors.red,
                                  width: 3),
                            ),
                            filled: true, // Enables background color
                            fillColor: Colors.white
                                .withOpacity(0.2), // Background color
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Colors.black
                                  .withOpacity(0.5), // Set icon color
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              gapPadding: 10,
                            ),
                            labelText: 'Phone number',
                            labelStyle:
                                TextStyle(color: Colors.black.withOpacity(0.5)),
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: passtxt,
                          onChanged: (text) {
                            setState(() {});
                          },
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                gapPadding: 10,
                                borderSide: BorderSide(
                                    color: passissuccess
                                        ? Colors.green
                                        : Colors.red,
                                    width: 3),
                              ),
                              filled: true, // Enables background color
                              fillColor: Colors.white
                                  .withOpacity(0.3), // Background color
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                gapPadding: 10,
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.black
                                    .withOpacity(0.5), // Set icon color
                              ),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.5)),
                              suffixIcon: IconButton(
                                icon: _obscureText
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off),
                                color: Colors.black.withOpacity(0.5),
                                onPressed: () {
                                  _obscureText = !_obscureText;
                                  setState(() {});
                                },
                              )),
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        FlutterPwValidator(
                          defaultColor: Colors.black,
                          numericCharCount: 1,
                          specialCharCount: 1,
                          width: 320,
                          height: 80,
                          failureColor: Colors.black,
                          successColor: Color.fromRGBO(12, 135, 51, 1),
                          minLength:
                              8, // password should be at list 8 character length
                          onSuccess: () {
                            setState(() {
                              passissuccess = true;
                            });
                          },
                          onFail: () {
                            passissuccess = false;
                          },
                          controller: passtxt,
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: passRepeattxt,
                          obscureText: _obscureText2,
                          onChanged: (text) {
                            setState(() {
                              if (passRepeattxt.text == passtxt.text) {
                                repeatpassissuccess = true;
                              } else {
                                repeatpassissuccess = false;
                              }
                            });
                          },
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                gapPadding: 10,
                                borderSide: BorderSide(
                                    color: repeatpassissuccess
                                        ? Colors.green
                                        : Colors.red,
                                    width: 3),
                              ),
                              filled: true, // Enables background color
                              fillColor: Colors.white
                                  .withOpacity(0.3), // Background color
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                gapPadding: 10,
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.black
                                    .withOpacity(0.5), // Set icon color
                              ),
                              labelText: 'Repeat password',
                              labelStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.5)),
                              suffixIcon: IconButton(
                                icon: _obscureText2
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off),
                                color: Colors.black.withOpacity(0.5),
                                onPressed: () {
                                  _obscureText2 = !_obscureText2;
                                  setState(() {});
                                },
                              )),
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: MaterialButton(
                            onPressed: signUp,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            height: 50,
                            color: Color.fromRGBO(254, 144, 175, 1),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.black,
                                thickness: 1,
                                endIndent: 10,
                              ),
                            ),
                            Text(
                              "or",
                              style: TextStyle(color: Colors.black),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.black,
                                thickness: 1,
                                indent: 10,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 28,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: MaterialButton(
                            onPressed: googleSignIn,
                            color: Color.fromRGBO(198, 234, 141, 1),
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
                                    color: Colors.black,
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
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Already have account??",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  "Log in",
                                  style: TextStyle(
                                    color: Color.fromRGBO(254, 144, 175, 1),
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

  void emailVerification() {
    http.post(Uri.parse("${Myconfig.server}/mymemberlink/emailCheck.php"),
        body: {"email": emailtxt.text}).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          emailExist = true;
        } else {
          emailExist = false;
        }
      }
    });
  }

  void signUp() {
    String username = usernametxt.text;
    String email = emailtxt.text;
    String password = passtxt.text;
    String phoneNo = phonetxt.text;

    if (!(usernameissuccess &&
        emailissuccess &&
        passissuccess &&
        phoneissuccess)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please ensure all fields are filled correctly"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    emailVerification(); //Verify email

    if (!emailExist) {
      http.post(Uri.parse("${Myconfig.server}/mymemberlink/registerdb.php"),
          body: {
            "email": email,
            "password": password,
            "username": username,
            "phoneNo": phoneNo,
          }).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['status'] == "success") {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Successfully registered"),
              backgroundColor: Colors.green,
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Registration failed"),
              backgroundColor: Colors.red,
            ));
          }
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email has already been registered"),
        backgroundColor: Colors.red,
      ));
    }
    setState(() {
      
    });
  }
}
