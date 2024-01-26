import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import AppWithColorMode from './App';
import reportWebVitals from './reportWebVitals';
import swDev from './swDev';

export {};

declare global {
  interface Window {
    _env_: {
      API_URL: string
      WAIT_TIMEOUT: number | undefined
    }
  }
}

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);
root.render(
  <React.StrictMode>
    <AppWithColorMode />
  </React.StrictMode>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();

swDev();
