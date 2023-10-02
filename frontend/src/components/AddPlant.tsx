import { Box, Button, Drawer, Link, Skeleton, Switch, TextField, Typography } from "@mui/material";
import { AxiosError, AxiosInstance } from "axios";
import { botanicalInfo, plant } from "../interfaces";
import { useEffect, useState } from "react";
import dayjs, { Dayjs } from "dayjs";
import { LocalizationProvider, DatePicker } from "@mui/x-date-pickers";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import { getPlantImg, imgToBase64 } from "../common";
import ArrowBackOutlinedIcon from '@mui/icons-material/ArrowBackOutlined';
import AddPhotoAlternateIcon from '@mui/icons-material/AddPhotoAlternate';

function AddPlantHeader(props: {
    requestor: AxiosInstance,
    botanicalInfo?: botanicalInfo,
    open: boolean,
    close: () => void,
    printError: (arg: any) => void,
    image?: File | string;
}) {
    const [imageLoaded, setImageLoaded] = useState<boolean>(false);
    const [imgSrc, setImgSrc] = useState<string>();

    const setFallbackImg = (err?: AxiosError) => {
        getPlantImg(props.requestor, undefined)
            .then(res => {
                if (err !== undefined) {
                    console.error(err);
                }
                imgToBase64(res, (arg: string) => {
                    setImgSrc(`data:application/octet-stream;base64,${arg}`);
                });
            })
            .catch(err => {
                console.error(err);
                props.printError(`Cannot load image with id ${props.botanicalInfo?.imageId}`);
            });
    };

    const setImgSrcAsBase64 = (imageUrl: string): void => {
        props.requestor.get(`image/content${imageUrl}`)
            .then(res => {
                setImgSrc(`data:application/octet-stream;base64,${res.data}`);
            })
            .catch(err => {
                setFallbackImg(err);
            });
    };

    const setAbsoluteImageUrl = (imageUrl: string | undefined): void => {
        if (imageUrl === undefined || imageUrl === null) {
            setFallbackImg();
        } else if (imageUrl.startsWith("/")) {
            setImgSrcAsBase64(imageUrl);
        } else {
            setImgSrc(imageUrl);
        }
    };

    const fileToBase64 = (file: File, callback: (arg: string) => void) => {
        var reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = function () {
            callback(reader.result as string);
        };
        reader.onerror = err => {
            console.error(err);
            props.printError("Cannot upload image");
        };
    };

    useEffect(() => {
        if (!props.open) {
            setImageLoaded(false);
            setImgSrc(undefined);
        }
    }, [props.open]);

    useEffect(() => {
        if (props.image === undefined && props.botanicalInfo?.imageUrl === undefined) {
            setFallbackImg();
        } else if (props.botanicalInfo?.imageUrl !== undefined) {
            setAbsoluteImageUrl(props.botanicalInfo?.imageUrl);
        } else if (props.image instanceof File) {
            fileToBase64(props.image, (arg: string) => setImgSrc(`data:${arg}`));
        } else if (typeof (props.image) === "string") {
            setAbsoluteImageUrl(props.image);
        }
    }, [props.image]);

    return <Box height={"40vh"} id="add-plant-header" sx={{ transition: ".5s height", }}>
        {
            !imageLoaded &&
            <Skeleton
                variant="rectangular"
                animation="wave"
                sx={{
                    width: "100%",
                    height: "100%",
                }}
            />
        }
        {
            props.open &&
            <img
                src={imgSrc}
                style={{
                    height: "100%",
                    width: "100%",
                    objectFit: "cover",
                }}
                onLoad={() => setImageLoaded(true)}
            />
        }

        <Box
            sx={{
                position: "absolute",
                top: "10px",
                left: "0",
                zIndex: 2,
                display: "flex",
                width: "100%",
                justifyContent: "space-between",
                alignItems: "center",
                padding: "0 15px",
            }}
        >
            <ArrowBackOutlinedIcon
                sx={{
                    backdropFilter: "blur(10px)",
                    color: "white",
                    borderRadius: "50%",
                    padding: "5px",
                    backgroundColor: "rgba(32, 32, 32, .1)",
                }}
                fontSize="large"
                onClick={props.close}
            />
        </Box>
    </Box>;
}

