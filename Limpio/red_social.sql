Create DataBase Red_Social;
Use Red_Social;

CREATE TABLE Usuarios (
    ID_Usuario INT AUTO_INCREMENT PRIMARY KEY,
    Email VARCHAR(100),
    Contraseña VARCHAR(255),
    2FA BOOL,
    FechaRegistro DATE,
    Estado ENUM('Activo', 'Inactivo', 'Suspendido')
);

CREATE TABLE FotoPerfil (
    ID_FotoPerfil INT AUTO_INCREMENT PRIMARY KEY,
    URL VARCHAR(255),
    Archivo VARCHAR(255),
    FechaSubida DATE
);

CREATE TABLE Paises (
    ID_Pais INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100)
);

CREATE TABLE TiposInt (
    ID_TipoInt INT AUTO_INCREMENT PRIMARY KEY,
    Descripcion VARCHAR(255)
);

CREATE TABLE TiposNotificacion (
    ID_TipoNotificacion INT AUTO_INCREMENT PRIMARY KEY,
    Descripcion VARCHAR(255)
);

CREATE TABLE RolesGrupo (
    ID_Rol INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50)
);

CREATE TABLE Perfiles (
    ID_Perfil INT AUTO_INCREMENT PRIMARY KEY,
    ID_Usuario INT NOT NULL,
    ID_FotoPerfil INT,
    ID_Pais INT,
    NombreUsuario VARCHAR(50),
    Biografia VARCHAR(255),
    FechaNacimiento DATE,
    FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario),
    FOREIGN KEY (ID_FotoPerfil) REFERENCES FotoPerfil(ID_FotoPerfil),
    FOREIGN KEY (ID_Pais) REFERENCES Paises(ID_Pais)
);

CREATE TABLE Publicaciones (
    ID_Publicacion INT AUTO_INCREMENT PRIMARY KEY,
    ID_Usuario INT NOT NULL,
    Texto VARCHAR(255),
    FechaPublicacion DATE,
    Privacidad ENUM('Pública', 'Privada', 'Amigos'),
    FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario)
);

CREATE TABLE Chats (
    ID_Chat INT AUTO_INCREMENT PRIMARY KEY,
    ID_UsuarioE INT NOT NULL,
    ID_UsuarioR INT NOT NULL,
    FechaCreacion DATE,
    FOREIGN KEY (ID_UsuarioE) REFERENCES Usuarios(ID_Usuario),
    FOREIGN KEY (ID_UsuarioR) REFERENCES Usuarios(ID_Usuario)
);

CREATE TABLE Amigos (
    ID_Amigo INT AUTO_INCREMENT PRIMARY KEY,
    ID_Usuario INT NOT NULL,
    ID_UsuarioAmigo INT NOT NULL,
    Estado ENUM('Pendiente', 'Aceptado', 'Bloqueado'),
    FechaAlta DATE,
    FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario),
    FOREIGN KEY (ID_UsuarioAmigo) REFERENCES Usuarios(ID_Usuario)
);

CREATE TABLE Notificaciones (
    ID_Notificacion INT AUTO_INCREMENT PRIMARY KEY,
    ID_Usuario INT NOT NULL,
    ID_TipoNotificacion INT NOT NULL,
    Texto VARCHAR(255),
    Fecha DATE,
    Leida BOOL,
    FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario),
    FOREIGN KEY (ID_TipoNotificacion) REFERENCES TiposNotificacion(ID_TipoNotificacion)
);

CREATE TABLE Grupos (
    ID_Grupo INT AUTO_INCREMENT PRIMARY KEY,
    ID_Dueño INT NOT NULL,
    Nombre VARCHAR(100),
    Descripcion VARCHAR(255),
    FechaCreacion DATE,
    FOREIGN KEY (ID_Dueño) REFERENCES Usuarios(ID_Usuario)
);

CREATE TABLE Multimedia (
    ID_Multimedia INT AUTO_INCREMENT PRIMARY KEY,
    ID_Publicacion INT NOT NULL,
    URL VARCHAR(255),
    TipoArchivo ENUM('Imagen', 'Video', 'Audio', 'Documento'),
    FOREIGN KEY (ID_Publicacion) REFERENCES Publicaciones(ID_Publicacion)
);

CREATE TABLE Comentarios (
    ID_Comentario INT AUTO_INCREMENT PRIMARY KEY,
    ID_Publicacion INT NOT NULL,
    ID_Usuario INT NOT NULL,
    Texto VARCHAR(255),
    Fecha DATE,
    FOREIGN KEY (ID_Publicacion) REFERENCES Publicaciones(ID_Publicacion),
    FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario)
);

