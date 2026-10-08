<?php
session_start();
include "conexion.php";

$msg = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = trim($_POST["email"]);
    $clave = $_POST["clave"];

    $st = $con->prepare("SELECT ID_Usuario, `Contraseña`, Estado FROM Usuarios WHERE Email = ?");
    $st->bind_param("s", $email);
    $st->execute();
    $st->bind_result($id, $hash, $estado);

    if ($st->fetch() && password_verify($clave, $hash)) {
        if ($estado == "Activo") {
            session_regenerate_id(true);
            $_SESSION["id"] = $id;
            header("Location: inicio.php");
            exit;
        } else {
            $msg = "Tu cuenta está " . $estado . ".";
        }
    } else {
        $msg = "Email o contraseña incorrectos.";
    }
    $st->close();
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Iniciar sesión</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; max-width: 400px; }
        input, button { margin: 5px 0; padding: 8px; width: 100%; box-sizing: border-box; }
    </style>
</head>
<body>
    <h1>Iniciar sesión</h1>
    <?php if ($msg != "") { echo "<p><b>" . htmlspecialchars($msg) . "</b></p>"; } ?>

    <form method="post">
        <input type="email" name="email" placeholder="Email" required>
        <input type="password" name="clave" placeholder="Contraseña" required>
        <button type="submit">Entrar</button>
    </form>

    <p>¿No tienes cuenta? <a href="registro.php">Crear cuenta</a></p>
</body>
</html>
