<?php

include_once("dbconnect.php");

$sqlloadproduct = "SELECT * FROM `cart` ORDER BY `product_startDate` DESC";


$result = $conn->query($sqlloadproduct);

if ($result->num_rows > 0) {
    $productarray['cart'] = array();
    while ($row = $result->fetch_assoc()) {
        $product = array();
        $product['product_id'] = $row['product_id'];
        $product['product_name'] = $row['product_name'];
        $product['product_imageFile'] = $row['product_imageFile'];
        $product['product_description'] = $row['product_description'];
        $product['product_quantity'] = $row['product_quantity'];
        $product['product_price'] = $row['product_price'];
        $product['product_startDate'] = $row['product_startDate'];
        $product['product_endDate'] = $row['product_endDate'];
        $product['product_category'] = $row['product_category'];
        $product['quantitySelected'] = $row['quantitySelected'];
        array_push($productarray['cart'], $product);
    }
    $response = array('status' => 'success', 'data' => $productarray);
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