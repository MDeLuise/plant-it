import { Box, Typography } from "@mui/material";
import { trackedEntity } from "../interfaces";
import { Buffer } from "buffer";
import { isBigScreen } from "../common";
import { NavigateFunction, useNavigate } from "react-router-dom";

export default function UserPlant(props: { entity: trackedEntity }) {
    const name: string = props.entity.personalName != undefined ?
        props.entity.personalName :
        "plant " + props.entity.id
    let navigate: NavigateFunction = useNavigate();

    return (
        <Box
            onClick={() => navigate(`/entity/${props.entity.id}`)}
            boxShadow={2}
            sx={{
                width: isBigScreen() ? "20vw" : "45vw",
                borderRadius: "5px",
                overflow: "hidden",
                aspectRatio: ".7",
                backgroundColor: "background.paper",
                padding: "10px",
                flexShrink: 0
            }}>
            <img
                src={props.entity.botanicalName.imageUrl}
                style={{
                    width: "100%",
                    height: "70%",
                    objectFit: "cover",
                    borderRadius: "5px",
                    marginBottom: "10px",
                }}
            />
            <Typography variant="body1" style={{fontWeight: 600}}>
                {name}
            </Typography>
            <Typography variant="body1">
                {props.entity.botanicalName.family}
            </Typography>
        </Box>
    )
}