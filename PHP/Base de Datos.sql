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