import { Box, Chip, InputAdornment, OutlinedInput, Skeleton, Typography } from "@mui/material";
import { AxiosInstance } from "axios";
import SearchOutlinedIcon from '@mui/icons-material/SearchOutlined';
import CloseOutlinedIcon from '@mui/icons-material/CloseOutlined';
import { useEffect, useState } from "react";
import { botanicalInfo, trackedEntity } from "../interfaces";
import { isBigScreen } from "../common";
import AddOutlinedIcon from '@mui/icons-material/AddOutlined';
import AddPlant from "./AddPlant";
import { Buffer } from "buffer";
import FaceOutlinedIcon from '@mui/icons-material/FaceOutlined';
import { alpha } from "@mui/material";

function BotanicalEntity(props: {
    entity: botanicalInfo,
    requestor: AxiosInstance,
    addClick: (arg: botanicalInfo) => void,
    addEntity: (arg: trackedEntity) => void;
}) {
    const [imageLoaded, setImageLoaded] = useState<boolean>(false);
    const [downloadedImg, setDownloadedImg] = useState<string>();
    let imgSrc = props.entity.imageUrl != undefined ?
        props.entity.imageUrl :
        props.entity.imageId != undefined ?
            `data:image/png;base64,${downloadedImg}` : process.env.PUBLIC_URL + "botanical-info-no-img.png";

    const readImage = (): void => {
        props.requestor.get(`image/botanical-info/${props.entity.imageId}`)
            .then((res) => {
                setDownloadedImg(Buffer.from(res.data.content, "utf-8").toString());
            });
    };

    useEffect(() => {
        if (props.entity.imageUrl == undefined &&
            props.entity.imageId != undefined) {
            readImage();
        }
    });

    return (
        <Box
            key={props.entity.id}
            sx={{
                width: isBigScreen() ? "20vw" : "43vw",
                borderRadius: "5px",
                overflow: "hidden",
                aspectRatio: ".65",
                flexShrink: 0,
                position: "relative",
            }}
            onClick={() => props.addClick(props.entity)}
        >
            {!imageLoaded &&
                <Skeleton variant="rounded" animation="wave" sx={{ width: "100%", height: "100%" }} />
            }

            <Chip
                sx={{
                    position: "absolute",
                    bottom: "65px",
                    right: "5px",
                    backgroundColor: alpha("#3a5e49", .7),
                    padding: "5px",
                    zIndex: 1,
                    color: "white",
                    display: props.entity.systemWide ? "none" : "inherit"
                }}
                icon={<FaceOutlinedIcon color="inherit"/>} label="Custom"
            />

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
            <Typography noWrap variant="body1" style={{ fontWeight: 600, textOverflow: "hidden" }} >
                {props.entity.scientificName}
            </Typography>
            <Typography variant="body1">
                {props.entity.family}
            </Typography>
        </Box>
    );
}

function AddNewBotanicalInfo(props: {
    addClick: () => void,
    requestor: AxiosInstance,
    searchedTerm: string;
}) {
    const [imageLoaded, setImageLoaded] = useState<boolean>(false);

    return <Box
        key={"new"}
        sx={{
            width: isBigScreen() ? "20vw" : "43vw",
            borderRadius: "5px",
            overflow: "hidden",
            aspectRatio: ".65",
            flexShrink: 0,
            position: "relative",
        }}
        onClick={() => props.addClick()}
    >
        {!imageLoaded &&
            <Skeleton variant="rounded" animation="wave" sx={{ width: "100%", height: "100%" }} />
        }

        <Box sx={{
            position: "absolute",
            bottom: "65px",
            right: "10px",
            backgroundColor: "primary.light",
            borderRadius: "50%",
            padding: "5px",
            zIndex: 1,
            color: "white",
            visibility: imageLoaded ? "initial" : "hidden",
        }}>
            <AddOutlinedIcon />
        </Box>

        <Box sx={{
            overflow: "hidden",
            borderRadius: "10px",
            width: "100%",
            height: "80%",
            marginBottom: "5px",
            visibility: imageLoaded ? "initial" : "hidden",
        }}>
            <img
                src={"https://www.gardeningknowhow.com/wp-content/uploads/2018/12/Perle-von-Nurnberg.jpg"}
                onLoad={() => setImageLoaded(true)}
                style={{
                    width: "100%",
                    height: "100%",
                    objectFit: "cover",
                    borderRadius: "10px",
                    filter: "blur(7px)",
                }}
            />
        </Box>
        <Typography noWrap variant="body1" style={{ fontWeight: 600, textOverflow: "hidden" }} >
            Custom
        </Typography>
    </Box>;
}

export default function SearchPage(props: {
    requestor: AxiosInstance,
    trackedEntities: trackedEntity[];
}) {
    const [scientificName, setScientificName] = useState<string>("");
    const [botanicalInfos, setBotanicalInfos] = useState<botanicalInfo[]>([]);
    const [loading, setLoading] = useState<boolean>(true);
    const [addPlantOpen, setAddPlantOpen] = useState<boolean>(false);
    const [selectedBotanicalInfo, setSelectedBotanicalInfo] = useState<botanicalInfo>();

    const retrieveBotanicalInfos = (): void => {
        let backendUrl: string;
        if (scientificName == "") {
            backendUrl = "botanical-info";
        } else {
            backendUrl = `botanical-info/partial/${scientificName}`;
        }
        setLoading(true);
        props.requestor.get(backendUrl)
            .then((res => {
                let newBotanicalInfos: botanicalInfo[] = [];
                res.data.forEach((botanicalInfo: botanicalInfo) => {
                    newBotanicalInfos.push(botanicalInfo);
                });
                setBotanicalInfos(newBotanicalInfos);
            }))
            .finally(() => setLoading(false));
    };

    useEffect(() => {
        retrieveBotanicalInfos();
    }, [scientificName]);

    return (
        <Box>
            <AddPlant
                requestor={props.requestor}
                open={addPlantOpen}
                setOpen={setAddPlantOpen}
                entity={selectedBotanicalInfo}
                trackedEntities={props.trackedEntities}
                name={scientificName}
            />

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
                placeholder="Search new green friends"
                value={scientificName}
                onChange={(event: React.ChangeEvent<HTMLInputElement>) => setScientificName(event.target.value)}
                sx={{
                    margin: "5px 0",
                    backgroundColor: "#eae8e8",
                }}
            />
            <Box sx={{
                display: "flex",
                gap: "10px",
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
                    return <BotanicalEntity
                        entity={botanicalInfo}
                        requestor={props.requestor}
                        addClick={(arg: botanicalInfo) => {
                            setSelectedBotanicalInfo(arg);
                            setAddPlantOpen(true);
                        }}
                        addEntity={(en: trackedEntity) => props.trackedEntities.push(en)}
                    />;
                })}
                < AddNewBotanicalInfo addClick={() => {
                    setSelectedBotanicalInfo(undefined);
                    setAddPlantOpen(true);
                }}
                    searchedTerm={scientificName}
                    requestor={props.requestor} />
            </Box>
        </Box>
    );
};