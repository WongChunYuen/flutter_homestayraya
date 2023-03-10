<?php

    error_reporting(0);
    if (!isset($_GET['userid'])) {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
        die();
    }
    $userid = $_GET['userid'];
    include_once("dbconnect.php");
    $sqlload = "SELECT * FROM homestays_tb WHERE user_id = '$userid'";
    $result = $conn->query($sqlload);
    if ($result->num_rows > 0) {
        $homestaysarray["homestays"] = array();
        while ($row = $result->fetch_assoc()) {
            $hslist = array();
            $hslist['homestay_id'] = $row['homestay_id'];
            $hslist['user_id'] = $row['user_id'];
            $hslist['homestay_imagesNum'] = $row['homestay_imagesNum'];
            $hslist['homestay_name'] = $row['homestay_name'];
            $hslist['homestay_desc'] = $row['homestay_desc'];
            $hslist['homestay_price'] = $row['homestay_price'];
            $hslist['homestay_address'] = $row['homestay_address'];
            $hslist['homestay_state'] = $row['homestay_state'];
            $hslist['homestay_local'] = $row['homestay_local'];
            $hslist['homestay_lat'] = $row['homestay_lat'];
            $hslist['homestay_lng'] = $row['homestay_lng'];
            $hsregdate = strtotime($row['homestay_date']);
            $hslist['homestay_date'] = date("Y-m-d h:i a", $hsregdate);
            array_push($homestaysarray["homestays"], $hslist);
        }
        $response = array('status' => 'success', 'data' => $homestaysarray);
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
