import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';

import '../../config/Myconfig.dart';
import '../../model/news.dart';
import '../drawer/myDrawer.dart';
import 'add_news.dart';
import 'edit_news.dart';

class NewsLetterScreen extends StatefulWidget {
  const NewsLetterScreen({super.key});

  @override
  State<NewsLetterScreen> createState() => _NewsLetterScreenState();
}

class _NewsLetterScreenState extends State<NewsLetterScreen> {
  List<News> newsList = [];
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  late double screenWidth, screenHeight;
  var color;
  final List<Color> cardColors = [
    Colors.blue[200]!,
    Colors.blue[400]!,
    Colors.blue[600]!,
  ];
  TextEditingController newslettertxt = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNewsData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 170, 193, 233),
      appBar: AppBar(
        title: const Text("Newsletter"),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                newslettertxt.clear();
                loadNewsData();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Stack(
        children: [
          newsList.isEmpty
              ? const Center(
                  child: Text("Loading..."),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10), // Add horizontal padding

                      // TextField for input
                      child: Expanded(
                        child: TextField(
                          controller: newslettertxt,
                          keyboardType: TextInputType.text,
                          onChanged: (text) {
                            loadNewsData();
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2.0),
                            ),
                            filled: true,
                            fillColor: Colors.white, // Background color
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.black, // Set icon color
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.cancel, // "x" button to clear text
                                color: Colors.black,
                              ),
                              onPressed: () {
                                // Clear the text when the "x" button is pressed
                                newslettertxt.clear();
                                loadNewsData();
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1.0),
                            ),
                            labelText: 'Search',
                            labelStyle: const TextStyle(color: Colors.black),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                          "Page: $curpage/$numofpage Records: $numofresult"),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: newsList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Card(
                                color: cardColors[index % 3],
                                elevation: 10.0,

                                shadowColor: Colors.blue
                                    .withOpacity(0.5), // Customize shadow color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      15.0), // Rounded corners
                                  side: const BorderSide(
                                    color: Colors.blueGrey, // Border color
                                    width: 1.0, // Border width
                                  ),
                                ),

                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        truncateString(
                                            newsList[index]
                                                .newsTitle
                                                .toString(),
                                            30),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        df.format(DateTime.parse(newsList[index]
                                            .newsDate
                                            .toString())),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    truncateString(
                                        newsList[index].newsDetails.toString(),
                                        100),
                                    textAlign: TextAlign.justify,
                                  ),

                                  // leading: const Icon(Icons.article),
                                  trailing: PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == "Edit") {
                                        showNewsDetailsDialog(index);
                                      } else if (value == "Delete") {
                                        deleteDialog(index);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: "Edit",
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, size: 16),
                                            SizedBox(width: 8),
                                            Text("Edit"),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: "Delete",
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete, size: 16),
                                            SizedBox(width: 8),
                                            Text("Delete"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.5),
                      ),
                      height: screenHeight * 0.07,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: curpage > 1
                                ? () {
                                    setState(() {
                                      curpage--;
                                    });
                                    loadNewsData();
                                  }
                                : null,
                            child: const Text(
                              "Previous",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),

                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(numofpage, (index) {
                                  if (index == 0 ||
                                      index == numofpage - 1 ||
                                      (index >= curpage - 2 &&
                                          index <= curpage)) {
                                    return TextButton(
                                      onPressed: () {
                                        setState(() {
                                          curpage = index + 1;
                                        });
                                        loadNewsData();
                                      },
                                      child: Text(
                                        (index + 1).toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: curpage == index + 1
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: curpage == index + 1
                                              ? Colors.red
                                              : Colors.black,
                                          shadows: curpage == index + 1
                                              ? const [
                                                  Shadow(
                                                    color: Colors.black54,
                                                    offset: Offset(1, 1),
                                                    blurRadius: 3,
                                                  ),
                                                ]
                                              : null,
                                        ),
                                      ),
                                    );
                                  } else if (index == curpage - 3 ||
                                      index == curpage + 1) {
                                    // Add ellipsis for skipped pages
                                    return const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Text("..."),
                                    );
                                  } else {
                                    return const SizedBox
                                        .shrink(); // Hide other items
                                  }
                                }),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Page input and "Go" button
                          TextButton(
                            onPressed: curpage < numofpage
                                ? () {
                                    curpage++;
                                    loadNewsData();
                                  }
                                : null,
                            child: const Text(
                              "Next",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          Positioned(
            right: 5,
            bottom: 50, // Adjust this value to apply a "ceiling"
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (content) => const NewNewsScreen(),
                  ),
                );
                loadNewsData();
              },
              backgroundColor: Colors.white.withOpacity(0.6),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      drawer: const MyDrawer(),
    );
  }

  String truncateString(String str, int length) {
    if (str.length > length) {
      str = str.substring(0, length);
      return "$str...";
    } else {
      return str;
    }
  }

  void loadNewsData() {
    String newsletter = newslettertxt.text;

    String api =
        "${Myconfig.server}/mymemberlink/load_news.php?pageno=$curpage";
    if (newsletter.isNotEmpty) {
      api += "&search=$newsletter";
    }
    http.get(Uri.parse(api)).then((response) {
      log(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['news'];
          newsList.clear();
          for (var item in result) {
            News news = News.fromJson(item);
            newsList.add(news);
          }
          numofpage = int.parse(data['numofpage'].toString());
          numofresult = int.parse(data['numofresult'].toString());

          setState(() {});
        }
      } else {
        print("Error");
      }
    });
  }

  void showNewsDetailsDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 27, 171, 233),
              borderRadius: BorderRadius.circular(
                  8), // Rounded corners for title container
            ),
            child: Text(
              newsList[index].newsTitle.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900], // Darker color for text
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              newsList[index].newsDetails.toString(),
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.justify,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                News news = newsList[index];

                // Navigate to EditNewsScreen
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (content) => EditNewsScreen(news: news),
                  ),
                );

                loadNewsData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button background color
                foregroundColor: Colors.white, // Button text color
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Rounded button shape
                ),
              ),
              child: const Text(
                "Edit",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // Bold text for emphasis
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Button background color
                foregroundColor: Colors.white, // Button text color
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Rounded button shape
                ),
              ),
              child: const Text(
                "Close",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.all(16),
          elevation: 5,
        );
      },
    );
  }

  void deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          backgroundColor: Colors.white, // White background for the dialog
          title: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "Delete \"${truncateString(newsList[index].newsTitle.toString(), 20)}\"",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          content: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Are you sure you want to delete this news? This action cannot be undone.",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    deleteNews(index);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void deleteNews(int index) {
    http.post(Uri.parse("${Myconfig.server}/mymemberlink/delete_news.php"),
        body: {"newsid": newsList[index].newsId.toString()}).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        log(data.toString());
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("The record has successfully deleted"),
            backgroundColor: Colors.green,
          ));
          loadNewsData(); //reload data
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed to delete the record"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
