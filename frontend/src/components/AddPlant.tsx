import { Box, Button, Divider, Drawer, Switch, TextField } from "@mui/material";
import { AxiosInstance } from "axios";
import { botanicalInfo, plant } from "../interfaces";
import { useEffect, useState } from "react";
import dayjs, { Dayjs } from "dayjs";
import { LocalizationProvider, DatePicker } from "@mui/x-date-pickers";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import AddPhotoAlternateOutlinedIcon from '@mui/icons-material/AddPhotoAlternateOutlined';
import { Buffer } from "buffer";
import { create } from "domain";

export default function AddPlant(props: {
    requestor: AxiosInstance,
    open: boolean,
    setOpen: (arg: boolean) => void,
    entity?: botanicalInfo,
    plants: plant[],
    name?: string;
}) {
    const [plantName, setPlantName] = useState<string>();
    const [family, setFamily] = useState<string>();
    const [genus, setGenus] = useState<string>();
    const [species, setSpecies] = useState<string>();
    const [date, setDate] = useState<Dayjs | null>(dayjs(new Date()));
    const [useDate, setUseDate] = useState<boolean>(true);
    const [selectedImage, setSelectedImage] = useState<File>();
    const [downloadedImg, setDownloadedImg] = useState<string>();
    const [imageDownloaded, setImageDownloaded] = useState<boolean>(false);

    const readImage = (imageUrl: string): void => {
        props.requestor.get(`image/content${imageUrl}`)
            .then((res) => {
                setDownloadedImg(res.data);
                setImageDownloaded(true);
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
        return imageDownloaded ? `data:application/octet-stream;base64,${downloadedImg}` :
            setAbsoluteImageUrl(props.entity?.imageUrl, process.env.PUBLIC_URL);
    };

    let imgSrc = setImageSrc();

    const getName = (): void => {
        if (props.entity === undefined) {
            if (props.name === undefined) {
                setPlantName("");
            } else {
                setPlantName(props.name);
            }
            return;
        }
        if (props.entity.id === null) {
            setPlantName(props.entity.scientificName);
            return;
        }
        props.requestor.get(`/botanical-info/${props.entity.id}/_count`)
            .then((res) => {
                let incrementalName = props.entity!.scientificName;
                if (res.data > 0) {
                    incrementalName += ` ${res.data}`;
                }
                setPlantName(incrementalName);
            });
    };

    const addPlant = (): void => {
        if (props.entity != undefined) {
            addPlantOldBotanicalInfo();
        } else {
            addPlantNewBotanicalInfo();
        }
    };

    const addPlantOldBotanicalInfo = (): void => {
        addNewPlant({
            botanicalInfo: props.entity!,
            personalName: plantName!,
            type: "PLANT",
            state: "PURCHASED",
            startDate: date!,
        })
            .then((res) => {
                props.setOpen(false);
                props.plants.push(res);
                props.entity!.id = res.botanicalInfo.id;
                getName();
                cleanup();
            });
    };

    const addPlantNewBotanicalInfo = (): void => {
        let botanicalInfoToUse = {
            scientificName: plantName,
            family: family,
            genus: genus,
            species: species != undefined ? species : plantName,
            isSystemWide: false,
        };
        let plantToAdd = {
            botanicalInfo: botanicalInfoToUse,
            personalName: plantName,
            type: "PLANT",
            state: "PURCHASED",
            startDate: date,
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
                            props.plants.push(res);
                            console.log(res)
                            //props.entity!.id = res.botanicalInfo.id;
                            getName();
                            cleanup();
                        });
                } else {
                    props.setOpen(false);
                    props.plants.push(res);
                    //props.entity!.id = res.botanicalInfo.id;
                    getName();
                    cleanup();
                }
            });
    };

    const addNewPlant = (plant: {}): Promise<plant> => {
        return new Promise((accept, reject) => {
            props.requestor.post("plant", plant)
                .then((res) => { accept(res.data); })
                .catch((err) => reject(err));
        });
    };

    const cleanup = (): void => {
        setSelectedImage(undefined);
        setDownloadedImg(undefined);
        setFamily(undefined);
        setGenus(undefined);
        setPlantName("");
        setUseDate(true);
        setDate(dayjs(new Date()));
    };

    useEffect(() => {
        setImageDownloaded(false);
        setImageSrc();
        getName();
    }, [props.entity, props.name]);

    return (
        <Drawer
            anchor={"bottom"}
            open={props.open}
            onClose={() => props.setOpen(false)}
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
                    alignItems: "center",
                }}>
                    <Box sx={{
                        borderRadius: "50%",
                        height: "65px",
                        width: "65px",
                        overflow: "hidden",
                        position: "relative",
                    }}>
                        {
                            props.entity != undefined &&
                            <img
                                src={imgSrc}
                                style={{
                                    height: "100%",
                                    width: "100%",
                                    objectFit: "cover"
                                }}
                            />
                        }
                        {
                            selectedImage != undefined &&
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

                    </Box>
                    <TextField
                        variant="outlined"
                        label="Name"
                        required
                        sx={{ flexGrow: "1" }}
                        value={plantName}
                        onChange={(event) => setPlantName(event.target.value)}
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
                            onChange={(newValue) => setDate(newValue)}
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
                    value={props.entity?.family}
                    onChange={(event) => setFamily(event.target.value)}
                />
                <TextField
                    variant="outlined"
                    disabled={props.entity != undefined}
                    fullWidth
                    label="Genus"
                    value={props.entity?.genus}
                    onChange={(event) => setGenus(event.target.value)}
                />
                <TextField
                    variant="outlined"
                    disabled={props.entity != undefined}
                    fullWidth
                    label="Species"
                    value={props.entity?.species}
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