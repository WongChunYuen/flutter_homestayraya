<?php

    if (!isset($_POST['registerhomestay'])) {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
        die();
    }
    include_once("dbconnect.php");
    $userid = $_POST['userid'];
    $hsname= ucwords(addslashes($_POST['hsname']));
    $hsdesc= ucfirst(addslashes($_POST['hsdesc']));
    $hsprice= $_POST['hsprice'];
    $hsaddr= addslashes($_POST['hsaddr']);
    $state= addslashes($_POST['state']);
    $local= addslashes($_POST['local']);
    $lat= $_POST['lat'];
    $lon= $_POST['lon'];
    $imageList= $_POST["image"];
    $image = json_decode($imageList);
    $imagelength = count($image);

    $sqlinsert = "INSERT INTO `homestays_tb`(`user_id`, `homestay_imagesNum`, `homestay_name`, `homestay_desc`, `homestay_price`, `homestay_address`, `homestay_state`, `homestay_local`, `homestay_lat`, `homestay_lng`) VALUES ('$userid','$imagelength','$hsname','$hsdesc','$hsprice','$hsaddr','$state','$local','$lat','$lon')";

    try {
        if ($conn->query($sqlinsert) === true) {
            $filename = mysqli_insert_id($conn);

            foreach ($image as $key => $value) {
                $imageB64 = base64_decode($value);
                $index = $key + 1;
                file_put_contents('../assets/homestayimages/'.$filename.'_'.$index.'.png', $imageB64);
            }

            $response = array('status' => 'success', 'data' => null);
            sendJsonResponse($response);
        } else {
            $response = array('status' => 'failed', 'data' => null);
            sendJsonResponse($response);
        }
    } catch(Exception $e) {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
    $conn->close();
    function sendJsonResponse($sentArray)
    {
        header('Content-Type: application/json');
        echo json_encode($sentArray);
    }
