<?php
// To ensure we capture all errors in logs:
error_reporting(E_ALL);
ini_set('log_errors', 1);
// Optionally, specify your own error log file path (uncomment and set the path you prefer)
// ini_set('error_log', '/path/to/your/log/php_errors.log');

include_once("dbconnect.php");

// Retrieve GET parameters
$userid = $_GET['userid'];
$phone = $_GET['phone'];
$amount = $_GET['amount'];
$email = $_GET['email'];
$name = $_GET['name'];
$membershipName = $_GET['membershipName'];

// Log the incoming GET parameters for debugging
error_log("Received GET params -> userid: $userid, phone: $phone, amount: $amount, email: $email, name: $name, membershipName: $membershipName");

// Retrieve Billplz parameters from the callback
$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'],
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

// Log Billplz callback data for debugging
error_log("Billplz data received: " . print_r($data, true));

// Determine paid status
$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus == "true"){
    $paidstatus = "Success";
} else {
    $paidstatus = "Failed";
}
error_log("Resolved paid status: $paidstatus");

$receiptid = $_GET['billplz']['id'];

// Build the string to sign
$signing = '';
foreach ($data as $key => $value) {
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}
error_log("String to be signed: $signing");

// Generate signature
$signed = hash_hmac('sha256', $signing, 'dbca5fdbdbc0b534faeab5512342cf9b06ddfe710f2fe63bacf837916cd6f359ea9437e094db245b83410e6d4bbbe7ef50fd606b5f2a23cecaa0b020aab1cf95');
error_log("Generated signature: $signed");
error_log("Signature from Billplz: " . $data['x_signature']);

