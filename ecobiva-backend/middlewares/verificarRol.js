function verificarRol(rolesPermitidos) {
  return (req, res, next) => {
    if (!req.usuario) {
      return res.status(401).json({ error: 'No autenticado o token no inyectado' });
    }

    // 1. Convertimos los roles que trae el usuario en el token a minúsculas
    const rolesUsuario = (req.usuario.roles || []).map(r => r.nombreRol.toLowerCase());
    
    // 2. Convertimos los roles permitidos en la ruta a minúsculas
    const permitidosMinuscula = rolesPermitidos.map(r => r.toLowerCase());

    // 3. CORRECCIÓN: Comparamos string con string usando la lista en minúsculas
    const tienePermiso = rolesUsuario.some((rol) => permitidosMinuscula.includes(rol));

    if (!tienePermiso) {
      return res.status(403).json({
        error: 'No tienes permisos para realizar esta acción'
      });
    }

    next();
  };
}

module.exports = verificarRol;