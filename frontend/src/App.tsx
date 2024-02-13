import "bootstrap/dist/css/bootstrap.min.css";
import "./App.css";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Auth from "./components/Auth";
import Home from "./components/Home";
import axios from "axios";
import secureLocalStorage from "react-secure-storage";
import React from "react";
import { ThemeProvider, createTheme } from '@mui/material/styles';
import { CssBaseline } from "@mui/material";

const ColorModeContext = React.createContext({ toggleColorMode: () => { } });


export function App() {
  const isLoggedIn: () => boolean = () => secureLocalStorage.getItem("plant-it-key") != null;
  const backendURL = window._env_.API_URL != null ? window._env_.API_URL : "http://localhost:8085/api";
  const axiosTimeout = window._env_.WAIT_TIMEOUT != null ? window._env_.WAIT_TIMEOUT : 10000;
  const axiosReq = axios.create({
    baseURL: backendURL,
    timeout: axiosTimeout,
    maxRedirects: 3,
  });

  axiosReq.interceptors.request.use(
    req => {
      if (!req.url?.startsWith("authentication") && !req.url?.startsWith("api-key") &&
        !req.url?.startsWith("info")) {
        req.headers['Key'] = secureLocalStorage.getItem("plant-it-key");
      }
      return req;
    },
    err => {
      return Promise.reject(err);
    }
  );

  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home requestor={axiosReq} isLoggedIn={isLoggedIn} />} />
        <Route path="/auth" element={<Auth requestor={axiosReq} />} />
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
                main: '#02634a',
                light: '#FFF7F8',
              },
              secondary: {
                main: '#192A51',
              },
              error: {
                main: '#A8201A',
              },
              background: {
                default: 'rgb(235, 235, 235)',
              },
              accent: {
                main: "#192A51",
                secondary: "#7C898B",
              }
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
          fontFamily: "Raleway",
          body1: {
            lineHeight: 1.5,
          },
          body2: {
            lineHeight: 1.5,
          },
        },
        shape: {
          borderRadius: 10,
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
