import { Box, InputAdornment, OutlinedInput, Skeleton, Typography } from "@mui/material";
import { AxiosInstance } from "axios";
import SearchOutlinedIcon from '@mui/icons-material/SearchOutlined';
import CloseOutlinedIcon from '@mui/icons-material/CloseOutlined';
import { useEffect, useState } from "react";
import { botanicalInfo } from "../interfaces";
import { isBigScreen } from "../common";

function BotanicalEntity(props: { entity: botanicalInfo, requestor: AxiosInstance }) {
    const [imageLoaded, setImageLoaded] = useState<boolean>(false);

    return (
        <Box
            boxShadow={2}
            sx={{
                width: isBigScreen() ? "20%" : "45%",
                borderRadius: "5px",
                overflow: "hidden",
                aspectRatio: ".7",
                backgroundColor: "background.paper",
                padding: "10px",
                flexShrink: 0,
            }}>
            {!imageLoaded &&
                <Skeleton variant="rounded" animation="wave" sx={{ width: "100%", height: "100%" }} />
            }
            <img
                src={props.entity.imageUrl}
                onLoad={() => setImageLoaded(true)}
                onError={() => setImageLoaded(true)}
                style={{
                    width: "100%",
                    height: "70%",
                    objectFit: "cover",
                    borderRadius: "5px",
                    marginBottom: "10px",
                    visibility: imageLoaded ? "initial" : "hidden"
                }}
            />
            <Typography variant="body1" style={{ fontWeight: 600 }}>
                {props.entity.scientificName}
            </Typography>
            <Typography variant="body1">
                {props.entity.family}
            </Typography>
        </Box>
    )
}

export default function SearchPage(props: { requestor: AxiosInstance }) {
    const [scientificName, setScientificName] = useState<string>("");
    const [botanicalInfos, setBotanicalInfos] = useState<botanicalInfo[]>([]);
    const [loading, setLoading] = useState<boolean>(true);

    const retrieveBotanicalInfos = (): void => {
        let backendUrl: string;
        if (scientificName == "") {
            backendUrl = "botanical-info"
        } else {
            backendUrl = `botanical-info/partial/${scientificName}`
        }
        setLoading(true);
        props.requestor.get(backendUrl)
            .then((res => {
                let newBotanicalInfos: botanicalInfo[] = [];
                res.data.content.forEach((botanicalName: botanicalInfo) => {
                    newBotanicalInfos.push(botanicalName);
                })
                setBotanicalInfos(newBotanicalInfos);
            }))
            .finally(() => setLoading(false))
    }

    useEffect(() => {
        retrieveBotanicalInfos();
    }, [scientificName]);

    return (
        <Box>
            <OutlinedInput
                fullWidth
                startAdornment={
                    <InputAdornment position="start" sx={{ opacity: 0.5 }}>
                        <SearchOutlinedIcon />
                    </InputAdornment>
                }
                endAdornment={
                    <InputAdornment position="start" sx={{ opacity: 0.5 }}>
                        <CloseOutlinedIcon
                            sx={{ visibility: scientificName === "" ? "hidden" : "initial" }}
                            onClick={() => setScientificName("")}
                        />
                    </InputAdornment>
                }
                placeholder="Search new plants"
                value={scientificName}
                onChange={(event: React.ChangeEvent<HTMLInputElement>) => setScientificName(event.target.value)}
                sx={{
                    margin: "5px 0"
                }}
            />
            <Box sx={{
                display: "flex",
                gap: "20px",
                flexWrap: "wrap",
                marginTop: "30px"
            }}>
                {
                    loading &&
                    <>
                        <Skeleton variant="rounded" animation="wave" sx={{ width: isBigScreen() ? "30vw" : "100%", height: "180px" }} />
                        <Skeleton variant="rounded" animation="wave" sx={{ width: isBigScreen() ? "30vw" : "100%", height: "180px" }} />
                    </>
                }
                {botanicalInfos.map(botanicalInfo => {
                    return <BotanicalEntity entity={botanicalInfo} requestor={props.requestor} />
                })}
            </Box>
        </Box>
    )
}