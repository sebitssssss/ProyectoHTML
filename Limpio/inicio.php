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
 
$st2 = $con->prepare("SELECT Texto, FechaPublicacion, Privacidad FROM Publicaciones WHERE Privacidad = 'Pública' OR ID_Usuario = ? ORDER BY FechaPublicacion DESC");
$st2->bind_param("i", $_SESSION["id"]);
$st2->execute();
$publicaciones = $st2->get_result();
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Inicio</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style> body { font-family: Arial, sans-serif; margin: 20px; } </style>
</head>
<body>
    <h1>Bienvenido, <?php echo htmlspecialchars($nombre ?? "usuario"); ?></h1>
    <p>Sesión iniciada correctamente.</p>
    <a href="logout.php">Cerrar sesión</a>
 
    <h2 class="mt-4">Publicaciones</h2>
 
    <table class="table table-bordered">
        <tr>
            <th>Texto</th>
            <th>Fecha</th>
            <th>Privacidad</th>
        </tr>
        <?php while ($fila = $publicaciones->fetch_assoc()) { ?>
            <tr>
                <td><?php echo htmlspecialchars($fila["Texto"]); ?></td>
                <td><?php echo htmlspecialchars($fila["FechaPublicacion"]); ?></td>
                <td><?php echo htmlspecialchars($fila["Privacidad"]); ?></td>
            </tr>
        <?php } ?>
    </table>
</body>
</html>
