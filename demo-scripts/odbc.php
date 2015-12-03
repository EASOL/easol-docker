<?php
    $username = $_ENV['EASOL_USERNAME'];
    $password = $_ENV['EASOL_PASSWORD'];

    $link = odbc_connect("easol", $username, $password);

    if (!$link) {
        die("<p><strong>Unable to connect to the EASOL server</strong></p>");
    } else {
        echo "<p><strong>Connection to EASOL server was successful.</strong></p>";
    }

    $result = odbc_exec($link, 'SELECT * FROM information_schema.tables WHERE TABLE_SCHEMA=\'EASOL\'');
    odbc_result_all($result);

    odbc_close($link);
?>
