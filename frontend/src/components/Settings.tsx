import { Box, Button, Typography } from "@mui/material";
import LogoutRoundedIcon from '@mui/icons-material/LogoutRounded';
import secureLocalStorage from "react-secure-storage";
import { NavigateFunction, useNavigate } from "react-router-dom";
import { useEffect, useState } from "react";
import { AxiosInstance } from "axios";

export default function Settings(props: { requestor: AxiosInstance }) {
    let navigate: NavigateFunction = useNavigate();
    const [version, setVersion] = useState<string>();

    const logout = (): void => {
        secureLocalStorage.removeItem("plant-it-key");
        navigate("/auth");
    };

    const getVersion = (): void => {
        props.requestor.get("/info/version")
        .then((res) => setVersion(res.data))
    };

    useEffect(() => {
        getVersion();
    })

    return <Box sx={{
        display: "flex",
        gap: "10px",
        flexDirection: "column",
    }}>

        <Box>
            <Button
                variant="contained"
                color="error"
                fullWidth
                onClick={logout}
                startIcon={<LogoutRoundedIcon />}
            >
                Log out
            </Button>
        </Box>
        <Typography sx={{ width: "100%", textAlign: "center" }}>
            App version: {version}
        </Typography>
    </Box>;
}