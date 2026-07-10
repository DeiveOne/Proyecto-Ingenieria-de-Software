import { createContext, useContext, useState } from "react";

const LayoutContext = createContext();

export function LayoutProvider({ children }) {

    const [sidebarOpen, setSidebarOpen] = useState(true);

    const toggleSidebar = () => {

        setSidebarOpen(!sidebarOpen);

    };

    return (

        <LayoutContext.Provider
            value={{
                sidebarOpen,
                toggleSidebar
            }}
        >

            {children}

        </LayoutContext.Provider>

    );

}

export function useLayout(){

    return useContext(LayoutContext);

}