import "./Login.css";
import { useNavigate } from "react-router-dom";

export default function Login() {

    const navigate = useNavigate();

    const iniciarSesion = () => {

        navigate("/dashboard");

    };

    return (

        <div className="login-container">

            <div className="login-card">

                <div className="logo-container">

                    <div className="logo-circle">

                        E

                    </div>

                    <h1>ECOBIVA</h1>

                    <span>Sistema de Gestión Automotriz</span>

                </div>

                <div className="form-login">

                    <label>Correo electrónico</label>

                    <input
                        type="email"
                        placeholder="Ingrese su correo"
                    />

                    <label>Contraseña</label>

                    <input
                        type="password"
                        placeholder="********"
                    />

                    <button
                        onClick={iniciarSesion}
                    >
                        Iniciar sesión
                    </button>

                    <a href="#">
                        ¿Olvidaste tu contraseña?
                    </a>

                </div>

            </div>

        </div>

    );

}