<?php

$r = exec("/usr/local/bin/s > /run/shm/sensors.txt" );

header("Location: /");
