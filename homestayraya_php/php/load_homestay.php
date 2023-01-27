<?php
	error_reporting(0);
	if (!isset($_GET['userid'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
	}
	$userid = $_GET['userid'];
	include_once("dbconnect.php");
	$sqlload = "SELECT * FROM products_tb WHERE user_id = '$userid'";
	$result = $conn->query($sqlload);
	if ($result->num_rows > 0) {
		$productsarray["products"] = array();
		while ($row = $result->fetch_assoc()) {
			$hslist = array();
			$hslist['product_id'] = $row['product_id'];
			$hslist['user_id'] = $row['user_id'];
			$hslist['product_name'] = $row['product_name'];
			$hslist['product_desc'] = $row['product_desc'];
			$hslist['product_price'] = $row['product_price'];
			$hslist['product_address'] = $row['product_address'];
			$hslist['product_state'] = $row['product_state'];
			$hslist['product_local'] = $row['product_local'];
			$hslist['product_lat'] = $row['product_lat'];
			$hslist['product_lng'] = $row['product_lng'];
			$hslist['product_date'] = $row['product_date'];
			array_push($productsarray["products"],$hslist);
		}
		$response = array('status' => 'success', 'data' => $productsarray);
    sendJsonResponse($response);
		}else{
		$response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
	}
	
	function sendJsonResponse($sentArray)
	{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
	}