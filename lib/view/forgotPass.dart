import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:email_otp/email_otp.dart';
import 'package:membership/view/login.dart';

import '../config/Myconfig.dart';
import 'insertOtp.dart';
import 'resetPassDialog.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  TextEditingController emailtxt = TextEditingController();
  TextEditingController resetPasstxt = TextEditingController();
  TextEditingController otp = TextEditingController();
  bool emailCheck = false;
  bool _obscureText = true;
  bool passCheck = false;
  bool otpCheck = true;
  bool emailValidate = true;
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 30,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              iconSize: 30, // Set the icon to a back arrow
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous screen
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: Column(
              children: [
                Container(
                  width: 400,
                  height: 300,
                  child: Lottie.asset(
                    "assets/forgotPass.json",
                    repeat: false,
                  ),
                ),
                Center(
                  child: Center(
                    child: Text(
                      "Please enter your email address!",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: emailtxt,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (text) {
                      setState(() {
                        // Update the border color based on text contains @gmail.com
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
                      fillColor:
                          Colors.grey.withOpacity(0.2), // Background color
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.black.withOpacity(0.5), // Set icon color
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        gapPadding: 10,
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.0),
                      ),
                      labelText: 'Email',
                      labelStyle:
                          TextStyle(color: Colors.black.withOpacity(0.5)),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      emailVerification();
                      EmailOTP.config(
                        appName: 'MyMemberLink',
                        otpType: OTPType.numeric,
                        emailTheme: EmailTheme.v6,
                        otpLength: 6,
                      );
                      if (emailValidate) {
                        await EmailOTP.sendOTP(email: emailtxt.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(46, 49, 146, 1),
                      foregroundColor: Colors.white,
                      shadowColor: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: Text('Submit'),
                  ),
                )
              ],
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
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Valid Email"),
            backgroundColor: Colors.green,
          ));
          Future.delayed(const Duration(milliseconds: 1500), () {
            otpInsert();
          });
          emailValidate = true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Email is not registered"),
            backgroundColor: Colors.red,
          ));
          emailValidate = false;
        }
      }
    });
  }

  void otpInsert() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return OtpVerificationDialog(
          onOtpVerified: (String otp) {
            resetPassword(); // Show the reset password dialog
          },
          onBack: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void resetPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ResetPasswordDialog(
          email: emailtxt.text,
          onPasswordReset: (context) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (content) => LoginScreen()),
            );
          },
        );
      },
    );
  }
}