CREATE TABLE Interacciones (
    ID_Interaccion INT AUTO_INCREMENT PRIMARY KEY,
    ID_Usuario INT NOT NULL,
    ID_Publicacion INT NOT NULL,
    ID_TipoInt INT NOT NULL,
    Fecha DATE,
    FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario),
    FOREIGN KEY (ID_Publicacion) REFERENCES Publicaciones(ID_Publicacion),
    FOREIGN KEY (ID_TipoInt) REFERENCES TiposInt(ID_TipoInt)
);

CREATE TABLE Mensajes (
    ID_Mensaje INT AUTO_INCREMENT PRIMARY KEY,
    ID_Chat INT NOT NULL,
    ID_UsuarioEmisor INT NOT NULL,
    Texto VARCHAR(255),
    FechaEnvio DATE,
    Leido BOOL,
    FOREIGN KEY (ID_Chat) REFERENCES Chats(ID_Chat),
    FOREIGN KEY (ID_UsuarioEmisor) REFERENCES Usuarios(ID_Usuario)
);

CREATE TABLE Grupos_Usuarios (
    ID_GrupoUsuario INT AUTO_INCREMENT PRIMARY KEY,
    ID_Grupo INT NOT NULL,
    ID_Usuario INT NOT NULL,
    ID_Rol INT NOT NULL,
    FechaIngreso DATE,
    FOREIGN KEY (ID_Grupo) REFERENCES Grupos(ID_Grupo),
    FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario),
    FOREIGN KEY (ID_Rol) REFERENCES RolesGrupo(ID_Rol)
);


INSERT INTO Usuarios (Email, `Contraseña`, `2FA`, FechaRegistro, Estado) VALUES
('juan@correo.com', '$2y$12$s5Mm/yl3XY4DnpNzzER2yebX4j7HdkTfzvpmsrxvFLAF2yGQ1vPbi', 0, '2026-09-01', 'Activo'),
('maria@correo.com', '$2y$12$s5Mm/yl3XY4DnpNzzER2yebX4j7HdkTfzvpmsrxvFLAF2yGQ1vPbi', 0, '2026-09-03', 'Activo'),
('lucas@correo.com', '$2y$12$s5Mm/yl3XY4DnpNzzER2yebX4j7HdkTfzvpmsrxvFLAF2yGQ1vPbi', 1, '2026-09-05', 'Activo'),
('sofia@correo.com', '$2y$12$s5Mm/yl3XY4DnpNzzER2yebX4j7HdkTfzvpmsrxvFLAF2yGQ1vPbi', 0, '2026-09-08', 'Inactivo'),
('pedro@correo.com', '$2y$12$s5Mm/yl3XY4DnpNzzER2yebX4j7HdkTfzvpmsrxvFLAF2yGQ1vPbi', 0, '2026-09-10', 'Suspendido');
 
INSERT INTO FotoPerfil (URL, Archivo, FechaSubida) VALUES
('uploads/perfiles/foto1.jpg', 'foto1.jpg', '2026-09-02'),
('uploads/perfiles/foto2.jpg', 'foto2.jpg', '2026-09-04'),
('uploads/perfiles/foto3.png', 'foto3.png', '2026-09-06'),
('uploads/perfiles/foto4.jpg', 'foto4.jpg', '2026-09-09'),
('uploads/perfiles/foto5.png', 'foto5.png', '2026-09-11');
 
INSERT INTO Paises (Nombre) VALUES
('Argentina'),
('Chile'),
('Uruguay'),
('España'),
('México');
 
INSERT INTO TiposInt (Descripcion) VALUES
('Me gusta'),
('Me encanta'),
('Me divierte'),
('Me asombra'),
('Me entristece');
 
INSERT INTO TiposNotificacion (Descripcion) VALUES
('Nuevo comentario'),
('Nuevo me gusta'),
('Solicitud de amistad'),
('Nuevo mensaje'),
('Invitación a grupo');
 
INSERT INTO RolesGrupo (Nombre) VALUES
('Administrador'),
('Moderador'),
('Miembro'),
('Invitado'),
('Fundador');
 
INSERT INTO Perfiles (ID_Usuario, ID_FotoPerfil, ID_Pais, NombreUsuario, Biografia, FechaNacimiento) VALUES
(1, 1, 1, 'juan123', 'Me gusta la programación y el fútbol.', '2008-03-15'),
(2, 2, 2, 'maria_g', 'Estudiante de escuela técnica.', '2008-07-22'),
(3, 3, 3, 'lucas_dev', 'Aprendiendo PHP y MySQL.', '2007-11-05'),
(4, 4, 4, 'sofi_97', 'Amante de la música y los viajes.', '2008-01-30'),
(5, 5, 5, 'pedro_m', 'Me gustan los videojuegos.', '2007-09-12');
 
