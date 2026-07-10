const express = require('express');
const router = express.Router();

const usuarioController = require('../controllers/usuarioController');
const verificarToken = require('../middlewares/verificarToken');
const verificarRol = require('../middlewares/verificarRol');

router.use(verificarToken);

// Todas las rutas de usuarios requieren estar logueado Y ser Admin
router.get('/', verificarRol(['Admin', 'Asesor']), usuarioController.listar);
// Endpoint POST /api/usuarios (crear)
router.post('/', verificarRol(['Admin', 'Asesor']), usuarioController.crear);
// Endpoint PUT /api/usuarios/:id (editar — rol y estado solo modificables por Admin en el controlador)
router.put('/:id', verificarRol(['Admin', 'Asesor']), usuarioController.actualizar);
// Endpoint DELETE /api/usuarios/:id (desactivar, borrado lógico)
router.delete('/:id', verificarRol(['Admin']), usuarioController.desactivar);
// Endpoint PATCH /api/usuarios/:id/activar (Reactivar cuenta — solo Admin)
router.patch('/:id/activar', verificarRol(['Admin']), usuarioController.activar);

module.exports = router;