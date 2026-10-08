<?php
session_start();
include "conexion.php";

// Si no inició sesión, lo mando al login
if (!isset($_SESSION["id"])) {
    header("Location: login.php");
    exit;
}

$st = $con->prepare("SELECT NombreUsuario FROM Perfiles WHERE ID_Usuario = ?");
$st->bind_param("i", $_SESSION["id"]);
$st->execute();
$st->bind_result($nombre);
$st->fetch();
$st->close();
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Inicio</title>
    <style> body { font-family: Arial, sans-serif; margin: 20px; } </style>
</head>
<body>
    <h1>Bienvenido, <?php echo htmlspecialchars($nombre ?? "usuario"); ?></h1>
    <p>Sesión iniciada correctamente.</p>
    <a href="logout.php">Cerrar sesión</a>
</body>
</html>
