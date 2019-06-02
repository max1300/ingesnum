<?php

echo "Hello world";

try {
    $dbh = new PDO('mysql:host=mysql;dbname=myproject', 'myproject', 'mypassword');
    $dbh = null;
} catch (PDOException $e) {
    print "Erreur !: " . $e->getMessage() . "<br/>";
    die();
}
