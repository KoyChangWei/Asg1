<?php
if ( !isset( $_POST ) ) {
    $response = array( 'status' => 'failed', 'data' => null );
    sendJsonResponse( $response );
    die;
}

include_once( 'dbconnect.php' );
$productid = ( $_POST[ 'newsid' ] );

$sqldeletecart = "DELETE FROM `newsletter` WHERE `news_id` = '$productid'";

if ( $conn->query( $sqldeletecart ) === TRUE ) {
    $response = array( 'status' => 'success', 'data' => null );
    sendJsonResponse( $response );
} else {
    $response = array( 'status' => 'failed', 'data' => null );
    sendJsonResponse( $response );
}

function sendJsonResponse( $sentArray )
 {
    header( 'Content-Type: application/json' );
    echo json_encode( $sentArray );
}

?>