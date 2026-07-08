require('dotenv').config();
const mysql = require('mysql2/promise');
const bcrypt = require('bcrypt');

async function seed() {
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
  });

  try {
    // 1. Buscar el idEmpleado del "Administrador Prueba" insertado en schema.sql
    const [empleados] = await connection.execute(
      'SELECT idEmpleado FROM Empleado WHERE documento = ?',
      ['0000000000']
    );

    if (empleados.length === 0) {
      throw new Error('No se encontró el Empleado semilla. ¿Corriste schema.sql primero?');
    }
    const idEmpleado = empleados[0].idEmpleado;

    // 2. Buscar el idRol de "Admin"
    const [roles] = await connection.execute(
      'SELECT idRol FROM Rol WHERE nombreRol = ?',
      ['Admin']
    );

    if (roles.length === 0) {
      throw new Error('No se encontró el Rol "Admin". ¿Corriste schema.sql primero?');
    }
    const idRol = roles[0].idRol;

    // 3. Verificar si el usuario admin ya existe (evitar duplicados)
    const correoAdmin = 'admin@ecobiva.com';
    const [usuariosExistentes] = await connection.execute(
      'SELECT idUsuario FROM Usuario WHERE correo = ?',
      [correoAdmin]
    );

    if (usuariosExistentes.length > 0) {
      console.log('El usuario admin ya existe, no se crea de nuevo.');
      await connection.end();
      return;
    }

    // 4. Hashear la contraseña con bcrypt (10 rounds mínimo, según el requerimiento)
    const passwordPlano = 'Admin123!';
    const passwordHash = await bcrypt.hash(passwordPlano, 10);

    // 5. Insertar el Usuario
    const [resultUsuario] = await connection.execute(
      `INSERT INTO Usuario (correo, passwordHash, estado, idEmpleado)
       VALUES (?, ?, ?, ?)`,
      [correoAdmin, passwordHash, true, idEmpleado]
    );
    const idUsuario = resultUsuario.insertId;

    // 6. Insertar el UsuarioRol (asignadoPor = el mismo usuario, por ser el primero)
    await connection.execute(
      `INSERT INTO UsuarioRol (idUsuario, idRol, fechaAsignacion, asignadoPor)
       VALUES (?, ?, NOW(), ?)`,
      [idUsuario, idRol, idUsuario]
    );

    console.log('Usuario admin creado con éxito:');
    console.log(`  Correo: ${correoAdmin}`);
    console.log(`  Password: ${passwordPlano}`);
    console.log('(Cambia esta contraseña luego de tu primer login en producción)');

  } catch (error) {
    console.error('Error al ejecutar el seed:', error.message);
  } finally {
    await connection.end();
  }
}

seed();