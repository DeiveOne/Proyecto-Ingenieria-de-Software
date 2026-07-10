import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";

import "./assets/css/global.css";

import { BrowserRouter } from "react-router-dom";

import { LayoutProvider } from "./context/LayoutContext";

ReactDOM.createRoot(document.getElementById("root")).render(

    <BrowserRouter>

        <LayoutProvider>

            <App/>

        </LayoutProvider>

    </BrowserRouter>

);