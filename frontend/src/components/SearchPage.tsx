import { Box, Chip, InputAdornment, OutlinedInput, Skeleton, Typography } from "@mui/material";
import { AxiosInstance } from "axios";
import SearchOutlinedIcon from '@mui/icons-material/SearchOutlined';
import CloseOutlinedIcon from '@mui/icons-material/CloseOutlined';
import { useEffect, useState } from "react";
import { botanicalInfo, plant } from "../interfaces";
import { getBotanicalInfoImg, isBigScreen } from "../common";
import AddOutlinedIcon from '@mui/icons-material/AddOutlined';
import AddPlant from "./AddPlant";
import FaceOutlinedIcon from '@mui/icons-material/FaceOutlined';
import { alpha } from "@mui/material";

function BotanicalEntity(props: {
    entity: botanicalInfo,
    requestor: AxiosInstance,
    addClick: (arg: botanicalInfo) => void,
    addEntity: (arg: plant) => void,
    printError: (err: any) => void;
}) {
    const [imageLoaded, setImageLoaded] = useState<boolean>(false);
    const [imgSrc, setImgSrc] = useState<string>();

    const setImageSrc = (): void => {
        getBotanicalInfoImg(props.requestor, props.entity.imageUrl)
            .then((res) => {
                setImageLoaded(true);
                setImgSrc(res);
            })
            .catch((err) => {
                props.printError(err);
            });
    };

    useEffect(() => {
        setImageLoaded(false);
        setImageSrc();
    }, [props.entity]);

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
            {
                !imageLoaded &&
                <Skeleton
                    variant="rounded"
                    animation="wave"
                    sx={{ width: "100%", height: "100%" }}
                />
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
                icon={<FaceOutlinedIcon color="inherit" />} label="Custom"
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
        {
            !imageLoaded &&
            <Skeleton
                variant="rounded"
                animation="wave"
                sx={{
                    width: "100%",
                    height: "100%"
                }}
            />
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
    plants: plant[],
    printError: (err: any) => void;
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
            .catch((err) => {
                props.printError(err);
            })
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
                plants={props.plants}
                name={scientificName}
                printError={props.printError}
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
                        <Skeleton
                            variant="rounded"
                            animation="wave"
                            sx={{ width: isBigScreen() ? "30vw" : "100%", height: "180px" }}
                        />
                        <Skeleton
                            variant="rounded"
                            animation="wave"
                            sx={{ width: isBigScreen() ? "30vw" : "100%", height: "180px" }}
                        />
                    </>
                }
                {
                    botanicalInfos.map((botanicalInfo, index) => {
                        return <BotanicalEntity
                            entity={botanicalInfo}
                            requestor={props.requestor}
                            addClick={(arg: botanicalInfo) => {
                                setSelectedBotanicalInfo(arg);
                                setAddPlantOpen(true);
                            }}
                            addEntity={(en: plant) => props.plants.push(en)}
                            key={index}
                            printError={props.printError}
                        />;
                    })
                }
                <AddNewBotanicalInfo addClick={() => {
                    setSelectedBotanicalInfo(undefined);
                    setAddPlantOpen(true);
                }}
                    searchedTerm={scientificName}
                    requestor={props.requestor} />
            </Box>
        </Box>
    );
};