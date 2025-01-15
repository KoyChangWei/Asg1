<?php
include_once("dbconnect.php");

// Fetch all membership records
$sqlLoadMembership = "SELECT * FROM `membership` ORDER BY `membership_id` ASC";

// Execute the query
$result = $conn->query($sqlLoadMembership);
$number_of_result = $result->num_rows;

if ($number_of_result > 0) {
    // Prepare an array to store membership data
    $membershipArray['membership'] = array();

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
        array_push($membershipArray['membership'], $membership);
    }

    // Send success response with data
    $response = array(
        'status' => 'success',
        'data' => $membershipArray,
    );
    sendJsonResponse($response);
} else {
    // No records found
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

// Helper function to send JSON response
function sendJsonResponse($sentArray){
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
