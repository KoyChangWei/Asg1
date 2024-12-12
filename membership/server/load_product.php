<?php

include_once("dbconnect.php");

$results_per_page = 3;
if (isset($_GET['pageno'])){
	$pageno = (int)$_GET['pageno'];
}else{
	$pageno = 1;
}

$category = $_GET['category'];
$search = "";

$page_first_result = ($pageno - 1) * $results_per_page;

if($category == "All") {
    if (isset($_GET['search'])) {
        $search  = $_GET['search'];
        $sqlloadproduct = "SELECT * FROM `product` WHERE `product_name` LIKE '%$search%' ORDER BY `product_startDate` DESC";
    } else {
        $sqlloadproduct = "SELECT * FROM `product` ORDER BY `product_startDate` DESC";
    }
}else{
    $sqlloadproduct = "SELECT * FROM `product` WHERE `product_category`= '$category' ORDER BY `product_startDate` DESC ";


    if (isset($_GET['search'])) {
        $search  = $_GET['search'];
        $sqlloadproduct = "SELECT * FROM `product` WHERE `product_name` LIKE '%$search%' AND `product_category`= '$category' ORDER BY `product_startDate` DESC";
    } else {
        $sqlloadproduct = "SELECT * FROM `product` WHERE `product_category`= '$category' ORDER BY `product_startDate` DESC ";
    }
}


$result = $conn->query($sqlloadproduct);
$number_of_result = $result->num_rows;

$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloadproduct = $sqlloadproduct." LIMIT $page_first_result, $results_per_page";

$result = $conn->query($sqlloadproduct);

if ($result->num_rows > 0) {
    $productarray['products'] = array();
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
        array_push($productarray['products'], $product);
    }
    $response = array('status' => 'success', 'data' => $productarray,'numofpage'=>$number_of_page,'numberofresult'=>$number_of_result);
    sendJsonResponse($response);
}else{
    $response = array('status' => 'failed', 'data' => null, 'numofpage'=>$number_of_page,'numberofresult'=>$number_of_result);
    sendJsonResponse($response);
}
	
	
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>