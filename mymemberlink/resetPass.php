<?php
if (!isset($_POST)) {
	$response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);


$sqlupdate = "UPDATE `member` SET `password` = '$password' WHERE `email` = '$email'";
if ($conn->query($sqlupdate) === TRUE) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);

} else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
}
	
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>
