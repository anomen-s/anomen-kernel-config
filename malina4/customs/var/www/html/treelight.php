<?php

$tl = $_REQUEST['tl'];

$r = exec("/usr/local/bin/treelight-mcp " . escapeshellarg($tl) );


header("Location: /");
