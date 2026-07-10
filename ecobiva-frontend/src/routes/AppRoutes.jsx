import { Routes, Route } from "react-router-dom";

import Login from "../pages/Login/Login";
import Dashboard from "../pages/Dashboard/Dashboard";
import Clientes from "../pages/Clientes/Clientes";
import Vehiculos from "../pages/Vehiculos/Vehiculos";
import Tecnicos from "../pages/Tecnicos/Tecnicos";
import Inventario from "../pages/Inventario/Inventario";
import Ordenes from "../pages/Ordenes/Ordenes";
import Reportes from "../pages/Reportes/Reportes";
import Configuracion from "../pages/Configuracion/Configuracion";

export default function AppRoutes() {

    return (

        <Routes>

            <Route
                path="/"
                element={<Login />}
            />

            <Route
                path="/dashboard"
                element={<Dashboard />}
            />

            <Route
                path="/clientes"
                element={<Clientes />}
            />

            <Route
                path="/vehiculos"
                element={<Vehiculos />}
            />

            <Route
                path="/tecnicos"
                element={<Tecnicos />}
            />

            <Route
                path="/inventario"
                element={<Inventario />}
            />

            <Route
                path="/ordenes"
                element={<Ordenes />}
            />

            <Route
                path="/reportes"
                element={<Reportes />}
            />

            <Route
                path="/configuracion"
                element={<Configuracion />}
            />

        </Routes>


    );

}