const bateriaDao = require('../dao/bateriaDao');
const { registrarAccion } = require('../utils/auditoria');
const alertaStockDao = require('../dao/alertaStockDao');

async function listar(req, res) {
  try {
    const baterias = await bateriaDao.listarTodos();
    return res.json(baterias);
  } catch (error) {
    console.error('Error al listar baterías:', error);
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
}

async function obtenerPorId(req, res) {
  const { id } = req.params;

  try {
    const bateria = await bateriaDao.obtenerPorId(id);
    if (!bateria) {
      return res.status(404).json({ error: 'Batería no encontrada' });
    }
    return res.json(bateria);
  } catch (error) {
    console.error('Error al obtener batería por id:', error);
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
}

async function crear(req, res) {
  const {
    nombre,
    categoria,
    precioUnitario,
    proveedor,
    stockActual,
    stockMinimo,
    serial,
    modeloCompatible,
    estado,
    voltajeFinal,
    amperajeFinal,
    idVehiculo
  } = req.body;

  if (!nombre || !serial) {
    return res.status(400).json({ error: 'Nombre y serial son obligatorios' });
  }

  try {
    const idRepuesto = await bateriaDao.crear({
      nombre,
      categoria,
      precioUnitario,
      proveedor,
      stockActual,
      stockMinimo,
      serial,
      modeloCompatible,
      estado,
      voltajeFinal,
      amperajeFinal,
      idVehiculo
    });

    await alertaStockDao.generarSiStockBajo(idRepuesto);

    return res.status(201).json({ mensaje: 'Batería creada correctamente', idRepuesto });
  } catch (error) {
    console.error('Error al crear batería:', error);
    if (error.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({ error: 'Ya existe una batería con ese serial' });
    }
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
}

async function actualizar(req, res) {
  const { id } = req.params;
  const {
    nombre,
    categoria,
    precioUnitario,
    proveedor,
    stockActual,
    stockMinimo,
    serial,
    modeloCompatible,
    estado,
    voltajeFinal,
    amperajeFinal,
    idVehiculo
  } = req.body;

  if (!nombre || !serial) {
    return res.status(400).json({ error: 'Nombre y serial son obligatorios' });
  }

  try {
    const bateria = await bateriaDao.obtenerPorId(id);
    if (!bateria) {
      return res.status(404).json({ error: 'Batería no encontrada' });
    }

    await bateriaDao.actualizar(id, {
      nombre,
      categoria,
      precioUnitario,
      proveedor,
      stockActual,
      stockMinimo,
      serial,
      modeloCompatible,
      estado,
      voltajeFinal,
      amperajeFinal,
      idVehiculo
    });

    await alertaStockDao.generarSiStockBajo(id);

    await registrarAccion(req, {
      accion: 'ACTUALIZAR_BATERIA',
      modulo: 'INVENTARIO',
      detalle: `Batería "${bateria.nombre}" (serial: ${bateria.serial}) actualizada. Precio anterior: ${bateria.precioUnitario}, nuevo: ${precioUnitario}. Stock anterior: ${bateria.stockActual}, nuevo: ${stockActual}`
    });

    return res.json({ mensaje: 'Batería actualizada correctamente' });
  } catch (error) {
    console.error('Error al actualizar batería:', error);
    if (error.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({ error: 'Ya existe una batería con ese serial' });
    }
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
}

async function eliminar(req, res) {
  const { id } = req.params;

  try {
    const bateria = await bateriaDao.obtenerPorId(id);
    if (!bateria) {
      return res.status(404).json({ error: 'Batería no encontrada' });
    }

    await bateriaDao.eliminar(id);

    await registrarAccion(req, {
      accion: 'ELIMINAR_BATERIA',
      modulo: 'INVENTARIO',
      detalle: `Batería "${bateria.nombre}" (serial: ${bateria.serial}) eliminada. Stock previo: ${bateria.stockActual}, Precio unitario: ${bateria.precioUnitario}`
    });

    return res.json({ mensaje: 'Batería eliminada correctamente' });
  } catch (error) {
    console.error('Error al eliminar batería:', error);
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
}

module.exports = {
  listar,
  obtenerPorId,
  crear,
  actualizar,
  eliminar
};
