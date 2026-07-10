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
    // Iniciamos una transacción atómica para asegurar consistencia absoluta
    await connection.beginTransaction();

    console.log('🌱 Iniciando la siembra de datos (Seed) para Ecobiva...');

    // =========================================================
    // 1. SEMBRAR ROLES OPERATIVOS (Si no existen)
    // =========================================================
    const rolesSemilla = ['Admin', 'Asesor', 'Técnico', 'Cliente'];
    for (const r of rolesSemilla) {
      await connection.execute(
        'INSERT IGNORE INTO Rol (nombreRol, descripcion) VALUES (?, ?)',
        [r, `Rol del sistema para ${r}`]
      );
    }
    console.log('✅ Roles verificados/insertados.');

    // =========================================================
    // 2. SEMBRAR PREGUNTAS DE SEGURIDAD OBLIGATORIAS
    // =========================================================
    const preguntasSemilla = [
      '¿Cuál es el nombre de la ciudad donde naciste?',
      '¿Cual es el nombre de tu mejor amigo de la infancia?',
      '¿Cuál es el nombre de tu primera mascota?',
      '¿Cuál es tu color favorito?',
      '¿Cual es tu comida favorita?',
      '¿Cuel fue tu primer colegio?'
    ];
    for (const p of preguntasSemilla) {
      await connection.execute(
        'INSERT IGNORE INTO PreguntaSeguridad (textoPregunta) VALUES (?)',
        [p]
      );
    }
    console.log('✅ Catálogo de preguntas de seguridad sembrado.');

    // =========================================================
    // 3. VERIFICAR O CREAR EMPLEADO ADMINISTRADOR RAÍZ
    // =========================================================
    const docAdmin = '0000000000';
    let [empleados] = await connection.execute(
      'SELECT idEmpleado FROM Empleado WHERE documento = ?',
      [docAdmin]
    );

    let idEmpleado;
    if (empleados.length === 0) {
      const [resEmp] = await connection.execute(
        `INSERT INTO Empleado (nombre, documento, fechaIngreso, cargoActual, tarifaHora, estadoLaboral) 
         VALUES (?, ?, ?, ?, ?, ?)`,
        ['Administrador Raíz', docAdmin, new Date(), 'Administrador', 0.00, true]
      );
      idEmpleado = resEmp.insertId;
      console.log('✅ Empleado semilla creado.');
    } else {
      idEmpleado = empleados[0].idEmpleado;
    }

    // =========================================================
    // 4. VERIFICAR SI EL USUARIO ADMIN YA EXISTE
    // =========================================================
    const correoAdmin = 'admin@ecobiva.com';
    const [usuariosExistentes] = await connection.execute(
      'SELECT idUsuario FROM Usuario WHERE correo = ?',
      [correoAdmin]
    );

    if (usuariosExistentes.length > 0) {
      console.log('⚠️ El usuario admin@ecobiva.com ya existe. Omitiendo creación de credenciales.');
      await connection.commit();
      return;
    }

    // =========================================================
    // 5. INSERTAR USUARIO ADMINISTRADOR Y SU ROL
    // =========================================================
    const [roles] = await connection.execute(
      'SELECT idRol FROM Rol WHERE nombreRol = ?',
      ['Admin']
    );
    const idRolAdmin = roles[0].idRol;

    const passwordPlano = 'Admin123!';
    const passwordHash = await bcrypt.hash(passwordPlano, 10);

    const [resultUsuario] = await connection.execute(
      `INSERT INTO Usuario (correo, passwordHash, estado, idEmpleado)
       VALUES (?, ?, ?, ?)`,
      [correoAdmin, passwordHash, true, idEmpleado]
    );
    const idUsuario = resultUsuario.insertId;

    // Asignación en la tabla intermedia UsuarioRol (se asigna a sí mismo por ser raíz)
    await connection.execute(
      `INSERT INTO UsuarioRol (idUsuario, idRol, fechaAsignacion, asignadoPor)
       VALUES (?, ?, NOW(), ?)`,
      [idUsuario, idRolAdmin, idUsuario]
    );

    // =========================================================
    // 6. ASIGNAR LAS 3 PREGUNTAS DE SEGURIDAD OBLIGATORIAS AL ADMIN
    // =========================================================
    // Obtenemos los primeros 3 IDs de preguntas sembradas
    const [preguntasIds] = await connection.execute(
      'SELECT idPregunta FROM PreguntaSeguridad LIMIT 3'
    );

    const respuestaHash = await bcrypt.hash('ecobiva2026', 10);
    for (const preg of preguntasIds) {
      await connection.execute(
        `INSERT INTO UsuarioPreguntaSeguridad (idUsuario, idPregunta, respuestaHash) 
         VALUES (?, ?, ?)`,
        [idUsuario, preg.idPregunta, respuestaHash]
      );
    }
    console.log('✅ Configuración estricta de 3 preguntas de seguridad asociada al Administrador.');

    // Confirmamos toda la transacción de manera segura
    await connection.commit();

    console.log('\n🚀 ¡Seed ejecutado con éxito total en Ecobiva!');
    console.log(`   Usuario: ${correoAdmin}`);
    console.log(`   Password: ${passwordPlano}`);
    console.log(`   Respuesta por defecto a preguntas: ecobiva2026\n`);

  } catch (error) {
    // Si algo falla, revertimos cualquier inserción a medio camino para no romper la base de datos
    await connection.rollback();
    console.error('❌ Error crítico al ejecutar el seed. Transacción revertida:', error.message);
  } finally {
    await connection.end();
  }
}

seed();