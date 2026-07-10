const express = require('express');
const router = express.Router();

const auditoriaController = require('../controllers/auditoriaController');
const verificarToken = require('../middlewares/verificarToken');
const verificarRol = require('../middlewares/verificarRol');

router.use(verificarToken);

// Endpoint GET /api/auditoria?usuario=&modulo=&desde=&hasta= (con filtros)
router.get('/', verificarRol(['Admin']), auditoriaController.consultar);
// Endpoint GET /api/auditoria/exportar (PDF o Excel/CSV)
router.get('/exportar', verificarRol(['Admin']), auditoriaController.exportar);
module.exports = router;