// Check signature
if ($signed === $data['x_signature']) {
    error_log("Signature matched. Proceeding to handle payment...");

    if ($paidstatus == "Success") {
        // Payment succeeded, log the success
        error_log("Payment successful. Inserting purchase record...");

        // Insert purchase record
        $insertPurchase = "INSERT INTO tbl_purchase (user_id, payment_amount, payment_status, purchase_date, membership_name) 
                           VALUES ('$userid', '$amount', 'Paid', NOW(), '$membershipName')";
        if (!$conn->query($insertPurchase)) {
            error_log("Error inserting purchase record: " . $conn->error);
            die("Error inserting purchase record: " . $conn->error);
        } else {
            error_log("Purchase record inserted successfully.");
        }

        $currentDate = date('Y-m-d');

        // Fetch membership duration
        $retrieveMembership = "SELECT membership_duration FROM membership WHERE membership_name = '$membershipName'";
        $result = $conn->query($retrieveMembership);

        if ($result->num_rows > 0) {
            $row = $result->fetch_assoc();
            $duration = $row['membership_duration'];
            error_log("Membership duration retrieved: $duration days.");

            $startDate = $currentDate;
            $endDate = date('Y-m-d', strtotime("+$duration days"));
            
            //verify the new mmebership payment is it already make but failed
            $retrieveMembershipRecord = "SELECT * FROM `membership_status` WHERE membership_name = '$membershipName'";
            $check = $conn->query($retrieveMembershipRecord);
            if($check->num_rows > 0){
                //Update the status to Active
            $updateMemberStatus = "UPDATE `membership_status` SET `start_date` = '$startDate', `end_date` = '$endDate', `status` = 'Active' WHERE `membership_name` = '$membershipName'";

            
             if (!$conn->query($updateMemberStatus)) {
                error_log("Error inserting membership record: " . $conn->error);
                die("Error inserting membership record: " . $conn->error);
            } else {
                error_log("Membership record updated successfully.");
            }
                
            }else{
            // Insert membership record
            $insertMembership = "INSERT INTO membership_status (user_id, membership_name, start_date, end_date, status)
                                 VALUES ('$userid', '$membershipName', '$startDate', '$endDate', 'Active')";
            if (!$conn->query($insertMembership)) {
                error_log("Error inserting membership record: " . $conn->error);
                die("Error inserting membership record: " . $conn->error);
            } else {
                error_log("Membership record inserted successfully.");
            }
               }
            
 
        } else {
            error_log("Error fetching membership duration: " . $conn->error);
            die("Error fetching membership duration: " . $conn->error);
        }

        // If everything is good, print receipt for success transaction
        echo "
        <!DOCTYPE html>
        <html lang=\"en\">
        <head>
            <meta charset=\"UTF-8\">
            <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
            <title>Payment Receipt - Success</title>
            <style>
                body {
                    font-family: 'Arial', sans-serif;
                    margin: 0;
                    padding: 0;
                    background-color: #f9fafb;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    min-height: 100vh;
                }
                .receipt-container {
                    background-color: #fff;
                    border-radius: 12px;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
                    width: 100%;
                    max-width: 500px;
                    padding: 30px;
                    text-align: center;
                }
                .receipt-header {
                    margin-bottom: 20px;
                }
                .receipt-header img {
                    width: 80px;
                    height: 80px;
                    margin-bottom: 15px;
                }
                .receipt-header h1 {
                    font-size: 24px;
                    color: #1d4ed8;
                    margin-bottom: 5px;
                }
                .receipt-header p {
                    font-size: 14px;
                    color: #6b7280;
                }
                .receipt-status {
                    margin: 20px 0;
                    font-weight: 600;
                    font-size: 16px;
                    padding: 10px 20px;
                    display: inline-block;
                    border-radius: 30px;
                    background-color: #dcfce7;
                    color: #166534;
                }
                .receipt-details {
                    margin-top: 20px;
                    text-align: left;
                    font-size: 14px;
                    color: #374151;
                }
                .receipt-details div {
                    margin-bottom: 10px;
                    display: flex;
                    justify-content: space-between;
                }
                .receipt-details .label {
                    font-weight: 500;
                }
                .receipt-details .value {
                    font-weight: 600;
                    color: #111827;
                }
                .amount-section {
                    margin: 30px 0;
                    padding: 20px;
                    background-color: #f3f4f6;
                    border-radius: 8px;
                }
                .amount-label {
                    font-size: 16px;
                    color: #6b7280;
                    margin-bottom: 5px;
                }
                .amount-value {
                    font-size: 28px;
                    font-weight: 700;
                    color: #1d4ed8;
                }
                .footer {
                    margin-top: 20px;
                    font-size: 12px;
                    color: #6b7280;
                }
                .footer a {
                    color: #1d4ed8;
                    text-decoration: none;
                }
                .footer a:hover {
                    text-decoration: underline;
                }
            </style>
        </head>
        <body>
            <div class=\"receipt-container\">
                <div class=\"receipt-header\">
                    <h1>Payment Receipt</h1>
                    <p>Thank you for your payment!</p>
                </div>

                <div class=\"receipt-status\">
                    Payment Successful
                </div>

                <div class=\"receipt-details\">
                    <div>
                        <span class=\"label\">Receipt ID:</span>
                        <span class=\"value\">$receiptid</span>
                    </div>
                    <div>
                        <span class=\"label\">Name:</span>
                        <span class=\"value\">$name</span>
                    </div>
                    <div>
                        <span class=\"label\">Email:</span>
                        <span class=\"value\">$email</span>
                    </div>
                    <div>
                        <span class=\"label\">Phone:</span>
                        <span class=\"value\">$phone</span>
                    </div>
                    <div>
                        <span class=\"label\">Membership:</span>
                        <span class=\"value\">$membershipName</span>
                    </div>
                    <div>
                        <span class=\"label\">Duration:</span>
                        <span class=\"value\">$duration days</span>
                    </div>
                    <div>
                        <span class=\"label\">Paid Status:</span>
                        <span class=\"value\">$paidstatus</span>
                    </div>
                </div>

                <div class=\"amount-section\">
                    <div class=\"amount-label\">Total Paid:</div>
                    <div class=\"amount-value\">RM $amount</div>
                </div>

                <div class=\"footer\">
                    <p>If you have any questions, please contact <a href=\"mailto:support@example.com\">support@example.com</a></p>
                </div>
            </div>
        </body>
        </html>";
        // End of successful payment receipt
        error_log("Success receipt displayed.");
        
    } else {
        // Payment failed
  error_log("Payment Fail. Inserting purchase record...");

        // Insert purchase record
        $insertPurchase = "INSERT INTO tbl_purchase (user_id, payment_amount, payment_status, purchase_date, membership_name) 
                           VALUES ('$userid', '$amount', 'Failed', NOW(), '$membershipName')";
        if (!$conn->query($insertPurchase)) {
            error_log("Error inserting purchase record: " . $conn->error);
            die("Error inserting purchase record: " . $conn->error);
        } else {
            error_log("Purchase record inserted successfully.");
        }

        $currentDate = date('Y-m-d');

        // Fetch membership duration
        $retrieveMembership = "SELECT membership_duration FROM membership WHERE membership_name = '$membershipName'";
        $result = $conn->query($retrieveMembership);

        if ($result->num_rows > 0) {
            $row = $result->fetch_assoc();
            $duration = $row['membership_duration'];
            error_log("Membership duration retrieved: $duration days.");

            $startDate = $currentDate;
            $endDate = date('Y-m-d', strtotime("+$duration days"));
            
            //verify the new mmebership payment is it already make but failed
            $retrieveMembershipRecord = "SELECT * FROM `membership_status` WHERE membership_name = '$membershipName'";
            $check = $conn->query($retrieveMembershipRecord);
            if($check->num_rows > 0){
                //Update the status to Active
            $updateMemberStatus = "UPDATE `membership_status` SET `start_date` = '$startDate', `end_date` = '$endDate', `status` = 'Deactive' WHERE `membership_name` = '$membershipName'";
            
             if (!$conn->query($updateMemberStatus)) {
                error_log("Error inserting membership record: " . $conn->error);
                die("Error inserting membership record: " . $conn->error);
            } else {
                error_log("Membership record updated successfully.");
            }
                
            }else{
            // Insert membership record
            $insertMembership = "INSERT INTO membership_status (user_id, membership_name, start_date, end_date, status)
                                 VALUES ('$userid', '$membershipName', '$startDate', '$endDate', 'Deactive')";
            if (!$conn->query($insertMembership)) {
                error_log("Error inserting membership record: " . $conn->error);
                die("Error inserting membership record: " . $conn->error);
            } else {
                error_log("Membership record inserted successfully.");
            }
               }
            
 
        } else {
            error_log("Error fetching membership duration: " . $conn->error);
            die("Error fetching membership duration: " . $conn->error);
        }


        // Print receipt for failed transaction
        echo "
        <!DOCTYPE html>
        <html lang=\"en\">
        <head>
            <meta charset=\"UTF-8\">
            <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
            <title>Payment Receipt - Failed</title>
            <style>
                body {
                    font-family: 'Arial', sans-serif;
                    margin: 0;
                    padding: 0;
                    background-color: #f9fafb;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    min-height: 100vh;
                }

                .receipt-container {
                    background-color: #fff;
                    border-radius: 12px;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
                    width: 100%;
                    max-width: 500px;
                    padding: 30px;
                    text-align: center;
                }

                .receipt-header {
                    margin-bottom: 20px;
                }

                .receipt-header img {
                    width: 80px;
                    height: 80px;
                    margin-bottom: 15px;
                }

                .receipt-header h1 {
                    font-size: 24px;
                    color: #991b1b;
                    margin-bottom: 5px;
                }

                .receipt-header p {
                    font-size: 14px;
                    color: #6b7280;
                }

                .receipt-status {
                    margin: 20px 0;
                    font-weight: 600;
                    font-size: 16px;
                    padding: 10px 20px;
                    display: inline-block;
                    border-radius: 30px;
                    background-color: #fee2e2;
                    color: #991b1b;
                }

                .receipt-details {
                    margin-top: 20px;
                    text-align: left;
                    font-size: 14px;
                    color: #374151;
                }

                .receipt-details div {
                    margin-bottom: 10px;
                    display: flex;
                    justify-content: space-between;
                }

                .receipt-details .label {
                    font-weight: 500;
                }

                .receipt-details .value {
                    font-weight: 600;
                    color: #111827;
                }

                .amount-section {
                    margin: 30px 0;
                    padding: 20px;
                    background-color: #fef2f2;
                    border-radius: 8px;
                }

                .amount-label {
                    font-size: 16px;
                    color: #991b1b;
                    margin-bottom: 5px;
                }

                .amount-value {
                    font-size: 28px;
                    font-weight: 700;
                    color: #991b1b;
                }

                .footer {
                    margin-top: 20px;
                    font-size: 12px;
                    color: #6b7280;
                }

                .footer a {
                    color: #1d4ed8;
                    text-decoration: none;
                }

                .footer a:hover {
                    text-decoration: underline;
                }

                .retry-button {
                    display: inline-block;
                    margin-top: 20px;
                    padding: 12px 20px;
                    background-color: #2563eb;
                    color: white;
                    font-weight: 600;
                    font-size: 14px;
                    border-radius: 8px;
                    text-decoration: none;
                    transition: background-color 0.2s ease;
                }

                .retry-button:hover {
                    background-color: #1e3a8a;
                }
            </style>
        </head>
        <body>
            <div class=\"receipt-container\">
                <div class=\"receipt-header\">
                    <h1>Payment Failed</h1>
                    <p>Unfortunately, your payment could not be processed.</p>
                </div>

                <div class=\"receipt-status\">
                    Payment Unsuccessful
                </div>

                <div class=\"receipt-details\">
                    <div>
                        <span class=\"label\">Receipt ID:</span>
                        <span class=\"value\">$receiptid</span>
                    </div>
                    <div>
                        <span class=\"label\">Name:</span>
                        <span class=\"value\">$name</span>
                    </div>
                    <div>
                        <span class=\"label\">Email:</span>
                        <span class=\"value\">$email</span>
                    </div>
                    <div>
                        <span class=\"label\">Phone:</span>
                        <span class=\"value\">$phone</span>
                    </div>
                    <div>
                        <span class=\"label\">Membership:</span>
                        <span class=\"value\">$membershipName</span>
                    </div>
                    <div>
                        <span class=\"label\">Duration:</span>
                        <span class=\"value\">$duration days</span>
                    </div>
                    <div>
                        <span class=\"label\">Paid Status:</span>
                        <span class=\"value\">$paidstatus</span>
                    </div>
                </div>

                <div class=\"amount-section\">
                    <div class=\"amount-label\">Transaction Amount:</div>
                    <div class=\"amount-value\">RM $amount</div>
                </div>

                <div class=\"footer\">
                    <p>If you have any questions, please contact <a href=\"mailto:support@example.com\">support@example.com</a></p>
                </div>
            </div>
        </body>
        </html>";
        
        error_log("Failed receipt displayed.");
    }
} else {
    // Signature mismatch
    error_log("Signature mismatch. Payment data not trusted. Exiting...");
    die("Signature mismatch. The request cannot be verified.");
}
?>
