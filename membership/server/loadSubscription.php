<?php
include_once("dbconnect.php");

// Check if 'user_id' is provided
$user_id = isset($_POST['user_id']) ? $_POST['user_id'] : null;

if ($user_id === null) {
    $response = array('status' => 'failed', 'data' => 'User ID is required');
    sendJsonResponse($response);
    exit();
}

// Get the current date
$currentDate = date('Y-m-d');


$sqlDeleteExpiredSubscriptions = "
    DELETE FROM membership_status
    WHERE user_id = ? AND end_date <= ?
";
$stmtDelete = $conn->prepare($sqlDeleteExpiredSubscriptions);
$stmtDelete->bind_param("is", $user_id, $currentDate);
$stmtDelete->execute(); // No response is sent here

$sqlLoadSubscribedMemberships = "
    SELECT m.membership_id, m.membership_name, m.membership_description, 
           m.membership_price, m.membership_duration, m.membership_benefits, 
           m.membership_terms, m.membership_image, ms.start_date, ms.end_date
    FROM membership m
    INNER JOIN membership_status ms ON m.membership_name = ms.membership_name
    WHERE ms.user_id = ? AND ms.status = 'Active'
    ORDER BY ms.membership_status_id ASC
";


$stmt = $conn->prepare($sqlLoadSubscribedMemberships);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();
$number_of_result = $result->num_rows;

if ($number_of_result > 0) {
    // Prepare an array to store subscribed membership data
    $subscribedMemberships = array();

    while ($row = $result->fetch_assoc()) {
        $membership = array();
        $membership['membership_id'] = $row['membership_id'];
        $membership['membership_name'] = $row['membership_name'];
        $membership['membership_description'] = $row['membership_description'];
        $membership['membership_price'] = $row['membership_price'];
        $membership['membership_duration'] = $row['membership_duration'];
        $membership['membership_benefits'] = $row['membership_benefits'];
        $membership['membership_terms'] = $row['membership_terms'];
        $membership['membership_image'] = $row['membership_image'];
        $membership['start_date'] = $row['start_date'];
        $membership['end_date'] = $row['end_date'];
        array_push($subscribedMemberships, $membership);
    }

    // Send success response with subscribed data
    $response = array(
        'status' => 'success',
        'data' => $subscribedMemberships,
    );
    sendJsonResponse($response);
} else {
    // No records found
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

// Helper function to send JSON response
function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
