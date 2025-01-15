<?php
include_once("dbconnect.php");

if (!isset($_POST['user_id']) || !isset($_POST['membership_name'])) {
    $response = array('status' => 'failed', 'error' => 'Missing required parameters');
    sendJsonResponse($response);
    exit;
}

$userId = $_POST['user_id'];
$membershipName = $_POST['membership_name'];

$sqlCheck = "SELECT * FROM tbl_purchase 
            WHERE user_id = ? 
            AND membership_name = ? 
            AND payment_status = 'Paid'";

$stmt = $conn->prepare($sqlCheck);
$stmt->bind_param("ss", $userId, $membershipName);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $response = array('status' => 'success');
} else {
    $response = array('status' => 'failed');
}

sendJsonResponse($response);

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>