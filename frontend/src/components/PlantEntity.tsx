import { Box, Typography } from "@mui/material";
import { trackedEntity } from "../interfaces";
import { useEffect, useState } from "react";
import { AxiosInstance } from "axios";
import { Buffer } from "buffer";
import { isBigScreen } from "../common";
import { NavigateFunction, useNavigate } from "react-router-dom";

export default function PlantEntity(props: { entity: trackedEntity, requestor: AxiosInstance }) {
    const name: string = props.entity.personalName != undefined ?
        props.entity.personalName :
        "plant " + props.entity.id
    let navigate: NavigateFunction = useNavigate();

    return (
        <Box
            onClick={() => navigate(`/entity/${props.entity.id}`)}
            sx={{
                width: isBigScreen() ? "20vw" : "39vw",
                borderRadius: "5px",
                position: "relative",
                overflow: "hidden",
                aspectRatio: "1"
            }}>
            <img
                src={props.entity.botanicalName.imageUrl}
                style={{
                    width: "100%",
                    height: "100%",
                    objectFit: "cover"
                }}
            />
            <Typography
                variant="h6"
                sx={{
                    position: "absolute",
                    bottom: "0",
                    padding: "10px"
                }}>
                {name}
            </Typography>
        </Box>
    )
}