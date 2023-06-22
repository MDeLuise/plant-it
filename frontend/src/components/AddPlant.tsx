import { Box, Button, Drawer, Switch, TextField } from "@mui/material";
import { AxiosInstance } from "axios";
import { botanicalInfo, trackedEntity } from "../interfaces";
import { useEffect, useState } from "react";
import dayjs, { Dayjs } from "dayjs";
import { LocalizationProvider, DatePicker } from "@mui/x-date-pickers";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import AddPhotoAlternateOutlinedIcon from '@mui/icons-material/AddPhotoAlternateOutlined';
import { Buffer } from "buffer";

export default function AddPlant(props: {
    requestor: AxiosInstance,
    open: boolean,
    setOpen: (arg: boolean) => void,
    entity?: botanicalInfo,
    trackedEntities: trackedEntity[];
}) {
    const [plantName, setPlantName] = useState<string>("");
    const [family, setFamily] = useState<string>();
    const [genus, setGenus] = useState<string>();
    const [species, setSpecies] = useState<string>();
    const [date, setDate] = useState<Dayjs | null>(dayjs(new Date()));
    const [useDate, setUseDate] = useState<boolean>(true);
    const [selectedImage, setSelectedImage] = useState<File>();
    const [downloadedImg, setDownloadedImg] = useState<string>();
    let imgSrc = props.entity == undefined ? "" : props.entity.imageUrl != undefined ?
        props.entity.imageUrl :
        `data:image/png;base64,${downloadedImg}`;

    const readImage = (): void => {
        props.requestor.get(`image/botanical-info/${props.entity!.imageId}`)
            .then((res) => {
                setDownloadedImg(Buffer.from(res.data.content, "utf-8").toString());
            });
    };

    const getName = (): void => {
        if (props.entity === undefined) {
            setPlantName("");
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
        props.requestor.post("/tracked-entity/plant", {
            botanicalInfo: props.entity,
            personalName: plantName,
            type: "PLANT",
            state: "PURCHASED",
            startDate: date,
        })
            .then((res) => {
                props.setOpen(false);
                props.trackedEntities.push(res.data);
                props.entity!.id = res.data.botanicalInfo.id;
                getName();
                cleanup();
            });
    };

    const addPlantNewBotanicalInfo = (): void => {
        let formData = new FormData();
        formData.append('image', selectedImage!);
        props.requestor.post("/image", formData)
            .then((res) => {
                let botanicalInfoToUse = {
                    scientificName: species != undefined ? species : genus,
                    family: family,
                    genus: genus,
                    species: species,
                    isSystemWide: false,
                    imageId: res.data,
                };
                props.requestor.post("/tracked-entity/plant", {
                    botanicalInfo: botanicalInfoToUse,
                    personalName: plantName,
                    type: "PLANT",
                    state: "PURCHASED",
                    startDate: date,
                })
                    .then((res) => {
                        props.setOpen(false);
                        props.trackedEntities.push(res.data);
                        getName();
                        cleanup();
                    });
            });
    };

    const cleanup = (): void => {
        setSelectedImage(undefined);
        setDownloadedImg(undefined);
        setFamily(undefined);
        setGenus(undefined);
        setPlantName("");
        setUseDate(true);
    };

    useEffect(() => {
        if (props.entity != undefined && props.entity.imageUrl == undefined) {
            readImage();
        }
        getName();
    }, [props.entity]);

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
                <TextField
                    variant="outlined"
                    disabled={props.entity != undefined}
                    label="Family"
                    fullWidth
                    required
                    value={props.entity?.family}
                    onChange={(event) => setFamily(event.target.value)}
                />
                <TextField
                    variant="outlined"
                    disabled={props.entity != undefined}
                    fullWidth
                    required
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