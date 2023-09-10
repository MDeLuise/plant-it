import { Box, Skeleton, Typography } from "@mui/material";
import { plant } from "../interfaces";
import { getBotanicalInfoImg, isBigScreen } from "../common";
import { useEffect, useState } from "react";
import { AxiosInstance } from "axios";

export default function UserPlant(props: {
    entity: plant,
    style?: {},
    requestor: AxiosInstance,
    onClick: () => void,
    printError: (err: any) => void;
}) {
    const [imageLoaded, setImageLoaded] = useState<boolean>(false);
    const [imgSrc, setImgSrc] = useState<string>();

    const setImageSrc = (): void => {
        getBotanicalInfoImg(props.requestor, props.entity.botanicalInfo.imageUrl)
            .then((res) => {
                setImageLoaded(true);
                setImgSrc(res);
            })
            .catch((err) => {
                props.printError(err);
                getBotanicalInfoImg(props.requestor, undefined)
                    .then((res) => {
                        setImageLoaded(true);
                        setImgSrc(res);
                    })
                    .catch((err) => {
                        console.log(err);
                        props.printError("Cannot load image for plant " + props.entity.personalName);
                    });
            });
    };

    useEffect(() => {

    return (
        <Box
            onClick={props.onClick}
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
            {
                !imageLoaded &&
                <Skeleton variant="rounded" animation="wave" sx={{ width: "100%", height: "80%" }} />
            }
            <img
                src={imgSrc}
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
    );
}