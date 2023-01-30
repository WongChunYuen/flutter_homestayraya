<?php

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

if (isset($_POST['image'])) {
    include_once("dbconnect.php");
    $encoded_image = $_POST['image'];
    $userid = $_POST['userid'];
    $decoded_image = base64_decode($encoded_image);
    $path = '../assets/profileimages/' . $userid . '.png';
    $is_written = file_put_contents($path, $decoded_image);

    if ($is_written) {
        $sqlupdate = "UPDATE `users_tb` SET `user_image` = 'yes' WHERE `user_id` = '$userid'";
        if ($conn->query($sqlupdate) === true) {
            $sqlcheck = "SELECT * FROM `users_tb` WHERE user_id = '$userid'";
            $result = $conn->query($sqlcheck);
            if ($result->num_rows > 0) {
                while ($row = $result->fetch_assoc()) {
                    $userlist = array();
                    $userlist['id'] = $row['user_id'];
                    $userlist['image'] = $row['user_image'];
                    $userlist['name'] = $row['user_name'];
                    $userlist['email'] = $row['user_email'];
                    $userlist['phone'] = $row['user_phone'];
                    $userlist['address'] = $row['user_address'];
                    $userlist['verify'] = $row['user_verification'];
                    $regdateno = strtotime($row['user_datereg']);
                    $userlist['regdate'] = date("Y-m-d h:i:sa", $regdateno);
                    $userlist['otp'] = $row['otp'];
                    $response = array('status' => 'success', 'data' => $userlist);
                    sendJsonResponse($response);
                }
            }
        } else {
            $response = array('status' => 'failed', 'data' => null);
            sendJsonResponse($response);
        }
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
    die();
}

if (isset($_POST['newname'])) {
    $name = $_POST['newname'];
    $userid = $_POST['userid'];
    $sqlupdate = "UPDATE users_tb SET user_name ='$name' WHERE user_id = '$userid'";
    databaseUpdate($sqlupdate);
    die();
}

if (isset($_POST['newemail'])) {
    $email = $_POST['newemail'];
    $userid = $_POST['userid'];
    $sqlupdate = "UPDATE users_tb SET user_email ='$email' WHERE user_id = '$userid'";
    databaseUpdate($sqlupdate);
    die();
}

if (isset($_POST['newphone'])) {
    $phone = $_POST['newphone'];
    $userid = $_POST['userid'];
    $sqlupdate = "UPDATE users_tb SET user_phone ='$phone' WHERE user_id = '$userid'";
    databaseUpdate($sqlupdate);
    die();
}

if (isset($_POST['newaddress'])) {
    $address = $_POST['newaddress'];
    $userid = $_POST['userid'];
    $sqlupdate = "UPDATE users_tb SET user_address ='$address' WHERE user_id = '$userid'";
    databaseUpdate($sqlupdate);
    die();
}

if (isset($_POST['imageMyKad']) && isset($_POST['imageSelfie'])) {
    include_once("dbconnect.php");
    $encoded_imageMyKad = $_POST['imageMyKad'];
    $encoded_imageSelfie = $_POST['imageSelfie'];
    $userid = $_POST['userid'];
    $decoded_imageMyKad = base64_decode($encoded_imageMyKad);
    $decoded_imageSelfie = base64_decode($encoded_imageSelfie);
    $pathMyKad = '../assets/userverification/MyKad_' . $userid . '.png';
    $pathSelfie = '../assets/userverification/Selfie_' . $userid . '.png';
    $is_writtenMyKad = file_put_contents($pathMyKad, $decoded_imageMyKad);
    $is_writtenSelfie = file_put_contents($pathSelfie, $decoded_imageSelfie);

    if ($is_writtenMyKad && $is_writtenSelfie) {
        $sqlupdate = "UPDATE `users_tb` SET `user_verification` = 'yes' WHERE `user_id` = '$userid'";
        if ($conn->query($sqlupdate) === true) {
            $sqlcheck = "SELECT * FROM `users_tb` WHERE user_id = '$userid'";
            $result = $conn->query($sqlcheck);
            if ($result->num_rows > 0) {
                while ($row = $result->fetch_assoc()) {
                    $userlist = array();
                    $userlist['id'] = $row['user_id'];
                    $userlist['image'] = $row['user_image'];
                    $userlist['name'] = $row['user_name'];
                    $userlist['email'] = $row['user_email'];
                    $userlist['phone'] = $row['user_phone'];
                    $userlist['address'] = $row['user_address'];
                    $userlist['verify'] = $row['user_verification'];
                    $regdateno = strtotime($row['user_datereg']);
                    $userlist['regdate'] = date("Y-m-d h:i:sa", $regdateno);
                    $userlist['otp'] = $row['otp'];
                    $response = array('status' => 'success', 'data' => $userlist);
                    sendJsonResponse($response);
                }
            }
        } else {
            $response = array('status' => 'failed', 'data' => null);
            sendJsonResponse($response);
        }
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
    die();
}

function databaseUpdate($sql)
{
    include_once("dbconnect.php");
    if ($conn->query($sql) === true) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
