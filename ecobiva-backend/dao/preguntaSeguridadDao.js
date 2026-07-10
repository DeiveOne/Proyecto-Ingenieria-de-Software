const { Connection } = require('mysql2');
const pool = require('../config/db');

async function listarCatalogo() {
  const [rows] = await pool.execute(
    'SELECT idPregunta, textoPregunta FROM PreguntaSeguridad'
  );
  return rows;
}

/**
 * Guarda las 3 preguntas+respuestas elegidas por el usuario.
 * Si ya tenía preguntas configuradas, las reemplaza (borra las viejas).
 */
async function configurar(idUsuario, preguntasConRespuestaHash, connExternal = null) {
  // Si viene una conexion externa ( como la del controlador), usamos esa. SI no, pedimos una nueva.
  const conn = connExternal || await pool.getConnection();
  try {
    if (!connExternal) await conn.beginTransaction();

    await conn.execute(
      'DELETE FROM UsuarioPreguntaSeguridad WHERE idUsuario = ?',
      [idUsuario]
    );

    for (const { idPregunta, respuestaHash } of preguntasConRespuestaHash) {
      await conn.execute(
        `INSERT INTO UsuarioPreguntaSeguridad (idUsuario, idPregunta, respuestaHash)
         VALUES (?, ?, ?)`,
        [idUsuario, idPregunta, respuestaHash]
      );
    }

    if (!connExternal) await conn.commit();
  } catch (err) {
    if (!connExternal)await conn.rollback();
    throw err;
  } finally {
    if (!connExternal)conn.release();
  }
}

/**
 * Devuelve las preguntas (texto) que un usuario configuró, dado su correo.
 * No expone las respuestas.
 */
async function obtenerPreguntasPorCorreo(correo) {
  const [rows] = await pool.execute(
    `SELECT ps.idPregunta, ps.textoPregunta
     FROM UsuarioPreguntaSeguridad ups
     JOIN Usuario u ON u.idUsuario = ups.idUsuario
     JOIN PreguntaSeguridad ps ON ps.idPregunta = ups.idPregunta
     WHERE u.correo = ?`,
    [correo]
  );
  return rows;
}

/**
 * Devuelve las respuestas hasheadas de un usuario, para validarlas.
 */
async function obtenerRespuestasPorCorreo(correo) {
  const [rows] = await pool.execute(
    `SELECT ups.idPregunta, ups.respuestaHash
     FROM UsuarioPreguntaSeguridad ups
     JOIN Usuario u ON u.idUsuario = ups.idUsuario
     WHERE u.correo = ?`,
    [correo]
  );
  return rows;
}

module.exports = {
  listarCatalogo,
  configurar,
  obtenerPreguntasPorCorreo,
  obtenerRespuestasPorCorreo
};