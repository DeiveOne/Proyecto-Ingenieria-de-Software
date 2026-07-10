const pool = require('../config/db');

async function crear({ nombre, documento, fechaIngreso, cargoActual, tarifaHora }, conn = pool) {
  const [result] = await conn.execute(
    `INSERT INTO Empleado (nombre, documento, fechaIngreso, cargoActual, tarifaHora, estadoLaboral)
     VALUES (?, ?, ?, ?, ?, TRUE)`,
    [nombre, documento, fechaIngreso, cargoActual, tarifaHora || 0]
  );
  return result.insertId;
}

async function obtenerPorDocumento(documento) {
  const [rows] = await pool.execute(
    'SELECT * FROM Empleado WHERE documento = ?',
    [documento]
  );
  return rows[0] || null;
}



async function actualizarInformacionLaboral(idEmpleado, { cargoActual, tarifaHora }, connection = null) {
  const query = `
    UPDATE Empleado 
    SET cargoActual = ?, tarifaHora = ? 
    WHERE idEmpleado = ?
  `;
  const params = [cargoActual, tarifaHora, idEmpleado];
  
  // Si usas transacciones usará 'connection', de lo contrario usará el 'pool' global
  const executor = connection || pool; 
  
  const [resultado] = await executor.query(query, params);
  return resultado;
}

module.exports = { crear, obtenerPorDocumento, actualizarInformacionLaboral };