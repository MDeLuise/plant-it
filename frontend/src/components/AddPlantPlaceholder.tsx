import { Box, Typography } from "@mui/material";
import AddRoundedIcon from '@mui/icons-material/AddRounded';
import { NavigateFunction, useNavigate } from "react-router-dom";
import { isBigScreen } from "../common";

export default function AddPlantPlaceholder(props: {}) {
    let navigate: NavigateFunction = useNavigate();

    return (
        <Box
            onClick={() => navigate("/search")}
            sx={{
                width: isBigScreen() ? "20vw" : "39vw",
                borderRadius: "5px",
                position: "relative",
                overflow: "hidden",
                aspectRatio: "1",
                backgroundColor: "primary.main"
            }}>
            <Box sx={{
                position: "absolute",
                bottom: "0",
                padding: "10px",
                display: "flex",
                alignItems: "center",
                gap: "5px"
            }}>
                <Typography
                    variant="h6"
                >
                    Add plant
                </Typography>
                <AddRoundedIcon />
            </Box>
        </Box>
    )
}