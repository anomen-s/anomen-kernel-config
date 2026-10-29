<?php

$urls=$_REQUEST['urls'] . "\n";

$fn = '/var/www/html/list.txt';
$fnh = '/var/www/html/history.txt';

file_put_contents( $fn, $urls, FILE_APPEND);
file_put_contents( $fnh, $urls, FILE_APPEND);

header("Location: /");
