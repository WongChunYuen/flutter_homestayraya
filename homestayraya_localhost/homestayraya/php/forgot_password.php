<?php

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['submit'])) {
    $email = $_POST['email'];
    $sql = "SELECT * FROM `users_tb` WHERE user_email = '$email'";
    $result = $conn->query($sql);
    try {
        if ($result->num_rows > 0) {
            $response = array('status' => 'success', 'data' => $email);
            sendJsonResponse($response);
        } else {
            $response = array('status' => 'failed', 'data' => null);
            sendJsonResponse($response);
        }
    } catch (Exception $e) {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}

if (isset($_POST['reset'])) {
    $email = $_POST['reEmail'];
    $newpass = sha1($_POST['password']);
    $sql = "UPDATE `users_tb` SET `user_password`='$newpass' WHERE user_email = '$email'";
    $result = $conn->query($sql);
    if ($result) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}

$conn->close();
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
