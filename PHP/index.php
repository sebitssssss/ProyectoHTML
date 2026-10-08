<?php
include "conexion.php";

$msg = "";

// Guardar usuario nuevo
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email  = $_POST["email"];
    $pass   = password_hash($_POST["clave"], PASSWORD_DEFAULT);
    $dosfa  = isset($_POST["dosfa"]) ? 1 : 0;
    $estado = $_POST["estado"];

    $sql = "INSERT INTO Usuarios (Email, `Contraseña`, `2FA`, FechaRegistro, Estado)
            VALUES (?, ?, ?, CURDATE(), ?)";
    $st = $con->prepare($sql);
    $st->bind_param("ssis", $email, $pass, $dosfa, $estado);

    if ($st->execute()) {
        $msg = "Usuario guardado correctamente.";
    } else {
        $msg = "Error al guardar: " . $st->error;
    }
    $st->close();
}

// Listado de usuarios
$res = $con->query("SELECT ID_Usuario, Email, `2FA`, FechaRegistro, Estado
                    FROM Usuarios ORDER BY ID_Usuario DESC");
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Red Social - Usuarios</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        input, select, button { margin: 5px 0; padding: 6px; }
        table { border-collapse: collapse; width: 100%; margin-top: 15px; }
        th, td { border: 1px solid #999; padding: 6px; text-align: left; }
        th { background: #eee; }
    </style>
</head>
<body>
    <h1>Registrar usuario</h1>

    <?php if ($msg != "") { echo "<p><b>" . htmlspecialchars($msg) . "</b></p>"; } ?>

    <form method="post">
        <label>Email:</label><br>
        <input type="email" name="email" required><br>

        <label>Contraseña:</label><br>
        <input type="password" name="clave" required><br>

        <label><input type="checkbox" name="dosfa"> Activar 2FA</label><br>

        <label>Estado:</label><br>
        <select name="estado">
            <option>Activo</option>
            <option>Inactivo</option>
            <option>Suspendido</option>
        </select><br>

        <button type="submit">Guardar</button>
    </form>

    <h2>Usuarios registrados</h2>
    <table>
        <tr>
            <th>ID</th><th>Email</th><th>2FA</th><th>Registro</th><th>Estado</th>
        </tr>
        <?php while ($f = $res->fetch_assoc()) { ?>
        <tr>
            <td><?php echo $f["ID_Usuario"]; ?></td>
            <td><?php echo htmlspecialchars($f["Email"]); ?></td>
            <td><?php echo $f["2FA"] ? "Sí" : "No"; ?></td>
            <td><?php echo $f["FechaRegistro"]; ?></td>
            <td><?php echo $f["Estado"]; ?></td>
        </tr>
        <?php } ?>
    </table>
</body>
</html>
<?php $con->close(); ?>
