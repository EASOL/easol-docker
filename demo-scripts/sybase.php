<?php
    $username = $_ENV['EASOL_USERNAME'];
    $password = $_ENV['EASOL_PASSWORD'];

    $link = mssql_connect('easol', $username, $password);

    if (!$link) {
        die("<p><strong>Unable to connect to the EASOL server</strong></p>");
    } else {
        echo "<p><strong>Connection to EASOL server was successful.</strong></p>";

        $result = mssql_query('SELECT DB_NAME()');
        $database = mssql_fetch_array($result)['computed'];

        $result = mssql_query('SELECT * FROM information_schema.tables');
        echo "<p><strong>Tables in $database database:</strong></p>";
        echo "<ul>";
        while ($row = mssql_fetch_array($result)) {
            echo "<li>", $row['TABLE_NAME'], "</li>";
        }
        echo "</ul>";

        mssql_free_result($result);
    }
?>