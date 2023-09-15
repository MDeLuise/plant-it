import { Box, Button, Divider, Drawer, Skeleton, Switch, TextField } from "@mui/material";
import { AxiosInstance } from "axios";
import { botanicalInfo, plant } from "../interfaces";
import { useEffect, useState } from "react";
import dayjs, { Dayjs } from "dayjs";
import { LocalizationProvider, DatePicker } from "@mui/x-date-pickers";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import AddPhotoAlternateOutlinedIcon from '@mui/icons-material/AddPhotoAlternateOutlined';
import { getBotanicalInfoImg, imgToBase64 } from "../common";

export default function AddPlant(props: {
    requestor: AxiosInstance,
    open: boolean,
    setOpen: (arg: boolean) => void,
    entity?: botanicalInfo,
    plants: plant[],
    name?: string,
    printError: (err: any) => void;
}) {
    const [plantName, setPlantName] = useState<string>("");
    const [plantNameError, setPlantNameError] = useState<string>();
    const [family, setFamily] = useState<string>("");
    const [genus, setGenus] = useState<string>("");
    const [species, setSpecies] = useState<string>("");
    const [date, setDate] = useState<Dayjs>(dayjs(new Date()));
    const [useDate, setUseDate] = useState<boolean>(true);
    const [selectedImage, setSelectedImage] = useState<File>();
    const [downloadedImg, setDownloadedImg] = useState<string>();
    const [imageDownloaded, setImageDownloaded] = useState<boolean>(false);
    const [imageLoaded, setImageLoaded] = useState<boolean>(false);

    const readImage = (imageUrl: string): void => {
        props.requestor.get(`image/content${imageUrl}`)
            .then((res) => {
                setDownloadedImg(res.data);
                setImageDownloaded(true);
            })
            .catch((err) => {
                getBotanicalInfoImg(props.requestor, undefined)
                    .then((res) => {
                        console.error(err);
                        imgToBase64(res, (arg: string) => {
                            setDownloadedImg(arg);
                        });
                        setImageDownloaded(true);
                    })
                    .catch((err) => {
                        console.error(err);
                        props.printError(`Cannot load image with id ${props.entity?.imageId}`);
                    });
            });
    };

    const setAbsoluteImageUrl = (imageUrl: string | undefined, publicUrl: string): string => {
        if (imageUrl == undefined) {
            return publicUrl + "botanical-info-no-img.png";
        }
        if (imageUrl.startsWith("/")) {
            readImage(imageUrl);
        }
        return imageUrl;
    };

    const setImageSrc = (): string => {
        if (!props.open) {
            return "";
        }
        return imageDownloaded ? `data:application/octet-stream;base64,${downloadedImg}` :
            setAbsoluteImageUrl(props.entity?.imageUrl, process.env.PUBLIC_URL);
    };

    let imgSrc = setImageSrc();

    const setName = (): Promise<string> => {
        return new Promise((resolve, reject) => {
            if (props.entity === undefined) {
                if (props.name === undefined) {
                    setPlantName("");
                    return resolve("");
                } else {
                    setPlantName(props.name);
                    return resolve(props.name);
                }
            }
            if (props.entity.id === null) {
                setPlantName(props.entity.scientificName);
                return resolve(props.entity.scientificName);
            }
            props.requestor.get(`/botanical-info/${props.entity.id}/_count`)
                .then((res) => {
                    let incrementalName = props.entity!.scientificName;
                    if (res.data > 0) {
                        incrementalName += ` ${res.data}`;
                    }
                    setPlantName(incrementalName);
                    return resolve(incrementalName);
                })
                .catch((err) => {
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
            .then((res) => {
                if (!res) {
                    setPlantNameError("Duplicated plant name");
                    return;
                }
                if (props.entity != undefined) {
                    addPlantOldBotanicalInfo();
                } else {
                    addPlantNewBotanicalInfo();
                }
            })
            .catch((err) => {
                props.printError(err);
            });
    };

    const addPlantOldBotanicalInfo = (): void => {
        addNewPlant({
            botanicalInfo: props.entity!,
            personalName: plantName!,
            state: "ALIVE",
            startDate: useDate ? date : null,
        })
            .then((res) => {
                props.setOpen(false);
                let insertHere = props.plants.findIndex((pl) => {
                    return pl.personalName.toLowerCase() > res.personalName.toLowerCase();
                });
                insertHere = insertHere === -1 ? props.plants.length : insertHere;
                props.plants.splice(insertHere, 0, res);
                props.entity!.id = res.botanicalInfo.id;
                setName();
                cleanup();
            })
            .catch((err) => {
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
        };
        addNewPlant(plantToAdd)
            .then((res) => {
                if (selectedImage != undefined) {
                    let formData = new FormData();
                    formData.append('image', selectedImage!);
                    props.requestor.post(`/image/botanical-info/${res.botanicalInfo.id}`, formData)
                        .then((imgRes) => {
                            props.setOpen(false);
                            res.botanicalInfo.imageUrl = "/" + imgRes.data.id;
                            let insertHere = props.plants.findIndex((pl) => {
                                return pl.personalName.toLowerCase() > res.personalName.toLowerCase();
                            });
                            insertHere = insertHere === -1 ? props.plants.length : insertHere;
                            props.plants.splice(insertHere, 0, res);
                            setName();
                            cleanup();
                        })
                        .catch((err) => {
                            props.printError(err);
                        });
                } else {
                    props.setOpen(false);
                    let insertHere = props.plants.findIndex((pl) => {
                        return pl.personalName.toLowerCase() > res.personalName.toLowerCase();
                    });
                    insertHere = insertHere === -1 ? props.plants.length : insertHere;
                    props.plants.splice(insertHere, 0, res);
                    setName();
                    cleanup();
                }
            })
            .catch((err) => {
                props.printError(err);
            });
    };

    const addNewPlant = (plant: {}): Promise<plant> => {
        return new Promise((accept, reject) => {
            props.requestor.post("plant", plant)
                .then((res) => {
                    if (res.status == 200) {
                        accept(res.data);
                    } else {
                        reject(res.data);
                    }
                })
                .catch((err) => reject(err));
        });
    };

    const cleanup = (): void => {
        setImageLoaded(false);
        setSelectedImage(undefined);
        setDownloadedImg(undefined);
        setImageDownloaded(false);
        setFamily("");
        setGenus("");
        setPlantName("");
        setUseDate(true);
        setDate(dayjs(new Date()));
        setPlantNameError(undefined);
    };

    const changePlantName = (name: string): void => {
        setPlantNameError(undefined);
        setPlantName(name);
    };

    useEffect(() => {
        setImageDownloaded(false);
        props.open && setImageSrc();
        setName();
    }, [props.entity, props.name, props.open]);

    useEffect(() => {
        setFamily(props.entity?.family != undefined ? props.entity?.family : "");
        setGenus(props.entity?.genus != undefined ? props.entity?.genus : "");
        setSpecies(props.entity?.species != undefined ? props.entity?.species : "");
    }, [props.entity]);

    return (
        <Drawer
            anchor={"bottom"}
            open={props.open}
            onClose={() => {
                cleanup();
                props.setOpen(false);
            }}
            PaperProps={{
                style: { borderRadius: "15px 15px 0 0" }
            }}
        >
            <input
                id="upload-image"
                type="file"
                accept="image/*"
                hidden
                onChange={(event) => {
                    if (event.target.files != undefined) {
                        setSelectedImage(event.target.files[0]);
                    }
                }}
            />
            <Box
                sx={{
                    height: "90vh",
                    display: "flex",
                    flexDirection: "column",
                    padding: "35px",
                    gap: "30px",
                }}>
                <Box sx={{
                    display: "flex",
                    justifyContent: "space-between",
                    gap: "30px",
                    alignItems: "flex-start",
                }}>
                    <Box sx={{
                        borderRadius: "50%",
                        height: "65px",
                        width: "65px",
                        overflow: "hidden",
                        position: "relative",
                    }}>
                        {
                            !imageLoaded && props.entity !== undefined &&
                            <Skeleton
                                variant="rounded"
                                animation="wave"
                                sx={{
                                    width: "100%",
                                    height: "100%",
                                }}
                            />
                        }
                        {
                            props.entity != undefined && props.open &&
                            <img
                                src={imgSrc}
                                style={{
                                    height: "100%",
                                    width: "100%",
                                    objectFit: "cover"
                                }}
                                onLoad={() => setImageLoaded(true)}
                            />
                        }
                        {
                            selectedImage != undefined && props.open &&
                            <>
                                <Box
                                    style={{
                                        height: "100%",
                                        width: "100%",
                                    }}
                                    onClick={() => {
                                        document.getElementById("upload-image")?.click();
                                    }}>
                                    <img
                                        src={URL.createObjectURL(selectedImage)}
                                        style={{
                                            height: "100%",
                                            width: "100%",
                                            objectFit: "cover",
                                            position: "relative",
                                        }}
                                    />
                                </Box>
                            </>
                        }
                        {
                            props.entity == undefined &&
                            <Box sx={{
                                backgroundColor: "primary.main",
                                width: "100%",
                                height: "100%",
                                justifyContent: "center",
                                alignItems: "center",
                                display: selectedImage == undefined ? "flex" : "none",
                            }}
                                onClick={() => {
                                    document.getElementById("upload-image")?.click();
                                }}>
                                <AddPhotoAlternateOutlinedIcon fontSize="large" />
                            </Box>
                        }

                    </Box>
                    <TextField
                        variant="outlined"
                        label="Name"
                        required
                        sx={{ width: "calc(100% - 95px)", maxWidth: "initial", }}
                        value={plantName}
                        onChange={(event) => changePlantName(event.target.value as string)}
                        error={plantNameError != undefined}
                        helperText={plantNameError}
                    />
                </Box>
                <Box sx={{
                    display: "flex",
                    justifyContent: "space-between",
                    gap: "30px",
                    alignItems: "center",
                }}>
                    <Switch
                        checked={useDate}
                        onChange={(event) => setUseDate(event.target.checked)}
                    />
                    <LocalizationProvider dateAdapter={AdapterDayjs}>
                        <DatePicker
                            label="Date of purchase"
                            value={date}
                            disabled={!useDate}
                            onChange={(newValue) => setDate(newValue != undefined ? newValue : dayjs(new Date()))}
                            sx={{
                                flexGrow: 1
                            }}
                        />
                    </LocalizationProvider>
                </Box>
                <Divider>Scientific classification</Divider>
                <TextField
                    variant="outlined"
                    disabled={props.entity != undefined}
                    label="Family"
                    fullWidth
                    value={family}
                    onChange={(event) => setFamily(event.target.value)}
                />
                <TextField
                    variant="outlined"
                    disabled={props.entity != undefined}
                    fullWidth
                    label="Genus"
                    value={genus}
                    onChange={(event) => setGenus(event.target.value)}
                />
                <TextField
                    variant="outlined"
                    disabled={props.entity != undefined}
                    fullWidth
                    label="Species"
                    value={species}
                    onChange={(event) => setSpecies(event.target.value)}
                />

                <Box sx={{ flexGrow: "1" }}></Box>
                <Button
                    variant="contained"
                    sx={{
                        m: "10px",
                        borderRadius: "10px",
                        padding: "15px",
                    }}
                    onClick={addPlant}
                >
                    Save plant
                </Button>
            </Box>
        </Drawer>
    );
}