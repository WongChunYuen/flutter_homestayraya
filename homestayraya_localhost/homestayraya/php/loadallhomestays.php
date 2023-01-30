<?php

    error_reporting(0);
    include_once("dbconnect.php");
    $search  = $_GET["search"];
    $results_per_page = 6;
    $pageno = (int)$_GET['pageno'];
    $page_first_result = ($pageno - 1) * $results_per_page;

    if ($search =="all") {
        $sqlloadhomestay = "SELECT * FROM homestays_tb ORDER BY homestay_date DESC";
    } else {
        $sqlloadhomestay = "SELECT * FROM homestays_tb WHERE homestay_name LIKE '%$search%' ORDER BY homestay_date DESC";
    }

    $result = $conn->query($sqlloadhomestay);
    $number_of_result = $result->num_rows;
    $number_of_page = ceil($number_of_result / $results_per_page);
    $sqlloadhomestay = $sqlloadhomestay . " LIMIT $page_first_result , $results_per_page";
    $result = $conn->query($sqlloadhomestay);

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
        $response = array('status' => 'success', 'numofpage'=>"$number_of_page",'numberofresult'=>"$number_of_result",'data' => $homestaysarray);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed','numofpage'=>"$number_of_page", 'numberofresult'=>"$number_of_result",'data' => null);
        sendJsonResponse($response);
    }
    $conn->close();
    function sendJsonResponse($sentArray)
    {
        header('Content-Type: application/json');
        echo json_encode($sentArray);
    }
