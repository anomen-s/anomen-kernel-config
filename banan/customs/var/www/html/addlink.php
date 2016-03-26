<?php

$urls="\n" . $_REQUEST['urls'];

$fn = '/var/www/html/list.txt';

file_put_contents( $fn, $urls, FILE_APPEND);

header("Location: index.html");
