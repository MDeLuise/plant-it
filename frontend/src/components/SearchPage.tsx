import { Box, InputAdornment, OutlinedInput, Skeleton, Typography } from "@mui/material";
import { AxiosInstance } from "axios";
import SearchOutlinedIcon from '@mui/icons-material/SearchOutlined';
import CloseOutlinedIcon from '@mui/icons-material/CloseOutlined';
import { useEffect, useState } from "react";
import { botanicalInfo, plant } from "../interfaces";
import { getPlantImg, isBigScreen } from "../common";
import AddPlant from "./AddPlant";
import { Ribbon } from "react-ribbons";

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
        getPlantImg(props.requestor, props.entity.imageUrl)
            .then((res) => {
                setImageLoaded(true);
                setImgSrc(res);
            })
            .catch(err => {
                getPlantImg(props.requestor, undefined)
                    .then(res => {
                        console.error(err);
                        setImageLoaded(true);
                        setImgSrc(res);
                    })
                    .catch(err => {
                        console.error(err);
                        props.printError(`Cannot load image for botanical info "${props.entity.scientificName}"`);
                    });
            });
    };

    useEffect(() => {
        setImageLoaded(false);
        setImageSrc();
    }, [props.entity]);

    return (
        <Box
            boxShadow={5}
            key={`${props.entity.id}-${props.entity.scientificName}`}
            sx={{
                width: isBigScreen() ? "20vw" : "43vw",
                borderRadius: "15px",
                overflow: "hidden",
                aspectRatio: ".65",
                flexShrink: 0,
                position: "relative",
                backgroundImage: `url(${imgSrc})`,
                backgroundSize: "cover",
                backgroundPosition: "center",
                display: "flex",
                flexDirection: "column",
                margin: "0 0 30px 0",
            }}
            onClick={() => props.addClick(props.entity)}
        >
            {
                props.entity.creator === "USER" &&
                <Box sx={{ zIndex: 1, }}>
                    <Ribbon
                        side="right"
                        type="corner"
                        size="normal"
                        backgroundColor="#02634a"
                        color="white"
                        withStripes={false}
                        fontFamily="Raleway"
                    >
                        Custom
                    </Ribbon>
                </Box>
            }
            {
                !imageLoaded &&
                <Skeleton
                    variant="rounded"
                    animation="wave"
                    sx={{ width: "100%", height: "100%", zIndex: 1, }}
                />
            }
            <img
                src={imgSrc}
                style={{
                    position: "absolute",
                    width: "100%",
                    height: "100%",
                    objectFit: "cover",
                    objectPosition: "center",
                }}
            />
            <Box
                sx={{
                    flexGrow: 1,
                }}
            />
            <Box sx={{
                height: "25%",
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                textAlign: "center",
                backgroundColor: props.entity.imageId !== undefined ?
                    "rgba(255, 255, 255, .1)" : "rgb(7 7 7 / 16%)",
                backdropFilter: "blur(3px)",
            }}>
                <Typography variant="h6" sx={{ color: "white" }}>
                    {props.entity.scientificName}
                </Typography>
            </Box>
        </Box>
    );
}

function AddNewBotanicalInfo(props: {
    addClick: () => void,
    requestor: AxiosInstance,
    searchedTerm: string;
}) {
    //const [imageLoaded, setImageLoaded] = useState<boolean>(false);

    return <Box
        boxShadow={5}
        key={"botanical-info-custom"}
        sx={{
            width: isBigScreen() ? "20vw" : "43vw",
            borderRadius: "15px",
            overflow: "hidden",
            aspectRatio: ".65",
            flexShrink: 0,
            position: "relative",
            backgroundImage: `url(${process.env.PUBLIC_URL}add-custom.jpg)`,
            backgroundSize: "cover",
            backgroundPosition: "center",
            display: "flex",
            flexDirection: "column",
            margin: "0 0 30px 0",
        }}
        onClick={props.addClick}
    >
        {/* {
        !imageLoaded &&
        <Skeleton
            variant="rounded"
            animation="wave"
            sx={{ width: "100%", height: "100%" }}
        />
    } */}
        <Box sx={{
            height: "100%",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            textAlign: "center",
            backgroundColor: "rgba(255, 255, 255, .1)",
            backdropFilter: "blur(3px)",
        }}>
            <Typography variant="h6" sx={{ color: "white" }}>
                Custom
            </Typography>
        </Box>
    </Box>;
}

export default function SearchPage(props: {
    requestor: AxiosInstance,
    plants: plant[],
    printError: (err: any) => void,
    refreshPlants: () => void;
}) {
    const [scientificName, setScientificName] = useState<string>("");
    const [botanicalInfos, setBotanicalInfos] = useState<botanicalInfo[]>([]);
    const [loading, setLoading] = useState<boolean>(true);
    const [addPlantOpen, setAddPlantOpen] = useState<boolean>(false);
    const [selectedBotanicalInfo, setSelectedBotanicalInfo] = useState<botanicalInfo>();

    const retrieveBotanicalInfos = (): void => {
        let backendUrl: string;
        if (scientificName === "") {
            backendUrl = "botanical-info";
        } else {
            backendUrl = `botanical-info/partial/${scientificName}`;
        }
        setLoading(true);
        props.requestor.get(backendUrl)
            .then(res => {
                let newBotanicalInfos: botanicalInfo[] = [];
                res.data.forEach((botanicalInfo: botanicalInfo) => {
                    newBotanicalInfos.push(botanicalInfo);
                });
                setBotanicalInfos(newBotanicalInfos);
            })
            .catch(props.printError)
            .finally(() => setLoading(false));
    };

    useEffect(() => {
        retrieveBotanicalInfos();
    }, [scientificName, props.plants]);

    return (
        <Box>
            <AddPlant
                requestor={props.requestor}
                open={addPlantOpen}
                close={() => setAddPlantOpen(false)}
                botanicalInfoToAdd={selectedBotanicalInfo}
                botanicalInfos={botanicalInfos}
                plants={props.plants}
                name={scientificName}
                printError={props.printError}
                refreshBotanicalInfosAndPlants={() => {
                    retrieveBotanicalInfos();
                    props.refreshPlants();
                }}
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
                            sx={{ width: isBigScreen() ? "30vw" : "48%", height: "250px" }}
                        />
                        <Skeleton
                            variant="rounded"
                            animation="wave"
                            sx={{ width: isBigScreen() ? "30vw" : "48%", height: "250px" }}
                        />
                    </>
                }
                {
                    botanicalInfos.map(botanicalInfo => {
                        return <BotanicalEntity
                            entity={botanicalInfo}
                            requestor={props.requestor}
                            addClick={(arg: botanicalInfo) => {
                                setSelectedBotanicalInfo(arg);
                                setAddPlantOpen(true);
                            }}
                            addEntity={(en: plant) => props.plants.push(en)}
                            key={`${botanicalInfo.id}-${botanicalInfo.scientificName}`}
                            printError={props.printError}
                        />;
                    })
                }
                <AddNewBotanicalInfo
                    addClick={() => {
                        setSelectedBotanicalInfo(undefined);
                        setAddPlantOpen(true);
                    }}
                    searchedTerm={scientificName}
                    requestor={props.requestor}
                />
            </Box>
        </Box>
    );
};