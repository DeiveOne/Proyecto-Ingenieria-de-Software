import "./Vehiculos.css";
import { useEffect, useState } from "react";
import { FaPlus } from "react-icons/fa";
import VehiculoModal from "../../components/VehiculoModal/VehiculoModal";
import PageHeader from "../../components/PageHeader/PageHeader";
import ActionButtons from "../../components/ActionButtons/ActionButtons";
import StatusBadge from "../../components/StatusBadge/StatusBadge";
import SearchBar from "../../components/SearchBar/SearchBar";
import ConfirmModal from "../../components/ConfirmModal/ConfirmModal";
import DetailModal from "../../components/DetailModal/DetailModal";
import VehiculoDetail from "../../components/VehiculoDetail/VehiculoDetail";
import { obtenerVehiculos, obtenerVehiculo, crearVehiculo, actualizarVehiculo, eliminarVehiculo, reactivarVehiculo } from "../../services/vehiculoService";

export default function Vehiculos() {
  const [abrirModal, setAbrirModal] = useState(false), [busqueda, setBusqueda] = useState(""), [vehiculos, setVehiculos] = useState([]), [vehiculoEditar, setVehiculoEditar] = useState(null), [vehiculoSeleccionado, setVehiculoSeleccionado] = useState(null), [vehiculoEliminar, setVehiculoEliminar] = useState(null), [detalleOpen, setDetalleOpen] = useState(false), [confirmDelete, setConfirmDelete] = useState(false);
  const cargarVehiculos = async () => { try { setVehiculos(await obtenerVehiculos()); } catch (error) { console.error(error); alert("No se pudieron cargar los vehículos."); } };
  useEffect(() => { cargarVehiculos(); }, []);
  const cerrarModal = () => { setAbrirModal(false); setVehiculoEditar(null); };
  const guardarVehiculo = async (vehiculo) => { try { if (vehiculoEditar?.idVehiculo) await actualizarVehiculo(vehiculoEditar.idVehiculo, vehiculo); else await crearVehiculo(vehiculo); cerrarModal(); await cargarVehiculos(); } catch (error) { console.error(error); alert("No fue posible guardar el vehículo."); } };
  const confirmarEliminar = async () => { try { await eliminarVehiculo(vehiculoEliminar.idVehiculo); setConfirmDelete(false); setVehiculoEliminar(null); await cargarVehiculos(); } catch (error) { console.error(error); alert("No fue posible desactivar el vehículo."); } };
  const filtrados = vehiculos.filter((vehiculo) => [vehiculo.placa, vehiculo.marca, vehiculo.modelo, vehiculo.nombreCliente].some((valor) => valor?.toLowerCase().includes(busqueda.toLowerCase())));
  return <><PageHeader title="Vehículos" subtitle="Administración de vehículos." button={<button className="btnNuevo" onClick={() => { setVehiculoEditar(null); setAbrirModal(true); }}><FaPlus />Nuevo Vehículo</button>} /><div className="vehiculosCard"><SearchBar placeholder="Buscar vehículo..." value={busqueda} onChange={(e) => setBusqueda(e.target.value)} /><table><thead><tr><th>Placa</th><th>Marca</th><th>Modelo</th><th>Color</th><th>Propietario</th><th>Estado</th><th>Acciones</th></tr></thead><tbody>{filtrados.map((vehiculo) => <tr key={vehiculo.idVehiculo}><td><strong>{vehiculo.placa}</strong></td><td>{vehiculo.marca || "-"}</td><td>{vehiculo.modelo || "-"}</td><td>{vehiculo.color || "-"}</td><td>{vehiculo.nombreCliente || "-"}</td><td><StatusBadge status={vehiculo.estado} /></td><td><ActionButtons onView={async () => { try { setVehiculoSeleccionado(await obtenerVehiculo(vehiculo.idVehiculo)); setDetalleOpen(true); } catch (error) { console.error(error); alert("No fue posible obtener el vehículo."); } }} onEdit={vehiculo.estado === 1 ? () => { setVehiculoEditar(vehiculo); setAbrirModal(true); } : undefined} onDelete={vehiculo.estado === 1 ? () => { setVehiculoEliminar(vehiculo); setConfirmDelete(true); } : undefined} onRestore={vehiculo.estado === 0 ? async () => { try { await reactivarVehiculo(vehiculo.idVehiculo); await cargarVehiculos(); } catch (error) { console.error(error); alert("No fue posible reactivar el vehículo."); } } : undefined} /></td></tr>)}</tbody></table></div><DetailModal open={detalleOpen} title="Información del Vehículo" onClose={() => setDetalleOpen(false)}><VehiculoDetail vehiculo={vehiculoSeleccionado} /></DetailModal><VehiculoModal open={abrirModal} vehiculoEditar={vehiculoEditar} onClose={cerrarModal} onSave={guardarVehiculo} /><ConfirmModal open={confirmDelete} title="Desactivar Vehículo" message="¿Está seguro de desactivar este vehículo?" onClose={() => { setConfirmDelete(false); setVehiculoEliminar(null); }} onConfirm={confirmarEliminar} /></>;
}
