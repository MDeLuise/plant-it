import "bootstrap/dist/css/bootstrap.min.css";
import "./App.css";
import "./style/Base.scss";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Auth from "./components/Auth";
import Home from "./components/Home";
import axios from "axios";
import secureLocalStorage from "react-secure-storage";
import React from "react";
import { ThemeProvider, createTheme } from '@mui/material/styles';
import { CssBaseline } from "@mui/material";
import SearchEntities from "./components/SearchEntities";
import AddCustom from "./components/AddCustom";
import PlantPage from "./components/PlantPage";
import AddEditDiaryEntry from "./components/AddEditDiaryEntry";

const ColorModeContext = React.createContext({ toggleColorMode: () => { } });

export function App() {
  const isLoggedIn: () => boolean = () => secureLocalStorage.getItem("plant-it-key") != null;
  const backendURL = process.env.REACT_APP_API_URL != null ? process.env.REACT_APP_API_URL : "http://localhost:8085/api";
  const axiosReq = axios.create({
    baseURL: backendURL,
    timeout: 1000
  });

  axiosReq.interceptors.request.use(
    (req) => {
      if (!req.url?.startsWith("authentication") && !req.url?.startsWith("api-key")) {
        req.headers['Key'] = secureLocalStorage.getItem("plant-it-key");
      }
      return req;
    },
    (err) => {
      return Promise.reject(err);
    }
  );

  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home requestor={axiosReq} isLoggedIn={isLoggedIn} />} />
        <Route path="/auth" element={<Auth requestor={axiosReq} />} />
        <Route path="/search" element={<SearchEntities requestor={axiosReq} isLoggedIn={isLoggedIn} />} />
        <Route path="/add" element={<AddCustom requestor={axiosReq} isLoggedIn={isLoggedIn} />} />
        <Route path="/entity/:entityId" element={<PlantPage requestor={axiosReq} isLoggedIn={isLoggedIn} />} />
        <Route path="/diary/add" element={<AddEditDiaryEntry requestor={axiosReq} isLoggedIn={isLoggedIn} />} />
        <Route path="/diary/edit/:diaryEntryId" element={<AddEditDiaryEntry requestor={axiosReq} isLoggedIn={isLoggedIn} />} />
      </Routes>
    </BrowserRouter>
  );
}


export default function AppWithColorMode() {
  const [mode, setMode] = React.useState<'light' | 'dark'>(localStorage.getItem("plant-it-dark") != "false" ? "light" : "dark");
  const colorMode = React.useMemo(
    () => ({
      toggleColorMode: () => {
        setMode((prevMode) => (prevMode === 'light' ? 'dark' : 'light'));
      },
    }),
    [],
  );

  const theme = React.useMemo(
    () =>
      createTheme({
        palette: {
          mode,
          ...(mode === 'light'
            ? {
              // palette values for light mode
              primary: {
                main: '#3a5e49',
              },
              secondary: {
                main: '#e64a19',
              },
              background: {
                default: '#efefef',
              },
            }
            : {
              // palette values for dark mode
              primary: {
                main: '#4CAF50',
              },
              secondary: {
                main: '#f50057',
              },
              background: {
                default: "#303030",
                paper: "#424242",
              },
            }),
        },
        typography: {
          fontFamily: "Quicksand",
          body1: {
            lineHeight: 1.5,
          },
          body2: {
            lineHeight: 1.5,
          },
        },
        shape: {
          borderRadius: 4,
        },
      }),
    [mode],
  );

  return (
    <ColorModeContext.Provider value={colorMode}>
      <ThemeProvider theme={theme}>
        <CssBaseline />
        <App></App>
      </ThemeProvider>
    </ColorModeContext.Provider>
  );
}
