<html>
<body>
<pre>
<?php

$output = array();
exec("/usr/local/bin/arp-list", $output );

foreach ($output as $l) {
 if($l[0] == '1') {
  echo $l;
  echo "\n";
 }
}
?>
</pre>
</body>
</html>

