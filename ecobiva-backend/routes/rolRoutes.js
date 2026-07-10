const express = require('express');
const router = express.Router();


const usuarioController = require('../controllers/usuarioController');
const verificarToken = require('../middlewares/verificarToken');
const verificarRol = require('../middlewares/verificarRol');

router.use(verificarToken);

// Endpoint GET /api/roles (listar roles disponibles)
router.get('/', verificarRol(['Admin', 'Asesor']), usuarioController.listarRoles);

module.exports = router;