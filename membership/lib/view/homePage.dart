import 'package:flutter/material.dart';
import 'package:membership/view/newsletter/news_screen.dart';
import 'drawer/myDrawer.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String formattedDate = "";

  @override
  void initState() {
    super.initState();
    var time = DateTime.now().toUtc().add(const Duration(hours: 8));
    var formatter = DateFormat('dd-MM-yyyy hh:mm a');
    formattedDate = formatter.format(time);
  }

  final List<Map<String, dynamic>> sections = [
    {
      'name': 'Newsletter',
      'icon': FontAwesomeIcons.newspaper,
      'color': [Colors.cyan, Colors.blue],
    },
    {
      'name': 'Events',
      'icon': FontAwesomeIcons.calendar,
      'color': [Colors.green, Colors.teal],
    },
    {
      'name': 'Members',
      'icon': FontAwesomeIcons.users,
      'color': [Colors.purple, Colors.indigo],
    },
    {
      'name': 'Payment',
      'icon': FontAwesomeIcons.creditCard,
      'color': [Colors.pink, Colors.red],
    },
    {
      'name': 'Products',
      'icon': FontAwesomeIcons.bagShopping,
      'color': [Colors.orange, Colors.yellow],
    },
    {
      'name': 'Vetting',
      'icon': FontAwesomeIcons.shieldHalved,
      'color': [Colors.greenAccent, Colors.green],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 114, 104, 104),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Set your desired color here
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notification_add,
            ),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                const Text(
                  "Dashboard",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Last Login Time:",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("image/MainPage.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3,
                    ),
                    itemCount: sections.length,
                    itemBuilder: (context, index) {
                      final section = sections[index];
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              section['color'][0].withOpacity(0.7),
                              section['color'][1].withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: section['color'][0].withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                section['icon'],
                                size: 48,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 30),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 8),
                                  Text(
                                    section['name'],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Explore ${section['name'].toLowerCase()} section",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white70),
                                  ),
                                ],
                              ),
                              Spacer(),
                              IconButton(
                                icon: const FaIcon(
                                  FontAwesomeIcons.chevronRight,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  switch (section['name']) {
                                    case 'Newsletter':
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NewsLetterScreen()),
                                      );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
