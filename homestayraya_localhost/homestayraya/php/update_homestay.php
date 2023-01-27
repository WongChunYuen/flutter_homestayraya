 <?php
    if (!isset($_POST)) {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
        die();
    }
    include_once("dbconnect.php");
$userid = $_POST['userid'];
$homestayid = $_POST['homestayid'];
$hsname= ucwords(addslashes($_POST['hsname']));
$hsdesc= ucfirst(addslashes($_POST['hsdesc']));
$hsprice= $_POST['hsprice'];
$hsaddr= addslashes($_POST['hsaddr']);
$imageList= $_POST["image"];
$image = json_decode($imageList);
$imagelength = count($image);


$sqlupdate = "UPDATE `homestays_tb` SET `homestay_name`='$hsname',`homestay_desc`='$hsdesc',`homestay_price`='$hsprice',`homestay_address`='$hsaddr', `homestay_imagesNum`= '$imagelength' WHERE `homestay_id` = '$homestayid' AND `user_id` = '$userid'";

try {
    if ($conn->query($sqlupdate) === true) {
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
    header('Content-Type= application/json');
    echo json_encode($sentArray);
}
?>