import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../config/Myconfig.dart';
import '../../model/cart.dart';
import '../../model/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<MyCart> cartList = [];
  final df = DateFormat('dd/MM/yyyy hh:mm a');

  @override
  void initState() {
    super.initState();
    loadCartsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cart",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.purpleAccent),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: cartList.isEmpty
          ? const Center(
              child: Text("Empty Cart", style: TextStyle(fontSize: 20)),
            )
          : Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  color: Colors.transparent,
                  child: Text("Total Products: ${cartList.length}"),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        color: const Color.fromARGB(255, 222, 124, 199)
                            .withOpacity(0.7),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          splashColor: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                          onLongPress: () {
                            showRemoveDialog(index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Moved image to the side instead of as leading
                                Container(
                                  width: 80,
                                  height: 300,
                                  margin: const EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        "${Myconfig.server}/mymemberlink/assets/products/${cartList[index].productImageFile}",
                                      ),
                                      fit: BoxFit.cover,
                                      onError: (exception, stackTrace) =>
                                          const DecorationImage(
                                        image: AssetImage(
                                            "assets/images/noImg.jpg"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible:
                                            true, // Allow dismissing by tapping outside
                                        builder: (BuildContext context) {
                                          return Stack(
                                            children: [
                                              // Background blur
                                              BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 5, sigmaY: 5),
                                                child: Container(
                                                  color: Colors.black.withOpacity(
                                                      0.5), // Add slight tint
                                                ),
                                              ),
                                              // Dialog with image
                                              Center(
                                                child: Dialog(
                                                  backgroundColor: Colors
                                                      .transparent, // Make dialog transparent
                                                  child: GestureDetector(
                                                    onTap: () => Navigator.of(
                                                            context)
                                                        .pop(), // Dismiss on tap
                                                    child: InteractiveViewer(
                                                      child: Image.network(
                                                        "${Myconfig.server}/mymemberlink/assets/products/${cartList[index].productImageFile}",
                                                        fit: BoxFit.contain,
                                                        errorBuilder: (context,
                                                                error,
                                                                stackTrace) =>
                                                            Image.asset(
                                                                "assets/images/noImg.jpg"),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),

                                // Expanded to take remaining space
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Product Name
                                      Text(
                                        cartList[index].productName.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),

                                      // Description with expand/collapse
                                      Text(
                                        cartList[index].isDescriptionExpanded
                                            ? cartList[index]
                                                .productDescription!
                                            : truncateString(
                                                cartList[index]
                                                    .productDescription!,
                                                40),
                                        textAlign: TextAlign.justify,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            cartList[index]
                                                    .isDescriptionExpanded =
                                                !cartList[index]
                                                    .isDescriptionExpanded;
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: Text(
                                          cartList[index].isDescriptionExpanded
                                              ? 'Less Detail'
                                              : 'More Detail',
                                          style: const TextStyle(
                                              color: Colors.blue),
                                        ),
                                      ),
                                      const Divider(
                                        thickness: 2,
                                        color: Colors.purple,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Stock: ${cartList[index].productQuantity}",
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          Text(
                                            "Price: RM ${cartList[index].productPrice}",
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Quantity: ${cartList[index].quantitySelected}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),

                                      const Divider(
                                        thickness: 2,
                                        color: Colors.purple,
                                      ),
                                      Text(
                                        "Total Price:  RM ${calculateTotalPrice(index).toStringAsFixed(2)}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black87),
                                      ),
                                      // Product Details
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                                size: 40,
                                              ),
                                              onPressed: () {
                                                showRemoveDialog(index);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  double calculateTotalPrice(int index) {
    try {
      // Parse quantity as int
      int quantity = int.parse(cartList[index].quantitySelected.toString());

      // Parse product price as double
      double price = double.parse(cartList[index].productPrice.toString());

      // Calculate and return total price
      return quantity * price;
    } catch (e) {
      return 0.0; // Return 0 or handle the error as appropriate
    }
  }

  void showRemoveDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove ${cartList[index].productName}"),
          content: const Text("Are you sure you want to remove this item?"),
          actions: <Widget>[
            TextButton(
                child: const Text("Comfirm"),
                onPressed: () async {
                  await deleteCart(index);
                  loadCartsData();
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteCart(int index) async {
    http.post(Uri.parse("${Myconfig.server}/mymemberlink/delete_cart.php"),
        body: {
          "productid": cartList[index].productId.toString()
        }).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "The ${cartList[index].productName} has successfully deleted"),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ));

          setState(() {
            cartList.removeAt(index);
            loadCartsData();
          }); //reload data
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed to delete the record"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1),
          ));
        }
      }
    });
  }

  String truncateString(String str, int length) {
    if (str.length > length) {
      str = str.substring(0, length);
      return "$str...";
    } else {
      return str;
    }
  }

  void loadCartsData() {
    http.get(Uri.parse("${Myconfig.server}/mymemberlink/load_cart.php")).then(
      (response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['status'] == "success") {
            var result = data['data']['cart'];
            cartList.clear();

            for (var item in result) {
              MyCart mycart = MyCart.fromJson(item);
              mycart.isDescriptionExpanded = false; // Initially collapsed
              cartList.add(mycart);
            }
            setState(() {});
          }
        }
      },
    );
  }
}
