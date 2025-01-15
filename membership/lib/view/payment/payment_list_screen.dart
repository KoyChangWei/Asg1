import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:membership/model/payment.dart';
import 'package:membership/model/purchase.dart';
import '../../config/Myconfig.dart';
import '../../model/user.dart';
import '../drawer/myDrawer.dart';

class PaymentListScreen extends StatefulWidget {
  final User user;
  const PaymentListScreen({super.key, required this.user});

  @override
  State<PaymentListScreen> createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> {
  List<Payment> membershipStatusList = [];
  List<PurchaseDetail> purchaseList = [];
  final df = DateFormat('dd-MM-yyyy');
  final currencyFormat = NumberFormat("#,##0.00", "en_US");

  @override
  void initState() {
    super.initState();
    loadPurchaseHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Payment History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadPurchaseHistory,
          ),
        ],
      ),
      drawer: MyDrawer(user: widget.user),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue,
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: purchaseList.isEmpty
            ? Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "No payment records found",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: purchaseList.length,
                itemBuilder: (context, index) {
                  final purchase = purchaseList[index];
                  final purchaseDate = df.format(DateTime.parse(purchase.purchaseDate!));

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: purchase.paymentStatus?.toLowerCase() == "paid" 
                              ? [
                                  Colors.green.shade300,
                                  Colors.green.shade100,
                                ]
                              : [
                                  Colors.red.shade300,
                                  Colors.red.shade100,
                                ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () => loadMembershipStatusDialog(purchase),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      purchase.membershipName ?? "Unknown",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
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
                                      color: purchase.paymentStatus?.toLowerCase() == "paid"
                                          ? Colors.green.withOpacity(0.2)
                                          : Colors.red.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      purchase.paymentStatus ?? "Unknown",
                                      style: TextStyle(
                                        color: purchase.paymentStatus?.toLowerCase() == "paid"
                                            ? Colors.green[800]
                                            : Colors.red[800],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              dateInfo("Purchase Date", purchaseDate),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Amount Paid:",
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "RM ${currencyFormat.format(double.parse(purchase.paymentAmount ?? '0'))}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 24, color: Colors.white,thickness:3,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    icon: Icon(
                                      Icons.receipt_long,
                                      color: Colors.blue[700],
                                    ),
                                    label: Text(
                                      "View Details",
                                      style: TextStyle(color: Colors.blue[700]),
                                    ),
                                    onPressed: () => loadMembershipStatusDialog(purchase),
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
      ),
    );
  }

  Future<void> loadMembershipStatusDialog(PurchaseDetail purchase) async {
    try {
      final response = await http.post(
        Uri.parse("${Myconfig.server}/mymemberlink/load_membership_status.php"),
        body: {
          "user_id": widget.user.memberId,
          "membership_name": purchase.membershipName,
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'success') {
          var result = data['data']['membership_status'];
          membershipStatusList.clear();
          for (var item in result) {
            Payment payments = Payment.fromJson(item);
            if (payments.membershipName == purchase.membershipName) {
              membershipStatusList.add(payments);
            }
          }
          showDetailedPaymentDialog(purchase);
        }
      }
    } catch (e) {
      print("Error loading membership status: $e");
    }
  }

  void showDetailedPaymentDialog(PurchaseDetail purchase) {
    final purchaseDate = df.format(DateTime.parse(purchase.purchaseDate!));
    final membershipStatus = membershipStatusList.isNotEmpty ? membershipStatusList.first : null;
    final isPaid = purchase.paymentStatus?.toLowerCase() == "paid";

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isPaid
                      ? [Colors.green.shade50, Colors.white]
                      : [Colors.red.shade50, Colors.white],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Icon(
                    isPaid ? Icons.check_circle : Icons.error,
                    color: isPaid ? Colors.green : Colors.red,
                    size: 50,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isPaid ? "Payment Completed" : "Payment Failed",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isPaid ? Colors.green.shade700 : Colors.red.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Payment Details Container
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isPaid ? Colors.green.shade200 : Colors.red.shade200,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Receipt Number
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Receipt No",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "#${purchase.purchaseId}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),

                        // Purchase Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Purchase Date",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              purchaseDate,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),

                        // Membership
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Membership",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 15,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                purchase.membershipName ?? "N/A",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),

                        // Amount
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Amount Paid",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "RM ${currencyFormat.format(double.parse(purchase.paymentAmount ?? '0'))}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),

                        // Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Status",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 15,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isPaid
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                purchase.paymentStatus ?? "N/A",
                                style: TextStyle(
                                  color: isPaid ? Colors.green : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  if (membershipStatus != null) ...[
                    const SizedBox(height: 20),
                    // Subscription Details Container
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isPaid ? Colors.green.shade200 : Colors.red.shade200,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Subscription Period",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isPaid ? Colors.green.shade700 : Colors.red.shade700,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Start Date",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                df.format(DateTime.parse(membershipStatus.startDate!)),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "End Date",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                df.format(DateTime.parse(membershipStatus.endDate!)),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 25),
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (isPaid)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.download, size: 20),
                              label: const Text("Download"),
                              onPressed: () {
                                // Implement download functionality
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.close, size: 20),
                            label: const Text("Close"),
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: isPaid ? Colors.green : Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(
                                color: isPaid ? Colors.green : Colors.red,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
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
      ),
    );
  }

  Future<void> loadPurchaseHistory() async {
    try {
      final response = await http.post(
        Uri.parse("${Myconfig.server}/mymemberlink/load_purchase_details.php"),
        body: {
          "user_id": widget.user.memberId,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          var result = data['data']['purchase_details'];
          setState(() {
            purchaseList.clear();
            for (var item in result) {
              PurchaseDetail purchase = PurchaseDetail.fromJson(item);
              purchaseList.add(purchase);
            }
          });
        }
      }
    } catch (e) {
      print("Error loading purchase history: $e");
    }
  }

  Widget dateInfo(String label, String date) {
    return Row(
      children: [
        Icon(Icons.calendar_today, 
            size: 16, 
            color: Colors.grey[600]
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
          date,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

}