INSERT INTO Publicaciones (ID_Usuario, Texto, FechaPublicacion, Privacidad) VALUES
(1, 'Hola a todos, esta es mi primera publicación.', '2026-10-20', 'Pública'),
(2, 'Hoy tuvimos examen de programación en la escuela.', '2026-10-22', 'Pública'),
(3, 'Estoy aprendiendo PHP y MySQL para mi proyecto.', '2026-10-24', 'Pública'),
(1, 'Este mensaje es solo para mis amigos.', '2026-10-26', 'Amigos'),
(2, 'Una nota privada para recordar la entrega.', '2026-10-28', 'Privada');
 
INSERT INTO Chats (ID_UsuarioE, ID_UsuarioR, FechaCreacion) VALUES
(1, 2, '2026-10-01'),
(1, 3, '2026-10-02'),
(2, 3, '2026-10-03'),
(3, 4, '2026-10-04'),
(2, 5, '2026-10-05');
 
INSERT INTO Amigos (ID_Usuario, ID_UsuarioAmigo, Estado, FechaAlta) VALUES
(1, 2, 'Aceptado', '2026-09-15'),
(1, 3, 'Aceptado', '2026-09-16'),
(2, 3, 'Pendiente', '2026-09-20'),
(3, 4, 'Aceptado', '2026-09-22'),
(4, 5, 'Bloqueado', '2026-09-25');
 
INSERT INTO Notificaciones (ID_Usuario, ID_TipoNotificacion, Texto, Fecha, Leida) VALUES
(1, 1, 'María comentó tu publicación.', '2026-10-21', 1),
(1, 2, 'A Lucas le gustó tu publicación.', '2026-10-22', 0),
(2, 3, 'Lucas te envió una solicitud de amistad.', '2026-10-23', 0),
(3, 4, 'Tienes un nuevo mensaje de Juan.', '2026-10-24', 1),
(4, 5, 'Te invitaron al grupo Programadores.', '2026-10-25', 0);
 
INSERT INTO Grupos (`ID_Dueño`, Nombre, Descripcion, FechaCreacion) VALUES
(1, 'Programadores', 'Grupo para compartir dudas de programación.', '2026-09-20'),
(2, 'Escuela Técnica', 'Grupo de compañeros de curso.', '2026-09-21'),
(3, 'Videojuegos', 'Hablamos de nuestros juegos favoritos.', '2026-09-22'),
(4, 'Música', 'Compartimos canciones y artistas.', '2026-09-23'),
(5, 'Deportes', 'Grupo para hablar de fútbol y otros deportes.', '2026-09-24');
 
INSERT INTO Multimedia (ID_Publicacion, URL, TipoArchivo) VALUES
(1, 'uploads/publicaciones/imagen1.jpg', 'Imagen'),
(2, 'uploads/publicaciones/video1.mp4', 'Video'),
(3, 'uploads/publicaciones/audio1.mp3', 'Audio'),
(4, 'uploads/publicaciones/apunte1.pdf', 'Documento'),
(5, 'uploads/publicaciones/imagen2.png', 'Imagen');
 
INSERT INTO Comentarios (ID_Publicacion, ID_Usuario, Texto, Fecha) VALUES
(1, 2, '¡Bienvenido a la red!', '2026-10-21'),
(1, 3, 'Muy buena publicación.', '2026-10-21'),
(2, 1, 'A mí también me fue bien.', '2026-10-23'),
(3, 2, 'Éxitos con el proyecto.', '2026-10-25'),
(3, 1, 'Cuando quieras te ayudo con PHP.', '2026-10-25');
 
INSERT INTO Interacciones (ID_Usuario, ID_Publicacion, ID_TipoInt, Fecha) VALUES
(2, 1, 1, '2026-10-21'),
(3, 1, 2, '2026-10-21'),
(1, 2, 1, '2026-10-23'),
(1, 3, 3, '2026-10-25'),
(2, 3, 4, '2026-10-25');
 
INSERT INTO Mensajes (ID_Chat, ID_UsuarioEmisor, Texto, FechaEnvio, Leido) VALUES
(1, 1, 'Hola María, ¿cómo estás?', '2026-10-01', 1),
(1, 2, 'Bien, ¿y vos?', '2026-10-01', 1),
(2, 1, '¿Hiciste la tarea de programación?', '2026-10-02', 0),
(3, 3, 'Nos vemos mañana en la escuela.', '2026-10-03', 1),
(4, 4, 'Te mando la canción que te dije.', '2026-10-04', 0);
 
INSERT INTO Grupos_Usuarios (ID_Grupo, ID_Usuario, ID_Rol, FechaIngreso) VALUES
(1, 1, 5, '2026-09-20'),
(1, 2, 3, '2026-09-21'),
(2, 2, 1, '2026-09-21'),
(2, 3, 3, '2026-09-22'),
(3, 3, 2, '2026-09-23');



select * from publicaciones;