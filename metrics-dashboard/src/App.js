import { useState } from "react";
import Dashboard from "./scenes/Dashboard";
import { CssBaseline, ThemeProvider } from "@mui/material";
import { ColorModeContext, useMode } from "./theme";
import { Routes, Route } from "react-router-dom";
import Sidebar from "./components/Sidebar";
import Toolbar from "./components/Toolbar";


function App() {
  const [theme, colorMode] = useMode();
  const [isSidebar, setIsSidebar] = useState(true);

  return (
    <ColorModeContext.Provider value={colorMode}>
      <ThemeProvider theme={theme}>
        <CssBaseline />
        <div className="app">
        <Sidebar isSidebar={isSidebar} />
          <main className="content">
            <Toolbar setIsSidebar={setIsSidebar} />
          <Routes>
            <Route path="/" element={<Dashboard />} />
          </Routes>
        </main>
        </div>
      </ThemeProvider>
    </ColorModeContext.Provider>
  );
}

export default App;



