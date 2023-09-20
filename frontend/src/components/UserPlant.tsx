import { Box, Skeleton, Typography } from "@mui/material";
import { AxiosInstance } from "axios";
import { useState, useEffect } from "react";
import { getBotanicalInfoImg, isBigScreen } from "../common";
import { plant } from "../interfaces";

export default function NewUserPlant(props: {
    entity: plant,
    style?: {},
    requestor: AxiosInstance,
    onClick: () => void,
    active: boolean,
    printError: (err: any) => void;
}) {
    const [imageLoaded, setImageLoaded] = useState<boolean>(false);
    const [imgSrc, setImgSrc] = useState<string>();
    const [wasRenderedOnce, setWasRenderedOnce] = useState<boolean>(false);

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
                        console.error(err);
                        props.printError("Cannot load image for plant " + props.entity.personalName);
                    });
            });
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
                // backgroundImage: `url(${imgSrc})`,
                // backgroundSize: "cover",
                // backgroundPosition: "center",
                display: "flex",
                flexDirection: "column",
                //border: "1px solid white",
                margin: "0 0 30px 0",
            }}
        >
            {
                (!imageLoaded || !wasRenderedOnce) &&
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
                imageLoaded && wasRenderedOnce &&
                <img
                    src={imgSrc}
                    style={{
                        position: "absolute",
                        height: "100%",
                        width: "100%",
                        objectFit: "cover",
                        objectPosition: "center",
                    }}
                    onLoad={() => setImageLoaded(true)}
                />
            }
            <Box
                sx={{
                    flexGrow: 1,
                }}
            />
            {
                imageLoaded && wasRenderedOnce &&
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