function AddPlantInfo(props: {
    requestor: AxiosInstance,
    botanicalInfoToAdd?: botanicalInfo,
    botanicalInfos: botanicalInfo[],
    name?: string,
    plants: plant[],
    open: boolean,
    close: () => void,
    selectedImage?: File,
    setSelectedImage: (arg: File) => void,
    printError: (arg: any) => void;
}) {
    const [plantName, setPlantName] = useState<string>("");
    const [plantNameError, setPlantNameError] = useState<string>();
    const [family, setFamily] = useState<string>("");
    const [genus, setGenus] = useState<string>("");
    const [species, setSpecies] = useState<string>("");
    const [note, setNote] = useState<string>("");
    const [date, setDate] = useState<Dayjs>(dayjs(new Date()));
    const [useDate, setUseDate] = useState<boolean>(true);

    const setName = (): Promise<string> => {
        return new Promise((resolve, reject) => {
            if (props.botanicalInfoToAdd === undefined) {
                if (props.name === undefined) {
                    setPlantName("");
                    return resolve("");
                } else {
                    setPlantName(props.name);
                    return resolve(props.name);
                }
            }
            if (props.botanicalInfoToAdd.id === null) {
                setPlantName(props.botanicalInfoToAdd.scientificName);
                return resolve(props.botanicalInfoToAdd.scientificName);
            }
            props.requestor.get(`/botanical-info/${props.botanicalInfoToAdd.id}/_count`)
                .then(res => {
                    let incrementalName = props.botanicalInfoToAdd!.scientificName;
                    if (res.data > 0) {
                        incrementalName += ` ${res.data}`;
                    }
                    setPlantName(incrementalName);
                    return resolve(incrementalName);
                })
                .catch(err => {
                    return reject(err);
                });
        });
    };


    const isNameAvailable = (name: string): Promise<boolean> => {
        return new Promise((resolve, reject) => {
            props.requestor.get(`/plant/${name}/_name-exists`)
                .then((res) => {
                    if (res.data) {
                        return resolve(false);
                    } else {
                        return resolve(true);
                    }
                })
                .catch((err) => {
                    return reject(err);
                });
        });
    };

    const addPlant = (): void => {
        if (plantName == undefined || plantName.length == 0) {
            setPlantNameError("Plant name size must be between 1 and 30 characters");
            return;
        }
        isNameAvailable(plantName)
            .then(res => {
                if (!res) {
                    setPlantNameError("Duplicated plant name");
                    return;
                }
                if (props.botanicalInfoToAdd != undefined) {
                    addPlantOldBotanicalInfo();
                } else {
                    addPlantNewBotanicalInfo();
                }
            })
            .catch(err => {
                props.printError(err);
            });
    };

    const addPlantOldBotanicalInfo = (): void => {
        addNewPlant({
            botanicalInfo: props.botanicalInfoToAdd!,
            personalName: plantName!,
            state: "ALIVE",
            startDate: useDate ? date : null,
            note: note,
            avatarMode: "NONE",
        })
            .then(res => {
                props.close();
                let insertHere = props.plants.findIndex((pl) => {
                    return pl.personalName.toLowerCase() > res.personalName.toLowerCase();
                });
                insertHere = insertHere === -1 ? props.plants.length : insertHere;
                props.plants.splice(insertHere, 0, res);
                props.botanicalInfoToAdd!.id = res.botanicalInfo.id;
                setName();
                cleanup();
            })
            .catch(err => {
                props.printError(err);
            });
    };

    const addPlantNewBotanicalInfo = (): void => {
        let botanicalInfoToUse = {
            scientificName: species != "" ? species : plantName,
            family: family,
            genus: genus,
            species: species != "" ? species : plantName,
            isSystemWide: false,
        };
        let plantToAdd = {
            botanicalInfo: botanicalInfoToUse,
            personalName: plantName,
            state: "ALIVE",
            startDate: useDate ? date : null,
            note: note,
            avatarMode: "NONE",
        };
        addNewPlant(plantToAdd)
            .then(res => {
                if (props.selectedImage != undefined) {
                    let formData = new FormData();
                    formData.append('image', props.selectedImage!);
                    props.requestor.post(`/image/botanical-info/${res.botanicalInfo.id}`, formData)
                        .then(imgRes => {
                            props.close();
                            res.botanicalInfo.imageUrl = "/" + imgRes.data.id;
                            let insertHere = props.plants.findIndex(pl => {
                                return pl.personalName.toLowerCase() > res.personalName.toLowerCase();
                            });
                            insertHere = insertHere === -1 ? props.plants.length : insertHere;
                            props.plants.splice(insertHere, 0, res);
                            setName();

                            props.botanicalInfos.push(res.botanicalInfo);
                            
                            cleanup();
                        })
                        .catch(err => {
                            props.printError(err);
                        });
                } else {
                    props.close();
                    let insertHere = props.plants.findIndex((pl) => {
                        return pl.personalName.toLowerCase() > res.personalName.toLowerCase();
                    });
                    insertHere = insertHere === -1 ? props.plants.length : insertHere;
                    props.plants.splice(insertHere, 0, res);
                    setName();
                    cleanup();
                }
            })
            .catch(err => {
                props.printError(err);
            });
    };

    const addNewPlant = (plant: {}): Promise<plant> => {
        return new Promise((accept, reject) => {
            props.requestor.post("plant", plant)
                .then(res => {
                    if (res.status == 200) {
                        accept(res.data);
                    } else {
                        reject(res.data);
                    }
                })
                .catch(err => reject(err));
        });
    };

    const changePlantName = (name: string): void => {
        setPlantNameError(undefined);
        setPlantName(name);
    };

    const cleanup = (): void => {
        setFamily("");
        setGenus("");
        setPlantName("");
        setUseDate(true);
        setDate(dayjs(new Date()));
        setPlantNameError(undefined);
    };

    useEffect(() => {
        props.open || cleanup();
        setName();
    }, [props.open]);

    return <Box sx={{
        position: "relative",
        top: "-80px",
        backgroundColor: "background.default",
        borderRadius: "35px",
        padding: "30px",
        paddingTop: 0,
        minHeight: "130vh",
        zIndex: 1,
    }}>
        <input
            id="upload-image"
            type="file"
            accept="image/*"
            hidden
            onChange={(event) => {
                if (event.target.files != undefined) {
                    props.setSelectedImage(event.target.files[0]);
                }
            }}
        />

        <Box sx={{
            width: "30px",
            height: "3px",
            backgroundColor: "accent.secondary",
            opacity: .5,
            borderRadius: "20px",
            position: "absolute",
            left: "calc(50% - 15px)",
            top: "5px",
        }}
        />
        <Box
            className="plant-detail-section">
            <Typography variant="h6">
                Scientific classification
            </Typography>

            <Box className="plant-detail-entry">
                <Typography>
                    Family
                </Typography>
                <EditableTextField
                    text={props.botanicalInfoToAdd?.family || family}
                    editable={props.botanicalInfoToAdd === undefined}
                    onChange={setFamily}
                />
            </Box>
            <Box className="plant-detail-entry" >
                <Typography>
                    Genus
                </Typography>
                <EditableTextField
                    text={props.botanicalInfoToAdd?.genus || genus}
                    editable={props.botanicalInfoToAdd === undefined}
                    onChange={setGenus}
                />
            </Box>
            <Box className="plant-detail-entry" >
                <Typography>
                    Species
                </Typography>
                <EditableTextField
                    text={props.botanicalInfoToAdd?.species || species}
                    editable={props.botanicalInfoToAdd === undefined}
                    onChange={setSpecies}
                />
            </Box>
            {
                props.botanicalInfoToAdd === undefined &&
                <Box className="plant-detail-entry">
                    <Typography>
                        Thumbnail
                    </Typography>
                    <Typography sx={{ display: "inline-block" }}>
                        <Link onClick={() => {
                            document.getElementById("upload-image")?.click();
                        }}>upload</Link> new
                    </Typography>
                </Box>
            }
        </Box>

        <Box
            className="plant-detail-section">
            <Typography variant="h6">
                Plant
            </Typography>
            <Box style={{ display: "flex", alignItems: "baseline", gap: "5px", justifyContent: "space-between", }}>
                <Typography>
                    Name
                </Typography>
                <TextField
                    variant="standard"
                    value={plantName}
                    onChange={(e) => changePlantName(e.currentTarget.value)}
                    error={plantNameError !== undefined}
                    helperText={plantNameError}
                />
            </Box>
            <Box className="plant-detail-entry" >
                <Typography>
                    Purchased date
                </Typography>
                <Switch
                    checked={useDate}
                    onChange={event => setUseDate(event.target.checked)}
                />
            </Box>
            <Box className="plant-detail-entry" >
                <Typography>
                    Purchased on
                </Typography>
                <LocalizationProvider dateAdapter={AdapterDayjs}>
                    <DatePicker
                        value={date}
                        disabled={!useDate}
                        onChange={(newValue) => setDate(newValue != undefined ? newValue : dayjs(new Date()))}
                        slotProps={{ textField: { variant: 'standard', } }}
                    />
                </LocalizationProvider>
            </Box>
            <Box style={{ display: "flex", flexDirection: "column", alignItems: "baseline", gap: "5px", justifyContent: "space-between", }}>
                <Typography>
                    Note
                </Typography>
                <TextField
                    fullWidth
                    multiline
                    value={note}
                    rows={4}
                    onChange={(e) => setNote(e.currentTarget.value)}
                >
                </TextField>
            </Box>
        </Box>
        <Button
            fullWidth
            sx={{
                backgroundColor: "primary.main",
                color: "white",
                padding: "15px 50px",
            }}
            onClick={addPlant}
        >
            Save plant
        </Button>
    </Box>;
}


