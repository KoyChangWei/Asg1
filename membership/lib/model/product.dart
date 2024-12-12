class MyProducts {
  String? productId;
  String? productName;
  String? productImageFile;
  String? productDescription;
  String? productQuantity;
  String? productPrice;
  String? productStartDate;
  String? productEndDate;
  String? productCategory;


  MyProducts(
      {this.productId,
      this.productName,
      this.productImageFile,
      this.productDescription,
      this.productQuantity,
      this.productPrice,
      this.productStartDate,
      this.productEndDate,
      this.productCategory});

  MyProducts.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productImageFile = json['product_imageFile'];
    productDescription = json['product_description'];
    productQuantity = json['product_quantity'];
    productPrice = json['product_price'];
    productStartDate = json['product_startDate'];
    productEndDate = json['product_endDate'];
    productCategory = json['product_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_imageFile'] = productImageFile;
    data['product_description'] = productDescription;
    data['product_quantity'] = productQuantity;
    data['product_price'] = productPrice;
    data['product_startDate'] = productStartDate;
    data['product_endDate'] = productEndDate;
    data['product_category'] = productCategory;
    return data;
  }
}
