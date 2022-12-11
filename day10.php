<?php
$handle = fopen("input/day10.in", "r");
if(!$handle)
    exit(1);

function drawCrt($value, $cycles) {
    if(abs($value - $cycles%40) <= 1)
        echo "#";
    else
        echo ".";
    if($cycles%40 == 39)
        echo "\n";
}
        
    

$checkpoints = array(20, 60, 100, 140, 180, 220);
$it = 0;
$cycles = 0;
$value = 1;
$res = 0;


while (($line = fgets($handle)) !== false) {
    $instruction = explode(" ", $line);
    $instruction[0] = substr($instruction[0],0,4);
    $prevCycles = $cycles;
    $prevVal = $value;
    drawCrt($value, $cycles);
    $cycles ++;

    if($instruction[0] == "addx") {
        drawCrt($value, $cycles);
        $cycles ++;
        $value += intval($instruction[1]);
    }
    if($it < sizeof($checkpoints) && $prevCycles < $checkpoints[$it] && $cycles >= $checkpoints[$it]) {
        $res += $checkpoints[$it]*$prevVal;
        $it ++;
    }

}
fclose($handle);
echo $res;
?>