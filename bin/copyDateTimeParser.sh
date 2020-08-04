#!/usr/bin/env php
<?php

$file = 'vendor/sabre/vobject/lib/DateTimeParser.php';
$newfile = '/../../vendor/sabre/vobject/lib/DateTimeParser.php';

if (!copy -r($file, $newfile)) {
    echo "A SNAFU has occoured and failed to copy $file...\n";
}else{
    echo "Success ... copied $file into $newfile\n";
}

?>
