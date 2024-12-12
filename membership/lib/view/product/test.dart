import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:membership/view/product/cart_screen.dart';
import '../../config/Myconfig.dart';
import '../../model/product.dart';
import '../drawer/myDrawer.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<MyProducts> productsList = [];
  late double screenWidth, screenHeight, buttonWidth;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  String status = "Loading...";
  int selectedIndex = 0;
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  int customerQuantity = 1;
  final List<Color> cardColors = [
    Colors.orange[200]!,
    Colors.orange[400]!,
    Colors.orange[600]!,
  ];
  final List<String> categories = ["All", "T-Shirts", "Mugs", "Bags", "Pens"];

  @override
  void initState() {
    super.initState();
    loadProductsData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    buttonWidth = screenWidth / categories.length;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 191, 124),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Product",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            icon: const Icon(Icons.shopping_cart),
            iconSize: 36,
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            width: screenWidth,
            height: 50,
            color: Colors.orangeAccent,
            child: Stack(
              children: [
                // Animated rectangle
                AnimatedPositioned(
                  duration:
                      const Duration(milliseconds: 300), // Animation duration
                  left: selectedIndex *
                      buttonWidth, // Position based on the selected index
                  top: 0,
                  child: Container(
                    width: buttonWidth,
                    height: 50,
                    color: Colors.white
                        .withOpacity(0.5), // Rectangle color with transparency
                  ),
                ),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: categories.asMap().entries.map((entry) {
                    int index = entry.key;
                    String label = entry.value;
                    return TextButton(
                      onPressed: () {
                        setState(() {
                          selectedIndex = index; // Update the selected index
                        });
                        loadProductsData();
                      },
                      child: Text(
                        label,
                        style: TextStyle(
                          color: Colors.black, // Text color
                          fontWeight: selectedIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          SizedBox(
            width: screenWidth,
            height: screenHeight * 0.75,
            child: productsList.isEmpty
                ? Center(
                    child: Text(
                      status,
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        alignment: Alignment.center,
                        child: Text("Page: $curpage/Result: $numofresult"),
                      ),
                      Expanded(
                        child: GridView.count(
                          childAspectRatio:
                              0.4, // Adjust for better card proportions
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          padding: const EdgeInsets.all(8),
                          children: List.generate(productsList.length, (index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              color: cardColors[index % 3].withOpacity(0.8),
                              child: InkWell(
                                splashColor: Colors.red.withOpacity(0.3),
                                onTap: () {
                                  showProductDetailsDialog(index);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Product Image
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            "${Myconfig.server}/mymemberlink/assets/products/${productsList[index].productImageFile}",
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Image.asset(
                                              "image/noImg.jpg",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),

                                      Text(
                                        productsList[index]
                                            .productName
                                            .toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),

                                      // Product Description
                                      Text(
                                        truncateString(
                                            productsList[index]
                                                .productDescription
                                                .toString(),
                                            40),
                                        textAlign: TextAlign.justify,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 8),
                                      TweenAnimationBuilder(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        tween: ColorTween(
                                            begin: Colors.blue,
                                            end: Colors.red),
                                        builder: (BuildContext context,
                                            Color? value, Widget? child) {
                                          return Divider(
                                            color: value,
                                            thickness: 3,
                                          );
                                        },
                                      ),
                                      // Quantity and Price
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text("Stock:",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(productsList[index]
                                                  .productQuantity
                                                  .toString()),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              const Text("Price:",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  "RM ${productsList[index].productPrice.toString()}"),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),

                                      // Selling Dates
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.5),
            ),
            height: screenHeight * 0.079,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: curpage > 1
                      ? () {
                          setState(() {
                            curpage--;
                          });
                          loadProductsData();
                        }
                      : null,
                  child: const Text(
                    "Previous",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                            (index >= curpage - 2 && index <= curpage)) {
                          return TextButton(
                            onPressed: () {
                              setState(() {
                                curpage = index + 1;
                              });
                              loadProductsData();
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
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text("..."),
                          );
                        } else {
                          return const SizedBox.shrink(); // Hide other items
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
                          loadProductsData();
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

  void loadProductsData() {
    String category = categories[selectedIndex];
    print(category);
    http
        .get(Uri.parse(
            "${Myconfig.server}/mymemberlink/load_product.php?pageno=$curpage&category=$category"))
        .then((response) {
      // log(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['products'];
          productsList.clear();

          for (var item in result) {
            MyProducts myproduct = MyProducts.fromJson(item);
            productsList.add(myproduct);
          }
          numofpage = int.parse(data['numofpage'].toString());
          numofresult = int.parse(data['numberofresult'].toString());
          setState(() {});
        } else {
          status = "No Data";
        }
      } else {
        status = "Error loading data";
        print("Error");
        setState(() {});
      }
    });
  }

  Future<void> insertCart(int index) async {
    String quantity = customerQuantity.toString();

    http.post(Uri.parse("${Myconfig.server}/mymemberlink/insert_cart.php?quantity=$quantity"),
        body: {
          "productid": productsList[index].productId.toString(),
          "productname": productsList[index].productName.toString(),
          "productprice": productsList[index].productPrice.toString(),
          "productimage": productsList[index].productImageFile.toString(),
          "productquantity": productsList[index].productQuantity.toString(),
          "productdescription":
              productsList[index].productDescription.toString(),
          "productstartdate": productsList[index].productStartDate.toString(),
          "productenddate": productsList[index].productEndDate.toString(),
          "productcategory": productsList[index].productCategory.toString(),
        }).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "The ${productsList[index].productName} has successfully added into cart!"),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("The product already existing in cart!"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1),
          ));
        }
      } else {
        // Handle unexpected errors
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Failed to add into cart!"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ));
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("An unexpected error occurred"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ));
    });
  }

  void showProductDetailsDialog(int index) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(16),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Product Name
                Text(
                  productsList[index].productName.toString(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  textAlign: TextAlign.center,
                ),
                const Divider(
                  color: Colors.blueAccent,
                  thickness: 5,
                ),

                // Product Image
                SizedBox(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      "${Myconfig.server}/mymemberlink/assets/products/${productsList[index].productImageFile}",
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        "image/noImg.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(colors: [
                        Colors.blueAccent,
                        Colors.lightBlueAccent,
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Description",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        // Product Description
                        Text(
                          productsList[index].productDescription.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 16),
                  
                        // Quantity and Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Quantity
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Stock',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    productsList[index]
                                        .productQuantity
                                        .toString(),
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                  
                            // Price
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Price',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    'RM ${productsList[index].productPrice}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                  
                        // Selling Dates
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Start Selling Date',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Text(
                                  df.format(DateTime.parse(productsList[index]
                                      .productStartDate
                                      .toString())),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'End Selling Date',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Text(
                                  df.format(DateTime.parse(productsList[index]
                                      .productEndDate
                                      .toString())),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 20),
                                  onPressed: () {
                                    _updateQuantity(index, -1);
                                  },
                                ),
                                Text(
                                  customerQuantity.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 20),
                                  onPressed: () {
                                    _updateQuantity(index, 1);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await insertCart(index);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Add to Cart'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.red,
                      side: BorderSide(color: Colors.grey[600]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
    void _updateQuantity(int index, int change) {
    setState(() {
      customerQuantity += change;
      if (customerQuantity < 1) {
        customerQuantity = 1; // Prevent negative quantity
      }
    });
  }
}
