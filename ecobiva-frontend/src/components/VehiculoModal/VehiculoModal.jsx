import "./VehiculoModal.css";
import { useEffect, useState } from "react";
import Button from "../Button/Button";
import Input from "../Input/Input";
import { obtenerClientes } from "../../services/clienteService";

const vehiculoInicial = { placa: "", marca: "", modelo: "", anio: "", color: "", kilometraje: "", tipoVehiculo: "", idCliente: "" };
export default function VehiculoModal({ open, vehiculoEditar, onClose, onSave }) {
  const [vehiculo, setVehiculo] = useState(vehiculoInicial); const [clientes, setClientes] = useState([]); const [errores, setErrores] = useState({});
  useEffect(() => { if (!open) return; obtenerClientes().then((data) => setClientes(data)).catch(console.error); setVehiculo(vehiculoEditar ? { ...vehiculoInicial, ...vehiculoEditar } : vehiculoInicial); setErrores({}); }, [open, vehiculoEditar]);
  if (!open) return null;
  const cambiar = (campo) => (e) => setVehiculo({ ...vehiculo, [campo]: e.target.value });
  const validar = async () => { const nuevo = {}; if (!vehiculo.placa.trim()) nuevo.placa = "Ingrese la placa."; if (!vehiculo.marca.trim()) nuevo.marca = "Ingrese la marca."; if (!vehiculo.modelo.trim()) nuevo.modelo = "Ingrese el modelo."; if (!vehiculo.idCliente) nuevo.idCliente = "Seleccione un cliente."; setErrores(nuevo); if (Object.keys(nuevo).length) return; await onSave({ ...vehiculo, idCliente: Number(vehiculo.idCliente) }); };
  return <div className="modalOverlay"><div className="vehiculoModal"><div className="vehiculoHeader"><h2>{vehiculoEditar ? "Editar Vehículo" : "Registrar Vehículo"}</h2></div><div className="vehiculoBody">
    <Input label="Placa" required value={vehiculo.placa} error={errores.placa} onChange={cambiar("placa")} /><Input label="Marca" required value={vehiculo.marca} error={errores.marca} onChange={cambiar("marca")} /><Input label="Modelo" required value={vehiculo.modelo} error={errores.modelo} onChange={cambiar("modelo")} />
    <Input label="Año" type="number" value={vehiculo.anio} onChange={cambiar("anio")} /><Input label="Color" value={vehiculo.color} onChange={cambiar("color")} /><Input label="Kilometraje" type="number" value={vehiculo.kilometraje} onChange={cambiar("kilometraje")} /><Input label="Tipo de vehículo" value={vehiculo.tipoVehiculo} onChange={cambiar("tipoVehiculo")} />
    <div className="inputGroup"><label>Cliente <span>*</span></label><select value={vehiculo.idCliente} onChange={cambiar("idCliente")}><option value="">Seleccione un cliente</option>{clientes.filter((cliente) => cliente.estado === 1 || cliente.idCliente === vehiculoEditar?.idCliente).map((cliente) => <option key={cliente.idCliente} value={cliente.idCliente}>{cliente.nombre} ({cliente.documento})</option>)}</select>{errores.idCliente && <p className="inputError">{errores.idCliente}</p>}</div>
  </div><div className="vehiculoFooter"><Button variant="secondary" onClick={onClose}>Cancelar</Button><Button variant="primary" onClick={validar}>Guardar</Button></div></div></div>;
}
