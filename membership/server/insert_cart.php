<?php

include_once("dbconnect.php");

$productid= ($_POST['productid']);
$productname = addslashes($_POST['productname']);
$productdescription = addslashes($_POST['productdescription']);
$productprice = ($_POST['productprice']);
$productquantity = ($_POST['productquantity']);
$productstartdate = ($_POST['productstartdate']);
$productenddate = ($_POST['productenddate']);
$productimage = ($_POST['productimage']);
$productcategory = ($_POST['productcategory']);
$quantity = $_GET['quantity'];

// Check if the product name already exists
$sqlcheck = "SELECT * FROM `cart` WHERE `product_name` = '$productname'";
$result = $conn->query($sqlcheck);

if ($result->num_rows > 0) {
    // Product name exists, return failed response
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

 $sqlinsertcart="INSERT INTO `cart`(`product_id`, `product_name`, `product_imageFile`, `product_description`, `product_quantity`, `product_price`, `product_startDate`, `product_endDate`, `product_category`, `quantitySelected`) VALUES ('$productid','$productname','$productimage','$productdescription','$productquantity','$productprice','$productstartdate','$productenddate','$productcategory','$quantity')";
 
if ($conn->query($sqlinsertcart) === TRUE) {
	$response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

	
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>