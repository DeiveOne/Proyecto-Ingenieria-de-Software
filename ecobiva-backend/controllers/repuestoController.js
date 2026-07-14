const repuestoDao = require('../dao/repuestoDao');
const { registrarAccion } = require('../utils/auditoria');
const alertaStockDao = require('../dao/alertaStockDao');

async function listar(req, res) {
  try {
    const repuestos = await repuestoDao.listarTodos();
    return res.json(repuestos);
  } catch (error) {
    console.error('Error al listar repuestos:', error);
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
}

async function obtenerPorId(req, res) {
  const { id } = req.params;

  try {
    const repuesto = await repuestoDao.obtenerPorId(id);
    if (!repuesto) {
      return res.status(404).json({ error: 'Repuesto no encontrado' });
    }
    return res.json(repuesto);
  } catch (error) {
    console.error('Error al obtener repuesto por id:', error);
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
}

async function crear(req, res) {
  const { nombre, categoria, precioUnitario, proveedor, stockActual, stockMinimo } = req.body;

  if (!nombre) {
    return res.status(400).json({ error: 'El nombre del repuesto es obligatorio' });
  }

  try {
    const idRepuesto = await repuestoDao.crear({
      nombre,
      categoria,
      precioUnitario,
      proveedor,
      stockActual,
      stockMinimo
    });

    await registrarAccion(req, {
      accion: 'CREAR_REPUESTO',
      modulo: 'INVENTARIO',
      detalle: `Repuesto "${nombre}" creado. Precio: ${precioUnitario || 0}, Stock: ${stockActual || 0}`
    });

    await alertaStockDao.generarSiStockBajo(idRepuesto);

    return res.status(201).json({ mensaje: 'Repuesto creado correctamente', idRepuesto });
  } catch (error) {
    console.error('Error al crear repuesto:', error);
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
}

async function actualizar(req, res) {
  const { id } = req.params;
  const { nombre, categoria, precioUnitario, proveedor, stockActual, stockMinimo } = req.body;

  if (!nombre) {
    return res.status(400).json({ error: 'El nombre del repuesto es obligatorio' });
  }

  try {
    const repuesto = await repuestoDao.obtenerPorId(id);
    if (!repuesto) {
      return res.status(404).json({ error: 'Repuesto no encontrado' });
    }

    await repuestoDao.actualizar(id, {
      nombre,
      categoria,
      precioUnitario,
      proveedor,
      stockActual,
      stockMinimo
    });

    await alertaStockDao.generarSiStockBajo(id);

    await registrarAccion(req, {
      accion: 'ACTUALIZAR_REPUESTO',
      modulo: 'INVENTARIO',
      detalle: `Repuesto "${repuesto.nombre}" (#${id}) actualizado. Precio anterior: ${repuesto.precioUnitario}, nuevo: ${precioUnitario}. Stock anterior: ${repuesto.stockActual}, nuevo: ${stockActual}`
    });

    return res.json({ mensaje: 'Repuesto actualizado correctamente' });
  } catch (error) {
    console.error('Error al actualizar repuesto:', error);
    return res.status(500).json({ error: 'Error interno del servidor' });
  }
}

async function eliminar(req, res) {
  const { id } = req.params;

  try {
    const repuesto = await repuestoDao.obtenerPorId(id);
    if (!repuesto) {
      return res.status(404).json({ error: 'Repuesto no encontrado' });
    }

    await repuestoDao.eliminar(id);

    await registrarAccion(req, {
      accion: 'ELIMINAR_REPUESTO',
      modulo: 'INVENTARIO',
      detalle: `Repuesto "${repuesto.nombre}" (#${id}) dado de baja. Stock previo: ${repuesto.stockActual}, Precio unitario: ${repuesto.precioUnitario}`
    });

    return res.json({ mensaje: 'Repuesto dado de baja correctamente. Su historial se conserva.' });
  } catch (error) {
    console.error('Error al eliminar repuesto:', error);
    return res.status(400).json({ error: error.message || 'No fue posible dar de baja el repuesto' });
  }
}

module.exports = {
  listar,
  obtenerPorId,
  crear,
  actualizar,
  eliminar
};
