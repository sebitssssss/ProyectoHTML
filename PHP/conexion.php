<?php
$host    = "localhost";
$usuario = "root";
$clave   = "";
$bd      = "Red_Social";

$con = new mysqli($host, $usuario, $clave, $bd);

if ($con->connect_error) {
    die("Error de conexión: " . $con->connect_error);
}

$con->set_charset("utf8mb4");
?>
