import { Box, Card, CardActionArea, CardContent, CardMedia, Typography } from "@mui/material";
import { botanicalName } from "../interfaces";
import { useEffect, useState } from "react";
import { AxiosInstance } from "axios";
import { Buffer } from "buffer";
import { isBigScreen } from "../common";

export default function BotanicalEntity(props: { entity: botanicalName, requestor: AxiosInstance }) {
    const [image, setImage] = useState<string>();

    useEffect(() => {
        props.requestor.get(`image/${props.entity.imageId}`, { responseType: 'arraybuffer' })
            .then((res) => {
                setImage(Buffer.from(res.data).toString("base64"));
            })
    }, [props.entity]);

    return (
        // <Box sx={{
        //     width: isBigScreen() ? "30vw" : "39vw",
        //     borderRadius: "5px",
        //     overflow: "hidden",
        //     aspectRatio: "9 / 20"
        // }}>
        //     {image != undefined &&
        //         <img
        //             src={`data:image/png;base64,${image}`}
        //             style={{
        //                 width: "100%",
        //                 height: "65%",
        //                 objectFit: "cover"
        //             }}
        //         />
        //     }
        //     <Typography variant="h6">
        //         {props.entity.scientificName}
        //     </Typography>
        //     <Typography variant="body1">
        //         {props.entity.family}, {props.entity.genus}
        //     </Typography>
        // </Box >
        <Card sx={{ width: isBigScreen() ? "30vw" : "100%" }}>
            <CardActionArea>
                <CardMedia
                    component="img"
                    height="140px"
                    image={`data:image/png;base64,${image}`}
                    alt={props.entity.scientificName}
                />
                <CardContent sx={{height: "20%"}} >
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