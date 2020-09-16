<?php

$tl = $_REQUEST['tl'];

$r = exec("sudo service minidlna force-reload" );


header("Location: /");
