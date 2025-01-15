<?php
if (!isset($_POST)) {
	$response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);


$sqllogin = "SELECT member_id, email, password, phoneNo, username, timeLog FROM member WHERE email = '$email' AND password = '$password'";
$result = $conn->query($sqllogin);

if ($result->num_rows > 0) {
    $user = array();
    while($row = $result->fetch_assoc()) {

        $user['member_id'] = $row['member_id'];
        $user['email'] = $row['email'];
        $user['phoneNo'] = $row['phoneNo'];
        $user['username'] = $row['username'];
        $user['timeLog'] = $row['timeLog'];
    }
    
    $response = array('status' => 'success', 'data' => $user);
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
