import "./ClienteModal.css";
import { useEffect, useState } from "react";
import Button from "../Button/Button";
import Input from "../Input/Input";

const clienteInicial = {
  tipoDocumento: "CC", nombre: "", documento: "", correo: "", telefono: "",
  ciudad: "", direccion: "", tipoComunicacion: "Correo",
};

export default function ClienteModal({ open, clienteEditar, onClose, onSave }) {
  const [cliente, setCliente] = useState(clienteInicial);
  const [errores, setErrores] = useState({});

  useEffect(() => {
    if (!open) return;
    setCliente(clienteEditar ? {
      ...clienteInicial,
      ...clienteEditar,
      tipoDocumento: clienteEditar.tipoDocumento || "CC",
      tipoComunicacion: clienteEditar.tipoComunicacion || "Correo",
    } : clienteInicial);
    setErrores({});
  }, [open, clienteEditar]);

  if (!open) return null;
  const cambiar = (campo) => (e) => setCliente({ ...cliente, [campo]: e.target.value });
  const validar = async () => {
    const nuevo = {};
    if (!cliente.nombre.trim()) nuevo.nombre = "Ingrese el nombre.";
    if (!cliente.documento.trim()) nuevo.documento = "Ingrese el documento.";
    if (!cliente.telefono.trim()) nuevo.telefono = "Ingrese el teléfono.";
    if (!cliente.correo.trim()) nuevo.correo = "Ingrese el correo.";
    else if (!/\S+@\S+\.\S+/.test(cliente.correo)) nuevo.correo = "Correo inválido.";
    if (!cliente.ciudad.trim()) nuevo.ciudad = "Ingrese la ciudad.";
    if (!cliente.direccion.trim()) nuevo.direccion = "Ingrese la dirección.";
    setErrores(nuevo);
    if (Object.keys(nuevo).length) return;
    await onSave(cliente);
  };

  return <div className="modalOverlay"><div className="clienteModal">
    <div className="modalHeader"><h2>{clienteEditar ? "Editar Cliente" : "Registrar Cliente"}</h2></div>
    <div className="modalBody">
      <label>Tipo de documento</label>
      <select value={cliente.tipoDocumento} onChange={cambiar("tipoDocumento")}>
        <option value="CC">Cédula de ciudadanía</option><option value="CE">Cédula de extranjería</option>
        <option value="TI">Tarjeta de identidad</option><option value="NIT">NIT</option><option value="PAS">Pasaporte</option>
      </select>
      <Input label="Documento" required value={cliente.documento} error={errores.documento} onChange={cambiar("documento")} />
      <Input label="Nombre completo" required value={cliente.nombre} error={errores.nombre} onChange={cambiar("nombre")} />
      <Input label="Correo" required value={cliente.correo} error={errores.correo} onChange={cambiar("correo")} />
      <Input label="Teléfono" required value={cliente.telefono} error={errores.telefono} onChange={cambiar("telefono")} />
      <Input label="Ciudad" required value={cliente.ciudad} error={errores.ciudad} onChange={cambiar("ciudad")} />
      <Input label="Dirección" required value={cliente.direccion} error={errores.direccion} onChange={cambiar("direccion")} />
      <label>Tipo de comunicación</label>
      <select value={cliente.tipoComunicacion} onChange={cambiar("tipoComunicacion")}>
        <option value="Correo">Correo electrónico</option><option value="WhatsApp">WhatsApp</option><option value="Llamada">Llamada</option>
      </select>
    </div>
    <div className="modalFooter"><Button variant="secondary" onClick={onClose}>Cancelar</Button><Button variant="primary" onClick={validar}>Guardar</Button></div>
  </div></div>;
}
