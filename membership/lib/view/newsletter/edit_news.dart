import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../config/Myconfig.dart';
import '../../model/news.dart';

class EditNewsScreen extends StatefulWidget {
  final News news;
  const EditNewsScreen({super.key, required this.news});

  @override
  State<EditNewsScreen> createState() => _EditNewsState();
}

class _EditNewsState extends State<EditNewsScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.news.newsTitle.toString();
    detailsController.text = widget.news.newsDetails.toString();
  }

  late double screenWidth, screenHeight;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Set your desired color here
        ),
        title: const Text(
          "Edit Newsletter",
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      gapPadding: 10,
                      borderSide:
                          const BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                    // Regular border
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
                onPressed: onUpdateNewsDialog,
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
                  Icons.update, // Update icon
                  color: Colors.white,
                  size: 24, // Icon size
                ),
                label: const Text(
                  "Update News",
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

  void onUpdateNewsDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Container(
              padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text("Confirmation Update Dialog",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,



                ),
                )),
            content: const Text("Are you sure you want to update this news?",
            style: TextStyle(
              fontSize: 17, // Font size
              color: Colors.black, // Text color
            ),),
            actions: [
              TextButton(
                  onPressed: () {
                    updateNews();
                    Navigator.pop(context);
                  },
                  child: const Text("Yes")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No"))
            ],
          );
        });
  }

  void updateNews() {
    String title = titleController.text.toString();
    String details = detailsController.text.toString();

    http.post(Uri.parse("${Myconfig.server}/mymemberlink/update_news.php"),
        body: {
          "newsid": widget.news.newsId.toString(),
          "title": title,
          "details": details
        }).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Update Success"),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Update Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
