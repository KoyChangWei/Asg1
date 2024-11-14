import 'package:flutter/material.dart';

import '../config/Myconfig.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ResetPasswordDialog extends StatefulWidget {
  final String email;
  final Function(BuildContext) onPasswordReset;

  const ResetPasswordDialog({
    Key? key,
    required this.email,
    required this.onPasswordReset,
  }) : super(key: key);

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final TextEditingController resetPasstxt = TextEditingController();
  bool _obscureText = true;
  bool passCheck = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Reset Password",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            SizedBox(height: 20),
            TextField(
              controller: resetPasstxt,
              obscureText: _obscureText,
              onChanged: (text) {
                setState(() {
                  passCheck = text.length >= 8 &&
                      RegExp(r'[0-9]').hasMatch(text) &&
                      RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(text);
                });
              },
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  gapPadding: 10,
                  borderSide: BorderSide(
                    color: passCheck ? Colors.green : Colors.red,
                    width: 3,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  gapPadding: 10,
                  borderSide: const BorderSide(color: Colors.black, width: 1.0),
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black.withOpacity(0.5),
                ),
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                if (passCheck) {
                  final response = await http.post(
                    Uri.parse("${Myconfig.server}/mymemberlink/resetPass.php"),
                    body: {
                      "email": widget.email,
                      "password": resetPasstxt.text,
                    },
                  );

                  if (response.statusCode == 200) {
                    var data = jsonDecode(response.body);
                    if (data['status'] == "success") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Reset Password Success"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      widget.onPasswordReset(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Reset Password Failed"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              child: Text("Confirm Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        ),
      ),
    );
  }
}
