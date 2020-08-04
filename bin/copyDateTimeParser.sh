#!/usr/bin/env php
<?php

$orig_file = INSTALL_PATH . 'vendor/sabre/vobject/lib/DateTimeParser.php';
$mod_file = INSTALL_PATH . 'plugins/calendar/vendor/sabre/vobject/lib/DateTimeParser.php';

if (!copy($orig_file, $mod_file)) {
    echo "A SNAFU has occurred and failed to overwrite $orig_file with proper $mod_file ...\n";
}else{
    echo "Success ... $orig_file overwrote $mod_file to fix all_day recurring event ...\n";
}

?>
