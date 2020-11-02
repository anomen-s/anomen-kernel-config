<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<title>Malina4</title>

<script>
function reloadingImage()
{
    src = '/fswebcam.jpg';
    document.getElementById("webcamImg").src = src + "?" + new Date();

    setTimeout(reloadingImage, 10000);
}
</script>
</head>
<body>

<h2><a href="/media/">media</a></h2> (<a href="/rescan.php">rescan</a>)
<h2><a href="/fm">sdílení souborů</a></h2>

<h2><a href="/scan/">scanner</a></h2>
<h2><a href="/network.php">LAN</a></h2>

<h2><a href="/wiki/">wiki</a></h2>
<h2><a href="/gpx/">gpx</a></h2>


<h2><a href="https://banan:631/">Tiskárny</a></h2>
<ul>
<li>http://banan:631/printers/Samsung_ML1640</li>
<li>http://banan:631/printers/Canon_MP150</li>
<li>
</ul>
<hr />
<form method="POST" action="addlink.php">
<h2>Stahování</h2>
<textarea  name="urls" id="urls" rows="4" cols="150" >
</textarea>
<br />
<input type="submit" value="odeslat odkaz" />
</form>


<hr />

<h2>Stromeček</h2>
<div>
<div style="float:left">
 <form method="POST" action="treelight.php">
  <label><input type="radio" name="tl" value="nowhite" />Světlo: ovládání vypínačem</label><br />
  <label><input type="radio" name="tl" value="whiteoff" />Světlo: vypnuto</label><br />
  <label><input type="radio" name="tl" value="white" />Světlo: zapnuto</label><br />
  <input type="submit" value="OK" />
 </form>
</div>
<div style="float:left">
 <form method="POST" action="treelight.php">
  <label><input type="radio" name="tl" value="disco" />Blikání: zapnuto</label><br />
  <label><input type="radio" name="tl" value="nodisco" />Blikání: vypnuto</label><br />
  <input type="submit" value="OK" />
 </form>
</div>
</div>


<hr style="clear:both;"/>
<div style="float:left">
<h2>webcam</h2>
<div>
<a href="/fswebcam.jpg">
<img width="320" height="240" src="/fswebcam.jpg" id="webcamImg" onclick="reloadingImage()"/>
</a>
</div>
</div>

<div style="float:right">
<h2 style="float:left">Senzory</h2>
<form method="POST" action="sensors.php" style="float:right">
<input type="submit" value="Aktualizovat" />
</form>
<pre style="clear:both">
<?php
 @readfile("/run/shm/sensors.txt");
?>
</pre>
</div>

</body>
</html>
