import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:membership/model/subscription.dart';
import 'package:membership/model/user.dart';
import '../../config/Myconfig.dart';
import '../../model/membership.dart';
import '../drawer/myDrawer.dart';
import 'membership_detail_screen.dart';
import 'package:intl/intl.dart';

class MembershipScreen extends StatefulWidget {
  final User user;
  const MembershipScreen({super.key, required this.user});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen>
    with SingleTickerProviderStateMixin {
  List<Membership> membershipList = [];
  List<Subscription> subscriptionList = [];
  late TabController _tabController;
  late double screenWidth, screenHeight;
  final df = DateFormat('dd-MM-yyyy');
  String _selectedScreen = "Available Plans";
  List<String> sreenListPlan = ["Available Plans", "My Subscriptions"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadMembershipData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[300],
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Memberships",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showInfoDialog(),
          ),
        ],
      ),
      drawer: MyDrawer(user: widget.user),
      body: Column(
        children: [
            Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.lightBlue[200],
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
              BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
              ),
              ],
            ),
            child: Row(
              children: sreenListPlan.map((screen) {
              bool isSelected = screen == _selectedScreen;
              return Expanded(
              child: GestureDetector(
              onTap: () {
                setState(() {
                _selectedScreen = screen;
                if (screen == "My Subscriptions") {
                loadSubscriptionData();
                }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(21),
                boxShadow: isSelected ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
                ] : null,
                ),
                child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: isSelected ? 16 : 15,
                ),
                child: Text(
                  screen,
                  textAlign: TextAlign.center,
                ),
                ),
              ),
              ),
              );
              }).toList(),
            ),
            ),
          Expanded(
            child: _selectedScreen == "Available Plans"
                ? availablePlans()
                : subscriptionsPlan(),
          ),
        ],
      ),
    );
  }

  Widget availablePlans() {
    return membershipList.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 20),
                Text(
                  'Loading memberships...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
        : RefreshIndicator(
            onRefresh: () async => loadMembershipData(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: membershipList.length,
              itemBuilder: (context, index) {
                final membership = membershipList[index];
                return Hero(
                  tag: 'membership-${membership.membershipId}',
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => navigateToDetail(membership),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.withOpacity(0.05),
                              Colors.white,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                "${Myconfig.server}/mymemberlink/assets/membership/${membership.membershipImage}",
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                  "image/noImg.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    membership.membershipName ?? "No Name",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "RM ${membership.membershipPrice ?? "0.00"}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              membership.membershipDescription ?? "No Description",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  onPressed: () => navigateToDetail(membership),
                                  icon: const Icon(Icons.arrow_forward),
                                  label: const Text('View Details'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.blue,
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget subscriptionsPlan() {
    return subscriptionList.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.subscriptions_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No active subscriptions',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
        : RefreshIndicator(
            onRefresh: () async => loadSubscriptionData(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: subscriptionList.length,
              itemBuilder: (context, index) {
                final subscription = subscriptionList[index];
                final startDate = df.format(DateTime.parse(subscription.startDate!));
                final endDate = df.format(DateTime.parse(subscription.endDate!));

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.withOpacity(0.05),
                          Colors.white,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Membership Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            "${Myconfig.server}/mymemberlink/assets/membership/${subscription.membershipImage}",
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              "image/noImg.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Membership Name and Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                subscription.membershipName ?? "No Name",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "Active",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Description
                        Text(
                          subscription.membershipDescription ?? "No Description",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Subscription Dates
                        subscriptionInfo('Start Date', startDate),
                        const SizedBox(height: 8),
                        subscriptionInfo('End Date', endDate),
                        const SizedBox(height: 16),
                        // Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "RM ${subscription.membershipPrice ?? "0.00"}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget subscriptionInfo(String label, String value) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Future<void> loadSubscriptionData() async {
    try {
      final response = await http.post(
        Uri.parse("${Myconfig.server}/mymemberlink/loadSubscription.php"),
        body: {"user_id": widget.user.memberId},
      );
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data'];
          subscriptionList.clear();
          for (var item in result) {
            subscriptionList.add(Subscription.fromJson(item));
          }
          setState(() {});
        } else {
          print("Failed to load subscriptions");
        }
      }
    } catch (e) {
      print("Error loading subscription data: $e");
    }
  }


  void navigateToDetail(Membership membership) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MembershipDetailScreen(membership: membership, user: widget.user),
      ),
    );
  }

  void showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Memberships'),
        content: const Text(
          'Choose from our carefully curated membership plans designed to meet your needs. '
          'Each plan comes with unique benefits and features. Tap on any plan to see detailed information.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void loadMembershipData() {
    http
        .get(Uri.parse("${Myconfig.server}/mymemberlink/load_membership.php"))
        .then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['membership'];
          membershipList.clear();
          for (var item in result) {
            membershipList.add(Membership.fromJson(item));
          }
          setState(() {});
        }
      }
    });
  }
}