function EditableTextField(props: {
    editable: boolean,
    text?: string;
    onChange?: (arg: string) => void;
}) {
    const [value, setValue] = useState<string>(props.text || "");

    useEffect(() => {
        setValue(props.text || "");
    });

    return props.editable ?
        <TextField
            variant="standard"
            InputProps={{ disableUnderline: props.editable ? false : true }}
            disabled={!props.editable}
            onChange={(e) => {
                setValue(e.target.value);
                if (props.onChange != undefined) {
                    props.onChange(e.target.value);
                }
            }}
            value={value}
            sx={{
                color: "black",
            }}
        />
        :
        <Typography>
            {props.text}
        </Typography>;
}


export default function AddPlant(props: {
    requestor: AxiosInstance,
    open: boolean,
    close: () => void,
    botanicalInfoToAdd?: botanicalInfo,
    botanicalInfos: botanicalInfo[],
    plants: plant[],
    name?: string,
    printError: (err: any) => void;
}) {
    const [selectedImage, setSelectedImage] = useState<File>();

    useEffect(() => {
        if (!props.open) {
            setSelectedImage(undefined);
        }
    }, [props.open]);

    return (
        <Drawer
            anchor={"bottom"}
            open={props.open}
            onClose={props.close}
            SlideProps={{
                onScroll: (event: any) => {
                    let currentScroll = event.target.scrollTop;
                    //console.debug(currentScroll)
                    if (currentScroll < 50) {
                        document.getElementById("add-plant-header")!.style.height = "40vh";
                    } else {
                        document.getElementById("add-plant-header")!.style.height = "5vh";
                    }
                }
            }}
        >
            <Box
                sx={{
                    display: "flex",
                    flexDirection: "column",
                    gap: "30px",
                }}
            >
                <AddPlantHeader
                    requestor={props.requestor}
                    open={props.open}
                    close={props.close}
                    botanicalInfo={props.botanicalInfoToAdd}
                    printError={props.printError}
                    image={selectedImage}
                />
                <AddPlantInfo
                    requestor={props.requestor}
                    plants={props.plants}
                    open={props.open}
                    close={props.close}
                    botanicalInfoToAdd={props.botanicalInfoToAdd}
                    botanicalInfos={props.botanicalInfos}
                    printError={props.printError}
                    setSelectedImage={setSelectedImage}
                    selectedImage={selectedImage}
                />
            </Box>
        </Drawer >
    );
};