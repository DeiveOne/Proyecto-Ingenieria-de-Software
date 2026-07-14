import "./VehiculoDetail.css";

import DataField from "../DataField/DataField";

export default function VehiculoDetail({ vehiculo }) {

    if (!vehiculo) return null;

    return (

        <>

            <section className="detailSection">

                <h3>Información General</h3>

                <div className="detailGrid">

                    <DataField label="Placa" value={vehiculo.placa} />
                    <DataField label="Marca" value={vehiculo.marca} />
                    <DataField label="Modelo" value={vehiculo.modelo} />
                    <DataField label="Año" value={vehiculo.anio} />
                    <DataField label="Tipo de vehículo" value={vehiculo.tipoVehiculo} />
                    <DataField label="Serial del motor" value={vehiculo.serialMotor} />
                    <DataField label="Especificaciones de batería" value={vehiculo.especificacionesBateria} />

                </div>

            </section>

            <section className="detailSection">

                <h3>Propietario</h3>

                <div className="detailGrid">

                    <DataField label="Cliente" value={vehiculo.nombreCliente || vehiculo.propietario} />
                </div>

            </section>

        </>

    );

}
