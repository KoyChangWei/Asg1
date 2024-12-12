import 'package:flutter/material.dart';

import '../auth/login.dart';
import '../homePage.dart';
import '../newsletter/news_screen.dart';
import '../product/product._screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: const EdgeInsets.all(0.0), children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: const Text(
            'Song Yu Qi',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          accountEmail: const Text(
            'yuqi@gmail.com',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          currentAccountPicture: const CircleAvatar(
            backgroundImage: ExactAssetImage('image/yuqi.jpg'),
          ),
          onDetailsPressed: () {},
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("image/drawer.jpg"), fit: BoxFit.cover)),
        ),
        ListTile(
          title: const Text('Home Page'),
          leading: const Icon(Icons.home),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => const HomePageScreen()));
          },
        ),
        const Divider(),
        ListTile(
          title: const Text('Newsletter'),
          leading: const Icon(Icons.newspaper),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => const NewsLetterScreen()));
          },
        ),
        const ListTile(
          title: Text('Events'),
          leading: Icon(Icons.event),
        ),
        ListTile(
          title: const Text('Members'),
          leading: const Icon(Icons.group),
          onTap: () {},
        ),
        ListTile(
          title: const Text('Payments'),
          leading: const Icon(Icons.payment),
          onLongPress: () {},
        ),
        ListTile(
          title: const Text('Products'),
          leading: const Icon(Icons.shopping_bag),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => const ProductScreen()));
          },
        ),
        ListTile(
          title: const Text('Vetting'),
          leading: const Icon(Icons.verified),
          onLongPress: () {},
        ),
        const Divider(),
        ListTile(
          title: const Text('Settings'),
          leading: const Icon(Icons.settings),
          onLongPress: () {},
        ),
        const Divider(),
        ListTile(
          title: const Text(
            'Logout',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const Icon(
            Icons.logout,
            color: Colors.red,
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (content) => const LoginScreen()));
          },
        ),
      ]),
    );
  }
}
