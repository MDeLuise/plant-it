import { Box, Card, CardActionArea, CardContent, CardMedia, Typography } from "@mui/material";
import { botanicalInfo } from "../interfaces";
import { useEffect, useState } from "react";
import { AxiosInstance } from "axios";
import { Buffer } from "buffer";
import { isBigScreen } from "../common";
import AddRoundedIcon from '@mui/icons-material/AddRounded';

export default function BotanicalEntity(props: { entity: botanicalInfo, requestor: AxiosInstance }) {
    return (
        <Card sx={{ width: isBigScreen() ? "30vw" : "100%", borderRadius: "5px" }}>
            <CardActionArea>
                <Box sx={{
                        position: "absolute",
                        bottom: "75px",
                        right: "15px",
                        backgroundColor: "primary.main",
                        borderRadius: "50%",
                        padding: "5px",
                        zIndex: 10
                    }}>
                    <AddRoundedIcon/>
                </Box>

                <CardMedia
                    component="img"
                    height="140px"
                    image={props.entity.imageUrl}
                    alt={props.entity.scientificName}
                />
                <CardContent sx={{ height: "20%" }} >
                    <Typography gutterBottom variant="h5" component="div">
                        {props.entity.scientificName}
                    </Typography>
                    <Typography variant="body2" color="text.secondary">
                        {props.entity.family}, {props.entity.genus}
                    </Typography>
                </CardContent>
            </CardActionArea>
        </Card>
    )
}