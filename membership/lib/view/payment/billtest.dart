import 'dart:async';

import 'package:flutter/material.dart';
import 'package:membership/model/user.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../config/Myconfig.dart';
import '../membership/MembershipScreen.dart';

class BillScreenTest extends StatefulWidget {
  final User user;
  final double totalprice;
  final String membershipName;

  const BillScreenTest({super.key, required this.user, required this.totalprice, required this.membershipName});

  @override
  State<BillScreenTest> createState() => _BillScreenTestState();
}

class _BillScreenTestState extends State<BillScreenTest> {
  var loadingPercentage = 0;
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    print(widget.user.phoneNo);
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(
            '${Myconfig.server}/mymemberlink/payment.php?&userid=${widget.user.memberId}&email=${widget.user.email}&phone=${widget.user.phoneNo}&name=${widget.user.username}&amount=${widget.totalprice}&amount=${widget.totalprice}&membershipName=${widget.membershipName}'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Bill Payment',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        ),
                actions: [
          IconButton(
            icon: const Icon(Icons.card_membership),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MembershipScreen(user: widget.user),
                ),
              );
            },
          ),
        ],

      ),
      body: Center(
        child: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}