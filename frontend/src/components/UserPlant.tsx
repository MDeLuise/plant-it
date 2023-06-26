import { Box, Skeleton, Typography } from "@mui/material";
import { trackedEntity } from "../interfaces";
import { isBigScreen } from "../common";
import { NavigateFunction, useNavigate } from "react-router-dom";
import { useEffect, useState } from "react";
import { AxiosInstance } from "axios";
import { Buffer } from "buffer";

export default function UserPlant(props: {
    entity: trackedEntity,
    style?: {},
    requestor: AxiosInstance;
}) {
    let navigate: NavigateFunction = useNavigate();
    const [imageLoaded, setImageLoaded] = useState<boolean>(false);
    const [downloadedImg, setDownloadedImg] = useState<string>();
    let imgSrc = props.entity.botanicalInfo.imageUrl != undefined ?
        props.entity.botanicalInfo.imageUrl :
        props.entity.botanicalInfo.imageId != undefined ?
            `data:image/png;base64,${downloadedImg}` : process.env.PUBLIC_URL + "botanical-info-no-img.png";

    const readImage = (): void => {
        props.requestor.get(`image/botanical-info/${props.entity.botanicalInfo.imageId}`)
            .then((res) => {
                setDownloadedImg(Buffer.from(res.data.content, "utf-8").toString());
            });
    };

    useEffect(() => {
        if (props.entity.botanicalInfo.imageUrl == undefined &&
            props.entity.botanicalInfo.imageId != undefined) {
            readImage();
        }
    });

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