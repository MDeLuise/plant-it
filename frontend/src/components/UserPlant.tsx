import { Box, Skeleton, Typography } from "@mui/material";
import { AxiosInstance } from "axios";
import { useState, useEffect } from "react";
import { getPlantAvatarImgSrc, isBigScreen } from "../common";
import { plant } from "../interfaces";

export default function UserPlant(props: {
    entity: plant,
    style?: {},
    requestor: AxiosInstance,
    onClick: () => void,
    active: boolean,
    printError: (err: any) => void;
}) {
    const [imageDownloaded, setImageDownloaded] = useState<boolean>(false);
    const [imgSrc, setImgSrc] = useState<string>();
    const [wasRenderedOnce, setWasRenderedOnce] = useState<boolean>(false);

    const setImageSrc = (): void => {
        getPlantAvatarImgSrc(props.requestor, props.entity)
            .then(res => {
                setImgSrc(res);
                setImageDownloaded(true);
            })
            .catch(err => {
                console.error(err);
                props.printError("Cannot load plant's avatar image");
            })
    };

    useEffect(() => {
        if (props.active) {
            setWasRenderedOnce(true);
        }
        if (!wasRenderedOnce) {
            setImageSrc();
        }
    }, [props.active]);

    useEffect(() => {
        setImageSrc();
    }, [props.entity]);

    return (
        <Box
            onClick={props.onClick}
            boxShadow={5}
            sx={{
                width: isBigScreen() ? "20vw" : "45vw",
                borderRadius: "15px",
                overflow: "hidden",
                aspectRatio: ".65",
                flexShrink: 0,
                position: "relative",
                display: "flex",
                flexDirection: "column",
                margin: "0 0 30px 0",
            }}
        >
            {
                (!imageDownloaded || !wasRenderedOnce) &&
                <Skeleton
                    variant="rounded"
                    animation="wave"
                    sx={{ width: "100%", height: "80%" }}
                    style={{
                        height: "100%",
                        width: "100%",
                        objectFit: "cover"
                    }}
                />
            }
            {
                imageDownloaded && wasRenderedOnce &&
                <img
                    src={imgSrc}
                    style={{
                        position: "absolute",
                        height: "100%",
                        width: "100%",
                        objectFit: "cover",
                        objectPosition: "center",
                    }}
                    onLoad={() => setImageDownloaded(true)}
                />
            }
            <Box
                sx={{
                    flexGrow: 1,
                }}
            />
            {
                imageDownloaded && wasRenderedOnce &&
                <Box sx={{
                    height: "25%",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    textAlign: "center",
                    backgroundColor: props.entity.botanicalInfo.imageId !== undefined ? "rgba(255, 255, 255, .1)" : "rgb(7 7 7 / 16%)",
                    backdropFilter: "blur(3px)",
                }}>
                    <Typography variant="h6" sx={{ color: "white" }}>
                        {props.entity.personalName}
                    </Typography>
                </Box>
            }
        </Box >
    );
}