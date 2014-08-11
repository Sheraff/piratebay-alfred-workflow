<?php
require_once ('workflows.php');
$w = new Workflows();

$cache = $w->cache();
$expiration = time() - 48 * 3600;

$di = new RecursiveDirectoryIterator($cache);
foreach (new RecursiveIteratorIterator($di) as $filename => $file) {
	if (strpos(basename($filename), ".") !== 0) {
		if (intval(explode(".", basename($filename)) [0]) < $expiration && strcmp(basename($filename), "history.db")!==0) unlink($filename);
	}
}
RemoveEmptySubFolders($cache);

function RemoveEmptySubFolders($path) {
	$empty = true;
	foreach (glob($path . DIRECTORY_SEPARATOR . "*") as $file) {
		$empty&= is_dir($file) && RemoveEmptySubFolders($file);
	}
	return $empty && rmdir($path);
}
?>