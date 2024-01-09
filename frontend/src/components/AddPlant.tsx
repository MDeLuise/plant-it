import { Box, Button, Drawer, Link, Skeleton, Switch, TextField, Typography } from "@mui/material";
import { AxiosInstance } from "axios";
import { botanicalInfo, plant } from "../interfaces";
import { useEffect, useState } from "react";
import dayjs, { Dayjs } from "dayjs";
import { LocalizationProvider, DatePicker } from "@mui/x-date-pickers";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import { formatHumidityRequirement, formatLightRequirement, formatPh, formatTemperatureRequirement, getPlantImg } from "../common";
import ArrowBackOutlinedIcon from '@mui/icons-material/ArrowBackOutlined';
import EditIcon from '@mui/icons-material/Edit';
import InsertOrUpload, { UploadedFile } from "./InsertOrUploadImg";
import CloseOutlinedIcon from '@mui/icons-material/CloseOutlined';
import DeleteOutlineOutlinedIcon from '@mui/icons-material/DeleteOutlineOutlined';
import SaveAsOutlinedIcon from '@mui/icons-material/SaveAsOutlined';
import ConfirmDeleteDialog from "./ConfirmDialog";
import { EditableTextField } from "./EditableTextField";

function AddPlantHeader(props: {
    requestor: AxiosInstance,
    imageUrl?: string,
    open: boolean,
    close: () => void,
    printError: (arg: any) => void,
    toggleEditMode: () => void;
}) {
    const [imageLoaded, setImageLoaded] = useState<boolean>(false);
    const [imgSrc, setImgSrc] = useState<string>();

    useEffect(() => {
        if (!props.open) {
            setImageLoaded(false);
            setImgSrc(undefined);
        }
    }, [props.open]);


    useEffect(() => {
        if (!props.open) {
            setImageLoaded(false);
            setImgSrc(undefined);
        } else {
            getPlantImg(props.requestor, props.imageUrl)
                .then(setImgSrc)
                .catch(props.printError);
        }
    }, [props.imageUrl]);

    return <Box height={"40vh"} id="add-plant-header" sx={{ transition: ".5s height", }}>
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
            {
                props.imageUrl !== undefined &&
                <EditIcon
                    sx={{
                        backdropFilter: "blur(10px)",
                        color: "white",
                        borderRadius: "50%",
                        padding: "5px",
                        backgroundColor: "rgba(32, 32, 32, .1)",
                    }}
                    fontSize="large"
                    onClick={props.toggleEditMode}
                />
            }
        </Box>
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
    </Box>;
}


function EditableThumbnail(props: {
    editable: boolean,
    text?: string,
    maxLength?: number,
    variant?: "body1" | "h6",
    style?: {};
    uploadAndSetCustomSpeciesImg: (arg: File) => void,
    setCustomSpeciesImg: (arg: string) => void,
}) {
    const [value, setValue] = useState<string>();
    const [dialogOpen, setDialogOpen] = useState<boolean>(false);

    useEffect(() => {
        setValue(props.text || "");
    }, [props.text]);


    const renderedText = (maxLength?: number, arg?: string) => {
        if (arg === undefined) {
            return arg;
        }
        if (maxLength !== undefined && arg.length > maxLength) {
            return arg.substring(0, maxLength) + "...";
        }
        return arg;
    };

    return props.editable ?
        <Box>
            {
                value &&
                <Typography display="inline">({renderedText(15, value)}) </Typography>
            }
            <Link onClick={() => setDialogOpen(true)}>edit</Link>
            <InsertOrUpload
                open={dialogOpen}
                onClose={() => setDialogOpen(false)}
                title="Edit species thumbnail"
                insert={props.setCustomSpeciesImg}
                uploadFile={(arg: UploadedFile[]) => props.uploadAndSetCustomSpeciesImg(arg[0].original)}
                maxFileCount={1}
            />
        </Box>
        :
        <Typography sx={{ ...props.style }} variant={props.variant}>
            {renderedText(props.maxLength, value)}
        </Typography>;
}


