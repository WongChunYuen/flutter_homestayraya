<?php
if (!isset($_POST['register'])) {
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
	die();
}

include_once("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = sha1($_POST['password']);
$otp = rand(100000, 999999);
$address = "na";

$sqlinsert = "INSERT INTO `users_tb`(`user_email`, `user_name`, `user_password`, `user_phone`, `user_address`, `otp`) VALUES ('$email','$name','$password', '$phone','$address','$otp')";

try {
	if ($conn->query($sqlinsert) === TRUE) {
		$response = array('status' => 'success', 'data' => null);
		sendJsonResponse($response);
	} else {
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
	}

} catch (Exception $e) {
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

$conn->close();

function sendJsonResponse($sentArray)
{
	header('Content-Type: application/json');
	echo json_encode($sentArray);
}

?>