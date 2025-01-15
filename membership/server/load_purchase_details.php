<?php
include_once("dbconnect.php");

if (!isset($_POST['user_id'])) {
    sendErrorResponse("User ID is required");
    exit();
}

$user_id = $_POST['user_id'];

$sql = "SELECT * FROM tbl_purchase WHERE user_id = '$user_id'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $purchaseArray['purchase_details'] = array();
    while ($row = $result->fetch_assoc()) {
        $purchase = array();
        $purchase['purchase_id'] = $row['purchase_id'];
        $purchase['user_id'] = $row['user_id'];
        $purchase['payment_amount'] = $row['payment_amount'];
        $purchase['payment_status'] = $row['payment_status'];
        $purchase['purchase_date'] = $row['purchase_date'];
        $purchase['membership_name'] = $row['membership_name'];

        array_push($purchaseArray['purchase_details'], $purchase);
    }
    $response = array('status' => 'success', 'data' => $purchaseArray);
    sendJsonResponse($response);
} else {
    sendErrorResponse("No purchase details found");
}

function sendJsonResponse($response)
{
    header('Content-Type: application/json');
    echo json_encode($response);
}

function sendErrorResponse($message)
{
    $response = array('status' => 'error', 'message' => $message);
    sendJsonResponse($response);
}
?>