import 'package:flutter/material.dart';
import 'login_api.dart';
import 'dart:developer';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  Future googleSignOut() async {
    try {
      await GoogleSignInService.logout();
      log('Sign Out Success');
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Sign Out Success')));
      }
      Navigator.pop(context);
    } catch (exception) {
      log(exception.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Sign Out Failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 200),
        child: Column(
          children: [
            Center(
              child: Text(
                "Home Page Screen",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                onPressed: googleSignOut,
                child: Text('Sign Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
