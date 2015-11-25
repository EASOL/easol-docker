<?php
    $username = $_ENV['EASOL_USERNAME'];
    $password = $_ENV['EASOL_PASSWORD'];
    $database = $_ENV['EASOL_DATABASE'];

    $link = mssql_connect('easol', $username, $password);

    if (!$link) {
        die("<p><strong>Unable to connect to the EASOL server</strong></p>");
    } else {
        echo "<p><strong>Connection to EASOL server was successful.</strong></p>";
    }

    $result = mssql_query('SELECT * FROM information_schema.tables');

    echo "<p><strong>Tables in this database:</strong></p>";
    echo "<ul>";
    while ($row = mssql_fetch_array($result)) {
        echo "<li>", $row['TABLE_NAME'], "</li>";
    }
    echo "</ul>";

    mssql_free_result($result);
?>