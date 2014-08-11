<?php
require_once('workflows.php');
$w = new Workflows();
$cache = $w->cache();

$data = unserialize("{query}");
$id = $data['id'];

$history = array();
if(file_exists("$cache/history.db")){
	$history = unserialize(file_get_contents("$cache/history.db"));
}

array_push($history, $id);

file_put_contents("$cache/history.db", serialize($history));
?>