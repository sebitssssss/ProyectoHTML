<?php
session_start();
header('Content-Type: application/json; charset=utf-8');

$servidor = 'localhost';
$baseDatos = 'Red_Social';
$usuarioBd = 'root';
$claveBd = '';

function responder($ok, $codigo = 200, $datos = []) {
    http_response_code($codigo);
    echo json_encode(array_merge(['ok' => $ok], $datos));
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    responder(false, 405);
}

if (empty($_SESSION['ID_Usuario'])) {
    responder(false, 401);
}

if (!isset($_FILES['foto']) || $_FILES['foto']['error'] !== UPLOAD_ERR_OK) {
    responder(false, 400);
}

$archivo = $_FILES['foto'];

if ($archivo['size'] > 5 * 1024 * 1024) {
    responder(false, 413);
}

$extensiones = ['image/jpeg' => 'jpg', 'image/png' => 'png'];
$mime = (new finfo(FILEINFO_MIME_TYPE))->file($archivo['tmp_name']);

if (!isset($extensiones[$mime])) {
    responder(false, 415);
}

$carpeta = __DIR__ . '/uploads/perfiles/';

if (!is_dir($carpeta) && !mkdir($carpeta, 0755, true)) {
    responder(false, 500);
}

$nombre = bin2hex(random_bytes(16)) . '.' . $extensiones[$mime];

if (!move_uploaded_file($archivo['tmp_name'], $carpeta . $nombre)) {
    responder(false, 500);
}

$url = 'uploads/perfiles/' . $nombre;

try {
    $pdo = new PDO(
        "mysql:host=$servidor;dbname=$baseDatos;charset=utf8mb4",
        $usuarioBd,
        $claveBd,
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );

    $pdo->beginTransaction();

    $insertar = $pdo->prepare('INSERT INTO FotoPerfil (URL, Archivo, FechaSubida) VALUES (?, ?, CURDATE())');
    $insertar->execute([$url, $nombre]);
    $idFoto = $pdo->lastInsertId();

    $actualizar = $pdo->prepare('UPDATE Perfiles SET ID_FotoPerfil = ? WHERE ID_Usuario = ?');
    $actualizar->execute([$idFoto, $_SESSION['ID_Usuario']]);

    if ($actualizar->rowCount() === 0) {
        throw new Exception();
    }

    $pdo->commit();
    responder(true, 200, ['url' => $url]);
} catch (Throwable $e) {
    if (isset($pdo) && $pdo->inTransaction()) {
        $pdo->rollBack();
    }
    unlink($carpeta . $nombre);
    responder(false, 500);
}
