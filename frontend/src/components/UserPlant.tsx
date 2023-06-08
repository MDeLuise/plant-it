import { Box, Skeleton, Typography } from "@mui/material";
import { trackedEntity } from "../interfaces";
import { isBigScreen } from "../common";
import { NavigateFunction, useNavigate } from "react-router-dom";
import { useState } from "react";

export default function UserPlant(props: { entity: trackedEntity, style?: {} }) {
    let navigate: NavigateFunction = useNavigate();
    const [imageLoaded, setImageLoaded] = useState<boolean>(false);
    
    return (
        <Box
            //onClick={() => navigate(`/entity/${props.entity.id}`)}
            boxShadow={.5}
            sx={{
                width: isBigScreen() ? "20vw" : "45vw",
                borderRadius: "10px",
                overflow: "hidden",
                aspectRatio: ".7",
                flexShrink: 0,
                position: "relative",
            }}
            style={props.style}>
            {!imageLoaded &&
                <Skeleton variant="rounded" animation="wave" sx={{ width: "100%", height: "100%" }} />
            }
            <img
                src={props.entity.botanicalInfo.imageUrl}
                onLoad={() => setImageLoaded(true)}
                style={{
                    width: "100%",
                    height: "80%",
                    objectFit: "cover",
                    borderRadius: "10px",
                    visibility: imageLoaded ? "initial" : "hidden",
                    marginBottom: "5px",
                }}
            />
            <Typography
                noWrap
                variant="body1"
                style={{ fontWeight: 600 }}
                boxShadow={.5}
            >
                {props.entity.personalName}
            </Typography>
        </Box >
    )
}