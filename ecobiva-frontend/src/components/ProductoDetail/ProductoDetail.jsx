import "./ProductoDetail.css";

import DataField from "../DataField/DataField";

export default function ProductoDetail({ producto }) {

    if (!producto) return null;

    return (

        <>
        
            <section className="detailSection">

                <h3>Información del Producto</h3>

                <div className="detailGrid">

                    <DataField
                        label="Producto"
                        value={producto.nombre}
                    />

                    <DataField
                        label="Categoría"
                        value={producto.categoria}
                    />

                    <DataField
                        label="Proveedor"
                        value={producto.proveedor}
                    />

                    <DataField
                        label="Precio"
                        value={producto.precioUnitario}
                    />

                    <DataField
                        label="Stock"
                        value={producto.stockActual}
                    />

                    <DataField
                        label="Stock mínimo"
                        value={producto.stockMinimo}
                    />

                </div>

            </section>

        </>

    );

}