function AddPlantInfo(props: {
    requestor: AxiosInstance,
    botanicalInfoToAdd?: botanicalInfo,
    botanicalInfos: botanicalInfo[],
    searchedName?: string,
    plants: plant[],
    open: boolean,
    close: () => void,
    printError: (arg: any) => void,
    editModeEnabled: boolean,
    toggleEditMode: () => void,
    refreshBotanicalInfosAndPlants: () => void,
    setUpdatedImgUrl: (src: string) => void;
}) {
    const [plantName, setPlantName] = useState<string>("");
    const [updatedBotanicalInfo, setUpdatedBotanicalInfo] = useState<Partial<botanicalInfo>>();
    const [plantNameError, setPlantNameError] = useState<string>();
    const [note, setNote] = useState<string>("");
    const [date, setDate] = useState<Dayjs>(dayjs(new Date()));
    const [useDate, setUseDate] = useState<boolean>(true);
    const [updatedBotanicalInfoThumbnail, setUpdatedBotanicalInfoThumbnail] = useState<{
        url?: string,
        file?: File,
    }>({});
    const [confirmDialogStatus, setConfirmDialogStatus] = useState<{
        text: string,
        confirmCallBack: () => void,
        open: boolean;
    }>({
        text: "",
        confirmCallBack: () => { },
        open: false,
    });

    const setName = (): Promise<string> => {
        return new Promise((resolve, reject) => {
            if (props.botanicalInfoToAdd === undefined) {
                if (props.searchedName === undefined) {
                    setPlantName("");
                    return resolve("");
                } else {
                    setPlantName(props.searchedName);
                    return resolve(props.searchedName);
                }
            }
            if (props.botanicalInfoToAdd.id === null) {
                setPlantName(props.botanicalInfoToAdd.scientificName);
                return resolve(props.botanicalInfoToAdd.scientificName);
            }
            props.requestor.get(`botanical-info/${props.botanicalInfoToAdd.id}/_count`)
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
                .then(res => {
                    if (res.data) {
                        return resolve(false);
                    } else {
                        return resolve(true);
                    }
                })
                .catch(err => {
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
                if (props.botanicalInfoToAdd === undefined || props.botanicalInfoToAdd.id === null) {
                    const botanicalInfoToCreate = {
                        ...updatedBotanicalInfo,
                        creator: props.botanicalInfoToAdd === undefined ? "USER" : "TREFLE",
                        synonyms: updatedBotanicalInfo!.synonyms,
                        plantCareInfo: updatedBotanicalInfo?.plantCareInfo ? updatedBotanicalInfo.plantCareInfo : {},
                    } as botanicalInfo;
                    const thumbnail = updatedBotanicalInfoThumbnail.file || updatedBotanicalInfoThumbnail.url || updatedBotanicalInfo?.imageUrl;
                    addNewBotanicalInfo(botanicalInfoToCreate, thumbnail)
                        .then(addedBotanicalInfo => {
                            setUpdatedBotanicalInfo(addedBotanicalInfo);
                            const plantToCreate = {
                                botanicalInfoId: addedBotanicalInfo.id,
                                personalName: plantName!,
                                state: "ALIVE",
                                startDate: useDate ? date : null,
                                note: note,
                                avatarMode: "NONE",
                            };
                            addNewPlant(plantToCreate)
                                .then(_addedPlant => {
                                    props.close();
                                    props.refreshBotanicalInfosAndPlants();
                                })
                                .catch(props.printError);
                        })
                } else {
                    const plantToCreate = {
                        botanicalInfoId: props.botanicalInfoToAdd.id,
                        personalName: plantName!,
                        state: "ALIVE",
                        startDate: useDate ? date : null,
                        note: note,
                        avatarMode: "NONE",
                    }
                    addNewPlant(plantToCreate)
                        .then(_addedPlant => {
                            props.close();
                            props.refreshBotanicalInfosAndPlants();
                        })
                        .catch(props.printError);
                }
            })
            .catch(props.printError);
    };

    const addNewBotanicalInfo = (toAdd: botanicalInfo, image?: string | File): Promise<botanicalInfo> => {
        return new Promise<botanicalInfo>((accept, reject) => {
            props.requestor.post("botanical-info", toAdd)
                .then(newBotanicalInfoRes => {
                    if (image === undefined) {
                        accept(newBotanicalInfoRes.data)
                        return;
                    }
                    if (typeof (image) === "string") {
                        props.requestor.post(`image/botanical-info/${newBotanicalInfoRes.data.id}/url/`, {
                            url: image,
                        })
                            .then(imgRes => {
                                props.setUpdatedImgUrl(imgRes.data.url);
                                accept({
                                    ...newBotanicalInfoRes.data,
                                    imageId: imgRes.data.id,
                                    imageUrl: imgRes.data.url,
                                } as botanicalInfo);
                            })
                            .catch(reject);
                    } else {
                        let formData = new FormData();
                        formData.append('image', image);
                        props.requestor.post(`image/botanical-info/${newBotanicalInfoRes.data.id}`, formData)
                            .then(imgRes => {
                                props.setUpdatedImgUrl(imgRes.data.url);
                                accept({
                                    ...newBotanicalInfoRes.data,
                                    imageUrl: imgRes.data.url,
                                    imageId: imgRes.data.id,
                                })
                            })
                            .catch(reject)
                    }
                })
                .catch(reject);
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
                .catch(reject);
        });
    };

    const changePlantName = (name: string): void => {
        setPlantNameError(undefined);
        setPlantName(name);
    };

    const cleanup = (): void => {
        setUpdatedBotanicalInfo(undefined);
        setPlantName("");
        setUseDate(true);
        setDate(dayjs(new Date()));
        setPlantNameError(undefined);
    };

    const updateBotanicalInfo = (id: number, updated: {}, image?: string | File): Promise<botanicalInfo> => {
        return new Promise<botanicalInfo>((accept, reject) => {
            props.requestor.put(`botanical-info/${id}`, updated)
                .then(newBotanicalInfoRes => {
                    if (image === undefined) {
                        accept(newBotanicalInfoRes.data);
                        return;
                    }
                    if (typeof (image) === "string") {
                        props.requestor.post(`image/botanical-info/${newBotanicalInfoRes.data.id}/url/`, {
                            url: image,
                        })
                            .then(imgRes => {
                                props.setUpdatedImgUrl(imgRes.data.url);
                                accept({
                                    ...newBotanicalInfoRes.data,
                                    imageId: imgRes.data.id,
                                    imageUrl: imgRes.data.url,
                                } as botanicalInfo);
                            })
                            .catch(reject);
                    } else {
                        let formData = new FormData();
                        formData.append('image', image);
                        props.requestor.post(`image/botanical-info/${newBotanicalInfoRes.data.id}`, formData)
                            .then(imgRes => {
                                props.setUpdatedImgUrl(imgRes.data.url);
                                accept({
                                    ...newBotanicalInfoRes.data,
                                    imageUrl: imgRes.data.url,
                                    imageId: imgRes.data.id,
                                })
                            })
                            .catch(reject)
                    }
                })
                .catch(reject);
        });
    };

    const deleteBotanicalInfo = (id: number) => {
        props.requestor.delete(`botanical-info/${id}`)
            .then(_res => {
                props.close();
                props.toggleEditMode();
                props.refreshBotanicalInfosAndPlants();
            })
            .catch(props.printError);
    };

    const getNumberValueOrUndefined = (value: string | undefined): number | undefined => {
        return value ? Number(value) : undefined;
    }

    useEffect(() => {
        props.open && setName() || cleanup();
    }, [props.open]);


    useEffect(() => {
        if (props.botanicalInfoToAdd !== undefined) {
            setUpdatedBotanicalInfo(props.botanicalInfoToAdd);
        } else {
            setUpdatedBotanicalInfo({});
        }
    }, [props.botanicalInfoToAdd]);


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
            onChange={(e) => {
                if (e.target.files != undefined) {
                    setUpdatedBotanicalInfoThumbnail({
                        file: e.target.files[0]
                    });
                }
            }}
        />

        <ConfirmDeleteDialog
            open={confirmDialogStatus.open}
            close={() => setConfirmDialogStatus({ ...confirmDialogStatus, open: false })}
            printError={props.printError}
            confirmCallBack={() => {
                confirmDialogStatus.confirmCallBack();
                setConfirmDialogStatus({ ...confirmDialogStatus, open: false });
            }}
            text={confirmDialogStatus.text}
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
                    text={updatedBotanicalInfo?.family}
                    editable={props.botanicalInfoToAdd === undefined || props.editModeEnabled}
                    onChange={(newVal) => updatedBotanicalInfo!.family = newVal}
                />
            </Box>
            <Box className="plant-detail-entry" >
                <Typography>
                    Genus
                </Typography>
                <EditableTextField
                    text={updatedBotanicalInfo?.genus}
                    editable={props.botanicalInfoToAdd === undefined || props.editModeEnabled}
                    onChange={(newVal) => updatedBotanicalInfo!.genus = newVal}
                />
            </Box>
            <Box className="plant-detail-entry" >
                <Typography>
                    Species
                </Typography>
                <EditableTextField
                    text={updatedBotanicalInfo?.species}
                    editable={props.botanicalInfoToAdd === undefined || props.editModeEnabled}
                    onChange={(newVal) => updatedBotanicalInfo!.species = newVal}
                />
            </Box>

            <Box className="plant-detail-entry">
                <Typography>
                    Thumbnail
                </Typography>
                <EditableThumbnail
                    text={((): string | undefined => {
                        if (updatedBotanicalInfoThumbnail.file) {
                            return updatedBotanicalInfoThumbnail.file?.name;
                        } else if (updatedBotanicalInfoThumbnail.url) {
                            return updatedBotanicalInfoThumbnail.url
                        } else {
                            return updatedBotanicalInfo?.imageUrl;
                        }
                    })()}
                    maxLength={20}
                    editable={props.botanicalInfoToAdd === undefined || props.editModeEnabled}
                    uploadAndSetCustomSpeciesImg={(arg: File) => {
                        setUpdatedBotanicalInfoThumbnail({
                            file: arg
                        });
                    }}
                    setCustomSpeciesImg={(arg: string) => {
                        setUpdatedBotanicalInfoThumbnail({
                            url: arg
                        });
                    }} />
            </Box>
        </Box>

        {
            (props.editModeEnabled || !props.botanicalInfoToAdd || (updatedBotanicalInfo?.synonyms && updatedBotanicalInfo!.synonyms.length > 0)) &&
            <Box
                className="plant-detail-section">
                <Typography variant="h6">
                    Species info
                </Typography>
                <Box className="plant-detail-entry">
                    <Typography>
                        Synonyms
                    </Typography>
                    <EditableTextField
                        editable={props.editModeEnabled || !props.botanicalInfoToAdd}
                        text={updatedBotanicalInfo?.synonyms?.join("; ") || ""}
                        rows={updatedBotanicalInfo?.synonyms?.length}
                        onChange={(synonyms) => updatedBotanicalInfo!.synonyms = synonyms.split(";").map(syn => syn.trim())}
                        style={{ "max-width": "50%" }}
                    />
                </Box>
            </Box>
        }

        <Box
            className="plant-detail-section">
            <Typography variant="h6">
                Care info
            </Typography>

            {
                (props.editModeEnabled || !props.botanicalInfoToAdd || updatedBotanicalInfo?.plantCareInfo?.light) &&
                <Box className="plant-detail-entry">
                    <Typography>
                        Light
                    </Typography>
                    <EditableTextField
                        editable={props.editModeEnabled || !props.botanicalInfoToAdd}
                        text={formatLightRequirement(updatedBotanicalInfo?.plantCareInfo?.light, props.editModeEnabled)}
                        onChange={(newVal) => updatedBotanicalInfo!.plantCareInfo = { ...updatedBotanicalInfo!.plantCareInfo!, light: getNumberValueOrUndefined(newVal) }}
                    />
                </Box>
            }
            {
                (props.editModeEnabled || !props.botanicalInfoToAdd || updatedBotanicalInfo?.plantCareInfo?.humidity) &&
                <Box className="plant-detail-entry">
                    <Typography>
                        Soil humidity
                    </Typography>
                    <EditableTextField
                        editable={props.editModeEnabled || !props.botanicalInfoToAdd}
                        text={formatHumidityRequirement(updatedBotanicalInfo?.plantCareInfo?.humidity, props.editModeEnabled)}
                        onChange={(newVal) => updatedBotanicalInfo!.plantCareInfo = { ...updatedBotanicalInfo!.plantCareInfo!, humidity: getNumberValueOrUndefined(newVal) }}
                    />
                </Box>
            }
            {
                (props.editModeEnabled || !props.botanicalInfoToAdd || updatedBotanicalInfo?.plantCareInfo?.maxTemp) &&
                <Box className="plant-detail-entry">
                    <Typography>
                        Maximum temperature
                    </Typography>
                    <EditableTextField
                        editable={props.editModeEnabled || !props.botanicalInfoToAdd}
                        text={formatTemperatureRequirement(updatedBotanicalInfo?.plantCareInfo?.maxTemp, props.editModeEnabled)}
                        onChange={(newVal) => updatedBotanicalInfo!.plantCareInfo = { ...updatedBotanicalInfo!.plantCareInfo!, maxTemp: getNumberValueOrUndefined(newVal) }}
                    />
                </Box>
            }
            {
                (props.editModeEnabled || !props.botanicalInfoToAdd || updatedBotanicalInfo?.plantCareInfo?.minTemp) &&
                <Box className="plant-detail-entry">
                    <Typography>
                        Minimum temperature
                    </Typography>
                    <EditableTextField
                        editable={props.editModeEnabled || !props.botanicalInfoToAdd}
                        text={formatTemperatureRequirement(updatedBotanicalInfo?.plantCareInfo?.minTemp, props.editModeEnabled)}
                        onChange={(newVal) => updatedBotanicalInfo!.plantCareInfo = { ...updatedBotanicalInfo!.plantCareInfo!, minTemp: getNumberValueOrUndefined(newVal) }}
                    />
                </Box>
            }
            {
                (props.editModeEnabled || !props.botanicalInfoToAdd || updatedBotanicalInfo?.plantCareInfo?.phMax) &&
                <Box className="plant-detail-entry">
                    <Typography>
                        Maximum ph
                    </Typography>
                    <EditableTextField
                        editable={props.editModeEnabled || !props.botanicalInfoToAdd}
                        text={formatPh(updatedBotanicalInfo?.plantCareInfo?.phMax)}
                        onChange={(newVal) => updatedBotanicalInfo!.plantCareInfo = { ...updatedBotanicalInfo!.plantCareInfo!, phMax: getNumberValueOrUndefined(newVal) }}
                    />
                </Box>
            }
            {
                (props.editModeEnabled || !props.botanicalInfoToAdd || updatedBotanicalInfo?.plantCareInfo?.phMin) &&
                <Box className="plant-detail-entry">
                    <Typography>
                        Minimum ph
                    </Typography>
                    <EditableTextField
                        editable={props.editModeEnabled || !props.botanicalInfoToAdd}
                        text={formatPh(updatedBotanicalInfo?.plantCareInfo?.phMin)}
                        onChange={(newVal) => updatedBotanicalInfo!.plantCareInfo = { ...updatedBotanicalInfo!.plantCareInfo!, phMin: getNumberValueOrUndefined(newVal) }}
                    />
                </Box>
            }
        </Box>

        {
            props.editModeEnabled ||
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
        }

        <Box
            boxShadow={.5}
            sx={{
                position: "fixed",
                bottom: 0,
                left: 0,
                width: "100%",
                padding: "20px",
                backgroundColor: "white",
                borderRadius: "35px 35px 0 0",
                zIndex: 2,
                display: "flex",
                justifyContent: "space-around",
            }}>
            {
                !props.editModeEnabled ?
                    <Button
                        fullWidth
                        sx={{
                            backgroundColor: "primary.main",
                            color: "white",
                            padding: "15px 50px",
                            "&:hover": { backgroundColor: "primary.main" },
                        }}
                        onClick={addPlant}
                    >
                        Save plant
                    </Button>
                    :
                    <Box
                        sx={{
                            display: "flex",
                            justifyContent: "space-around",
                            width: "100%",
                            gap: "7px",
                        }}
                    >
                        <Button
                            sx={{
                                backgroundColor: "accent.secondary",
                                padding: "20px 0",
                                color: "white",
                                width: "20%",
                                "&:hover": { backgroundColor: "accent.secondary" },
                            }}
                            onClick={props.toggleEditMode}
                        >
                            <CloseOutlinedIcon fontSize="medium" />
                        </Button>
                        {
                            props.botanicalInfoToAdd?.creator === "USER" &&
                            <Button
                                sx={{
                                    width: "20%",
                                    backgroundColor: "error.main",
                                    padding: "20px 0",
                                    color: "white",
                                    "&:hover": { backgroundColor: "error.main" },
                                }}
                                onClick={() =>
                                    setConfirmDialogStatus({
                                        text: "Are you sure you want to delete the species and all the plant within it?" +
                                            " This action can not be undone.",
                                        confirmCallBack: () => deleteBotanicalInfo(props.botanicalInfoToAdd!.id),
                                        open: true
                                    })
                                }
                            >
                                <DeleteOutlineOutlinedIcon fontSize="medium" />
                            </Button>
                        }
                        <Button
                            sx={{
                                width: "70%",
                                backgroundColor: "primary.main",
                                padding: "20px 0",
                                color: "white",
                                "&:hover": { backgroundColor: "primary.main" },
                            }}
                            onClick={() => {
                                const thumbnail = updatedBotanicalInfoThumbnail.file || updatedBotanicalInfoThumbnail.url || updatedBotanicalInfo?.imageUrl;
                                if (props.botanicalInfoToAdd === undefined || props.botanicalInfoToAdd.id === null) {
                                    updatedBotanicalInfo!.creator = "USER";
                                    addNewBotanicalInfo(updatedBotanicalInfo as botanicalInfo, thumbnail)
                                        .then(updatedBIRes => {
                                            setUpdatedBotanicalInfo(updatedBIRes);
                                            props.refreshBotanicalInfosAndPlants();
                                            props.toggleEditMode();
                                        })
                                        .catch(props.printError);
                                } else {
                                    updateBotanicalInfo(props.botanicalInfoToAdd!.id!, updatedBotanicalInfo!, thumbnail)
                                        .then(updatedBIRes => {
                                            setUpdatedBotanicalInfo(updatedBIRes);
                                            props.refreshBotanicalInfosAndPlants();
                                            props.toggleEditMode();
                                        })
                                        .catch(props.printError);
                                }
                            }}
                        >
                            <SaveAsOutlinedIcon fontSize="medium" />
                        </Button>
                    </Box>
            }
        </Box>
    </Box>;
}


export default function AddPlant(props: {
    requestor: AxiosInstance,
    open: boolean,
    close: () => void,
    botanicalInfoToAdd?: botanicalInfo,
    botanicalInfos: botanicalInfo[],
    plants: plant[],
    name?: string,
    printError: (err: any) => void,
    refreshBotanicalInfosAndPlants: () => void;
}) {
    const [updatedImageUrl, setUpdatedImageUrl] = useState<string>();
    const [editModeEnabled, setEditModeEnabled] = useState<boolean>(false);

    useEffect(() => {
        setUpdatedImageUrl(undefined);
    }, [props.botanicalInfoToAdd])

    return (
        <Drawer
            anchor={"bottom"}
            open={props.open}
            onClose={props.close}
            SlideProps={{
                onScroll: (event: any) => {
                    let currentScroll = event.target.scrollTop;
                    if (currentScroll < 50) {
                        document.getElementById("add-plant-header")!.style.height = "40vh";
                    } else {
                        document.getElementById("add-plant-header")!.style.height = "20vh";
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
                    close={() => {
                        props.close();
                        setEditModeEnabled(false);
                    }}
                    imageUrl={updatedImageUrl || props.botanicalInfoToAdd?.imageUrl}
                    printError={props.printError}
                    toggleEditMode={() => {
                        let currentEditModeEnabled = editModeEnabled;
                        setEditModeEnabled(!editModeEnabled);
                        if (!currentEditModeEnabled) {
                            document.getElementById("add-plant-header")!.style.height = "20vh";
                        } else {
                            document.getElementById("add-plant-header")!.style.height = "40vh";
                        }
                    }}
                />
                <AddPlantInfo
                    requestor={props.requestor}
                    plants={props.plants}
                    open={props.open}
                    close={props.close}
                    botanicalInfoToAdd={props.botanicalInfoToAdd}
                    botanicalInfos={props.botanicalInfos}
                    printError={props.printError}
                    searchedName={props.name}
                    editModeEnabled={editModeEnabled}
                    toggleEditMode={() => {
                        let currentEditModeEnabled = editModeEnabled;
                        setEditModeEnabled(!editModeEnabled);
                        if (!currentEditModeEnabled) {
                            document.getElementById("add-plant-header")!.style.height = "20vh";
                        } else {
                            document.getElementById("add-plant-header")!.style.height = "40vh";
                        }
                    }}
                    refreshBotanicalInfosAndPlants={props.refreshBotanicalInfosAndPlants}
                    setUpdatedImgUrl={setUpdatedImageUrl}
                />
            </Box>
        </Drawer>
    );
};