<?php
include "conexion.php";

$msg = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $nombre = trim($_POST["nombre"]);
    $email  = trim($_POST["email"]);
    $clave  = $_POST["clave"];
    $dosfa  = isset($_POST["dosfa"]) ? 1 : 0;

    // Revisar que el email no exista
    $st = $con->prepare("SELECT ID_Usuario FROM Usuarios WHERE Email = ?");
    $st->bind_param("s", $email);
    $st->execute();
    $st->store_result();

    if ($st->num_rows > 0) {
        $msg = "Ese email ya está registrado.";
    } else {
        $hash = password_hash($clave, PASSWORD_DEFAULT);

        $st2 = $con->prepare("INSERT INTO Usuarios (Email, `Contraseña`, `2FA`, FechaRegistro, Estado)
                              VALUES (?, ?, ?, CURDATE(), 'Activo')");
        $st2->bind_param("ssi", $email, $hash, $dosfa);

        if ($st2->execute()) {
            $id = $con->insert_id;

            // Crear el perfil con el nombre de usuario
            $st3 = $con->prepare("INSERT INTO Perfiles (ID_Usuario, NombreUsuario) VALUES (?, ?)");
            $st3->bind_param("is", $id, $nombre);
            $st3->execute();
            $st3->close();

            $msg = "Cuenta creada. Ya puedes iniciar sesión.";
        } else {
            $msg = "Error al crear la cuenta.";
        }
        $st2->close();
    }
    $st->close();
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Crear cuenta</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; max-width: 400px; }
        input, button { margin: 5px 0; padding: 8px; width: 100%; box-sizing: border-box; }
        input[type=checkbox] { width: auto; }
    </style>
</head>
<body>
    <h1>Crear cuenta</h1>
    <?php if ($msg != "") { echo "<p><b>" . htmlspecialchars($msg) . "</b></p>"; } ?>

    <form method="post">
        <input type="text" name="nombre" placeholder="Nombre de usuario" required>
        <input type="email" name="email" placeholder="Email" required>
        <input type="password" name="clave" placeholder="Contraseña" required>
        <label><input type="checkbox" name="dosfa"> Activar 2FA</label>
        <button type="submit">Registrarme</button>
    </form>

    <p>¿Ya tienes cuenta? <a href="login.php">Iniciar sesión</a></p>
</body>
</html>
