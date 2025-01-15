<?php
include_once("dbconnect.php");

if (!isset($_POST['user_id'])) {
    sendErrorResponse("User ID is required");
    exit();
}

$user_id = $_POST['user_id'];

$sql = "SELECT * FROM membership_status WHERE user_id = '$user_id' ORDER BY start_date DESC";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $statusarray['membership_status'] = array();
    while ($row = $result->fetch_assoc()) {
        $status = array();
        $status['membership_status_id'] = $row['membership_status_id'];
		$status['user_id'] = $row['user_id'];
		$status['membership_name'] = $row['membership_name'];
		$status['start_date'] = $row['start_date'];
		$status['end_date'] = $row['end_date'];
		$status['status'] = $row['status'];

       array_push($statusarray['membership_status'], $status);
    }
    $response = array('status' => 'success', 'data' => $statusarray);
    sendJsonResponse($response);
} else {
    sendErrorResponse("No membership status found");
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