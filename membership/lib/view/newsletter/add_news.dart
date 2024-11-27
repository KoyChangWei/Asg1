import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../config/Myconfig.dart';

class NewNewsScreen extends StatefulWidget {
  const NewNewsScreen({super.key});

  @override
  State<NewNewsScreen> createState() => _NewNewsScreenState();
}

class _NewNewsScreenState extends State<NewNewsScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  late double screenWidth, screenHeight;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 161, 212, 235),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Set your desired color here
        ),
        title: const Text(
          "New Newsletter",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Title",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow color
                      blurRadius: 8, // Blur radius
                      offset: const Offset(
                          10, 10), // Shadow offset to the bottom-right
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 6,
                      offset: const Offset(-4, -4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: "Enter your title",
                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      gapPadding: 10,
                      borderSide:
                          const BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                    filled: true, // Enables background color
                    fillColor: Colors.blue.withOpacity(0.4), // Background color
                    prefixIcon: Icon(
                      Icons.title,
                      color: Colors.black.withOpacity(0.5), // Set icon color
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      gapPadding: 10,
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Description",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow color
                      blurRadius: 8, // Blur radius
                      offset: const Offset(
                          10, 10), // Shadow offset to the bottom-right
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 6,
                      offset: const Offset(-4, -4),
                    ),
                  ],
                ),
                height: screenHeight * 0.5,
                child: TextField(
                  controller: detailsController,
                  decoration: InputDecoration(
                    hintText: "Enter your description",
                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      gapPadding: 10,
                      borderSide:
                          const BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      gapPadding: 10,
                      borderSide:
                          const BorderSide(color: Colors.white, width: 1.0),
                    ),
                    filled: true,
                    fillColor: Colors.blue.withOpacity(0.3),
                  ),
                  maxLines: screenHeight ~/ 35,
                  style: const TextStyle(color: Colors.black), // Text color
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                onPressed: onInsertNewsDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  elevation: 10,
                  padding: const EdgeInsets.symmetric(
                      vertical: 14), // Increased padding for better appearance
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  shadowColor: Colors.white.withOpacity(1.0), // Shadow color
                ),
                icon: const Icon(
                  Icons.add, // Add icon for inserting news
                  color: Colors.white,
                  size: 24, // Icon size
                ),
                label: const Text(
                  "Insert News",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16, // Font size
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onInsertNewsDialog() {
    if (titleController.text.isEmpty || detailsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter title and details"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Colors.white, // White background for the dialog
          title: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              "Confirmation Insert Dialog",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          content: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Are you sure you want to insert this newsletter?",
              style: TextStyle(fontSize: 16),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text(
                    "Yes",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    insertNews();
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 20),
                TextButton(
                  child: const Text(
                    "No",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void insertNews() {
    String title = titleController.text;
    String details = detailsController.text;
    http.post(Uri.parse("${Myconfig.server}/mymemberlink/insert_news.php"),
        body: {"title": title, "details": details}).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Insert Success"),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Insert Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
