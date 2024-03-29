import { Box, Button, Drawer, Link, MenuItem, Select, Skeleton, Switch, Tab, Tabs, TextField, Typography, useTheme } from "@mui/material";
import { AxiosInstance } from "axios";
import { botanicalInfo, plant, plantInfo } from "../interfaces";
import { useEffect, useState } from "react";
import dayjs, { Dayjs } from "dayjs";
import { LocalizationProvider, DatePicker } from "@mui/x-date-pickers";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import { formatHumidityRequirement, formatLightRequirement, formatPh, formatTemperatureRequirement, getAllCurrencySymbols, getPlantImg } from "../common";
import ArrowBackOutlinedIcon from '@mui/icons-material/ArrowBackOutlined';
import EditIcon from '@mui/icons-material/Edit';
import InsertOrUpload, { UploadedFile } from "./InsertOrUploadImg";
import CloseOutlinedIcon from '@mui/icons-material/CloseOutlined';
import DeleteOutlineOutlinedIcon from '@mui/icons-material/DeleteOutlineOutlined';
import SaveAsOutlinedIcon from '@mui/icons-material/SaveAsOutlined';
import ConfirmDeleteDialog from "./ConfirmDialog";
import { EditableTextField } from "./EditableTextField";
import { ReadMoreReadLess } from "./ReadMoreReadLess";
import { HelpTooltip } from "./HelpTooltip";

interface TabPanelProps {
    children?: React.ReactNode;
    dir?: string;
    index: number;
    value: number;
    padding?: number;
}

function TabPanel(props: TabPanelProps) {
    const { children, value, index, ...other } = props;

    return (
        <div
            role="tabpanel"
            hidden={value !== index}
            id={`full-width-tabpanel-${index}`}
            aria-labelledby={`full-width-tab-${index}`}
            {...other}
        >
            {value === index && (
                <Box sx={{ p: 0 }}>
                    <Typography>{children}</Typography>
                </Box>
            )}
        </div>
    );
}

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
                .catch(err => {
                    props.printError(err);
                    getPlantImg(props.requestor, undefined)
                        .then(res => {
                            setImageLoaded(true);
                            setImgSrc(res);
                        });
                });
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


function SpecieInfoDetails(props: {
    editModeEnabled: boolean,
    botanicalInfoToAdd?: botanicalInfo,
    updatedBotanicalInfo?: Partial<botanicalInfo>,
    updatedBotanicalInfoThumbnail: {
        url?: string,
        file?: File,
    },
    setUpdatedBotanicalInfoThumbnail: (arg: {
        url?: string,
        file?: File,
    }) => void;
}) {
    const getNumberValueOrUndefined = (value: string | undefined): number | undefined => {
        return value ? Number(value) : undefined;
    };

    return <Box>
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
                    text={props.updatedBotanicalInfo?.family}
                    editable={props.botanicalInfoToAdd === undefined || props.editModeEnabled}
                    onChange={(newVal) => props.updatedBotanicalInfo!.family = newVal}
                />
            </Box>
            <Box className="plant-detail-entry" >
                <Typography>
                    Genus
                </Typography>
                <EditableTextField
                    text={props.updatedBotanicalInfo?.genus}
                    editable={props.botanicalInfoToAdd === undefined || props.editModeEnabled}
                    onChange={(newVal) => props.updatedBotanicalInfo!.genus = newVal}
                />
            </Box>
            <Box className="plant-detail-entry" >
                <Typography>
                    Species
                </Typography>
                <EditableTextField
                    text={props.updatedBotanicalInfo?.species}
                    editable={props.botanicalInfoToAdd === undefined || props.editModeEnabled}
                    onChange={(newVal) => props.updatedBotanicalInfo!.species = newVal}
                />
            </Box>

            <Box className="plant-detail-entry">
                <Typography>
                    Thumbnail
                </Typography>
                <EditableThumbnail
                    text={((): string | undefined => {
                        if (props.updatedBotanicalInfoThumbnail.file) {
                            return props.updatedBotanicalInfoThumbnail.file?.name;
                        } else if (props.updatedBotanicalInfoThumbnail.url) {
                            return props.updatedBotanicalInfoThumbnail.url
                        } else {
                            return props.updatedBotanicalInfo?.imageUrl;
                        }
                    })()}
                    maxLength={20}
                    editable={props.botanicalInfoToAdd === undefined || props.editModeEnabled}
                    uploadAndSetCustomSpeciesImg={(arg: File) => {
                        props.setUpdatedBotanicalInfoThumbnail({
                            file: arg
                        });
                    }}
                    setCustomSpeciesImg={(arg: string) => {
                        props.setUpdatedBotanicalInfoThumbnail({
                            url: arg
                        });
                    }} />
            </Box>
        </Box>

        {
            (props.editModeEnabled || !props.botanicalInfoToAdd || props.updatedBotanicalInfo?.synonyms) &&
            <Box
                className="plant-detail-section">
                <Typography variant="h6">
                    Species info
                </Typography>
                <Box className="plant-detail-entry" sx={{ flexDirection: "column" }}>
                    <Box sx={{ display: "flex", width: "100%", justifyContent: "space-between", alignItems: "center" }}>
                        <Typography>
                            Synonyms
                        </Typography>
                        <HelpTooltip text="Semi-colon separated list of values" />
                    </Box>
                    {
                        (props.editModeEnabled || !props.botanicalInfoToAdd) &&
                        <TextField
                            fullWidth
                            multiline
                            defaultValue={props.updatedBotanicalInfo?.synonyms?.join("; ") || ""}
                            rows={4}
                            onChange={ev => props.updatedBotanicalInfo!.synonyms = ev.target.value.split(";").map(syn => syn.trim())}
                        />
                        ||
                        <ReadMoreReadLess
                            text={props.updatedBotanicalInfo?.synonyms?.join("; ") || ""}
                            size={50}
                        />
                    }
                </Box>
            </Box>
        }

        <Box
            className="plant-detail-section">
            <Typography variant="h6">
                Care info
            </Typography>
            {
                (!props.editModeEnabled && props.botanicalInfoToAdd?.plantCareInfo.allNull) &&
                <Typography sx={{ fontStyle: 'italic' }}>not provided</Typography>
            }
            {
                (props.editModeEnabled || !props.botanicalInfoToAdd || props.updatedBotanicalInfo?.plantCareInfo?.light) &&
                <Box className="plant-detail-entry">
                    <Typography>
                        Light
                    </Typography>
                    <EditableTextField
                        editable={props.editModeEnabled || !props.botanicalInfoToAdd}
                        text={formatLightRequirement(props.updatedBotanicalInfo?.plantCareInfo?.light, props.editModeEnabled)}
                        onChange={newVal => props.updatedBotanicalInfo!.plantCareInfo = { ...props.updatedBotanicalInfo!.plantCareInfo!, light: getNumberValueOrUndefined(newVal) }}
                    />
                </Box>
            }
            {
                (props.editModeEnabled || !props.botanicalInfoToAdd || props.updatedBotanicalInfo?.plantCareInfo?.humidity) &&
                <Box className="plant-detail-entry">
                    <Typography>
                        Soil humidity
                    </Typography>
                    <EditableTextField
                        editable={props.editModeEnabled || !props.botanicalInfoToAdd}
                        text={formatHumidityRequirement(props.updatedBotanicalInfo?.plantCareInfo?.humidity, props.editModeEnabled)}
                        onChange={newVal => props.updatedBotanicalInfo!.plantCareInfo = { ...props.updatedBotanicalInfo!.plantCareInfo!, humidity: getNumberValueOrUndefined(newVal) }}
                    />
                </Box>
            }
            {
                (props.editModeEnabled || !props.botanicalInfoToAdd || props.updatedBotanicalInfo?.plantCareInfo?.maxTemp) &&
                <Box className="plant-detail-entry">
                    <Typography>
                        Maximum temperature
                    </Typography>
                    <EditableTextField
                        editable={props.editModeEnabled || !props.botanicalInfoToAdd}
                        text={formatTemperatureRequirement(props.updatedBotanicalInfo?.plantCareInfo?.maxTemp, props.editModeEnabled)}
                        onChange={newVal => props.updatedBotanicalInfo!.plantCareInfo = { ...props.updatedBotanicalInfo!.plantCareInfo!, maxTemp: getNumberValueOrUndefined(newVal) }}
                    />
                </Box>
            }
            {
                (props.editModeEnabled || !props.botanicalInfoToAdd || props.updatedBotanicalInfo?.plantCareInfo?.minTemp) &&
                <Box className="plant-detail-entry">
                    <Typography>
                        Minimum temperature
                    </Typography>
                    <EditableTextField
                        editable={props.editModeEnabled || !props.botanicalInfoToAdd}
                        text={formatTemperatureRequirement(props.updatedBotanicalInfo?.plantCareInfo?.minTemp, props.editModeEnabled)}
                        onChange={newVal => props.updatedBotanicalInfo!.plantCareInfo = { ...props.updatedBotanicalInfo!.plantCareInfo!, minTemp: getNumberValueOrUndefined(newVal) }}
                    />
                </Box>
            }
            {
                (props.editModeEnabled || !props.botanicalInfoToAdd || props.updatedBotanicalInfo?.plantCareInfo?.phMax) &&
                <Box className="plant-detail-entry">
                    <Typography>
                        Maximum ph
                    </Typography>
                    <EditableTextField
                        editable={props.editModeEnabled || !props.botanicalInfoToAdd}
                        text={formatPh(props.updatedBotanicalInfo?.plantCareInfo?.phMax)}
                        onChange={newVal => props.updatedBotanicalInfo!.plantCareInfo = { ...props.updatedBotanicalInfo!.plantCareInfo!, phMax: getNumberValueOrUndefined(newVal) }}
                    />
                </Box>
            }
            {
                (props.editModeEnabled || !props.botanicalInfoToAdd || props.updatedBotanicalInfo?.plantCareInfo?.phMin) &&
                <Box className="plant-detail-entry">
                    <Typography>
                        Minimum ph
                    </Typography>
                    <EditableTextField
                        editable={props.editModeEnabled || !props.botanicalInfoToAdd}
                        text={formatPh(props.updatedBotanicalInfo?.plantCareInfo?.phMin)}
                        onChange={newVal => props.updatedBotanicalInfo!.plantCareInfo = { ...props.updatedBotanicalInfo!.plantCareInfo!, phMin: getNumberValueOrUndefined(newVal) }}
                    />
                </Box>
            }
        </Box>
    </Box>
}


function PlantInfoDetails(props: {
    entity: Partial<plant>,
    setEntity: (arg: Partial<plant>) => void,
    plantNameError?: string;
}) {
    const [startDate, setStartDate] = useState<Date>(new Date());
    const [useStartDate, setUseStartDate] = useState<boolean>(true);

    useEffect(() => {
        if (props.entity.info?.startDate) {
            setStartDate(props.entity.info?.startDate);
            setUseStartDate(true);
        } else if (props.entity.info && !props.entity.info.startDate) {
            setStartDate(new Date());
            setUseStartDate(false);
        } else {
            setStartDate(new Date());
            setUseStartDate(true);
        }
    }, [props.entity]);

    return <Box>
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
                    value={props.entity.info?.personalName}
                    onChange={e => props.setEntity({ ...props.entity, info: { ...props.entity.info!, personalName: e.currentTarget.value } })}
                    helperText={props.plantNameError}
                />
            </Box>
            <Box className="plant-detail-entry" >
                <Typography>
                    Purchased date
                </Typography>
                <Switch
                    checked={props.entity.info?.startDate != undefined}
                    onChange={event => props.setEntity({
                        ...props.entity,
                        info: {
                            ...props.entity.info!,
                            startDate: event.target.checked ? startDate : undefined
                        }
                    })}
                />
            </Box>
            <Box className="plant-detail-entry" >
                <Typography>
                    Purchased on
                </Typography>
                <LocalizationProvider dateAdapter={AdapterDayjs}>
                    <DatePicker
                        value={dayjs(props.entity.info!.startDate)}
                        disabled={!useStartDate}
                        onChange={newValue => {
                            if (!newValue) {
                                return;
                            }
                            setStartDate(newValue.toDate());
                            props.setEntity({
                                ...props.entity,
                                info: {
                                    ...props.entity.info!,
                                    startDate: newValue.toDate()
                                }
                            });
                        }
                        }
                        slotProps={{ textField: { variant: 'standard', } }}
                        format="DD/MM/YYYY"
                    />
                </LocalizationProvider>
            </Box>
            <Box className="plant-detail-entry">
                <Typography>
                    Purchased price
                </Typography>
                <Box sx={{ display: "flex", gap: "5px", justifyContent: "end" }}>
                    <TextField
                        variant="standard"
                        InputProps={{ disableUnderline: false }}
                        onChange={e => {
                            props.setEntity({
                                ...props.entity,
                                info: {
                                    ...props.entity.info!,
                                    purchasedPrice: Number(e.target.value)
                                }
                            });
                        }}
                        value={props.entity.info?.purchasedPrice}
                        sx={{
                            color: "black",
                            width: "40%",
                        }}
                        type="number"
                    />
                    <Select
                        defaultValue={props.entity.info?.currencySymbol || ""}
                        variant="standard"
                        onChange={e => {
                            props.setEntity({
                                ...props.entity!,
                                info: {
                                    ...props.entity.info!,
                                    currencySymbol: e.target.value as (string | undefined)
                                }
                            });
                        }}
                    >
                        {
                            getAllCurrencySymbols().map(symbol => {
                                return <MenuItem value={symbol}>{symbol}</MenuItem>
                            })
                        }
                    </Select>
                </Box>
            </Box>
            <Box className="plant-detail-entry">
                <Typography>
                    Seller
                </Typography>
                <TextField
                    variant="standard"
                    InputProps={{ disableUnderline: false }}
                    value={props.entity.info?.seller || ""}
                    onChange={e => props.setEntity({
                        ...props.entity,
                        info: {
                            ...props.entity.info!,
                            seller: e.currentTarget.value
                        }
                    })}
                />
            </Box>
            <Box className="plant-detail-entry">
                <Typography>
                    Location
                </Typography>
                <TextField
                    variant="standard"
                    InputProps={{ disableUnderline: false }}
                    value={props.entity.info?.location || ""}
                    onChange={e => props.setEntity({
                        ...props.entity,
                        info: {
                            ...props.entity.info!, location: e.currentTarget.value
                        }
                    })}
                />
            </Box>
            <Box style={{ display: "flex", flexDirection: "column", alignItems: "baseline", gap: "5px", justifyContent: "space-between", }}>
                <Typography>
                    Note
                </Typography>
                <TextField
                    fullWidth
                    multiline
                    value={props.entity.info?.note}
                    rows={4}
                    onChange={e => props.setEntity({
                        ...props.entity,
                        info: {
                            ...props.entity.info!,
                            note: e.currentTarget.value
                        }
                    })}
                >
                </TextField>
            </Box>
        </Box>
    </Box>
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
    setUpdatedImgUrl: (src: string) => void,
    entity: Partial<plant>,
    setEntity: (arg: Partial<plant>) => void,
}) {
    const [updatedBotanicalInfo, setUpdatedBotanicalInfo] = useState<Partial<botanicalInfo>>();
    const [plantNameError, setPlantNameError] = useState<string>();
    const [useDate, setUseDate] = useState<boolean>(true);
    const [tabValue, setTabValue] = useState<0 | 1>(0);
    const theme = useTheme();
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
                    props.setEntity({ ...props.entity, info: { ...props.entity.info!, personalName: "" } });
                    return resolve("");
                } else {
                    props.setEntity({ ...props.entity, info: { ...props.entity.info!, personalName: props.searchedName } });
                    return resolve(props.searchedName);
                }
            }
            if (props.botanicalInfoToAdd.id === null) {
                props.setEntity({ ...props.entity, info: { ...props.entity.info!, personalName: props.botanicalInfoToAdd.scientificName } });
                return resolve(props.botanicalInfoToAdd.scientificName);
            }
            props.requestor.get(`botanical-info/${props.botanicalInfoToAdd.id}/_count`)
                .then(res => {
                    let incrementalName = props.botanicalInfoToAdd!.scientificName;
                    if (res.data > 0) {
                        incrementalName += ` ${res.data}`;
                    }
                    props.setEntity({ ...props.entity, info: { ...props.entity.info!, personalName: incrementalName } });
                    return resolve(incrementalName);
                })
                .catch(reject);
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
        if (!props.entity.info?.personalName || props.entity.info?.personalName.length == 0) {
            props.printError("Plant name size must be between 1 and 30 characters");
            return;
        }
        if (!updatedBotanicalInfo?.species) {
            props.printError("Specie name cannot be empty");
            return;
        }
        isNameAvailable(props.entity.info.personalName)
            .then(res => {
                if (!res) {
                    props.printError("Duplicated plant name");
                    return;
                }
                if (!props.botanicalInfoToAdd || !props.botanicalInfoToAdd.id) {
                    const botanicalInfoToCreate = {
                        ...updatedBotanicalInfo,
                        state: "ALIVE",
                        creator: props.botanicalInfoToAdd === undefined ? "USER" : "TREFLE",
                        synonyms: updatedBotanicalInfo!.synonyms,
                        plantCareInfo: updatedBotanicalInfo?.plantCareInfo ? updatedBotanicalInfo.plantCareInfo : {},
                    } as botanicalInfo;
                    const thumbnail = updatedBotanicalInfoThumbnail.file || updatedBotanicalInfoThumbnail.url || updatedBotanicalInfo?.imageUrl;
                    addNewBotanicalInfo(botanicalInfoToCreate, thumbnail)
                        .then(addedBotanicalInfo => {
                            setUpdatedBotanicalInfo(addedBotanicalInfo);
                            const plantToCreate = {
                                ...props.entity,
                                botanicalInfoId: addedBotanicalInfo.id,
                                info: {
                                    ...props.entity.info,
                                    startDate: useDate ? props.entity.info!.startDate : undefined,
                                    state: "ALIVE",
                                },
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
                        info: {
                            ...props.entity.info,
                            startDate: useDate ? props.entity.info!.startDate : undefined,
                            state: "ALIVE",
                        },
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
            if (image === undefined) {
                props.requestor.post("botanical-info", toAdd)
                    .then(newBotanicalInfoRes => {
                        props.setUpdatedImgUrl(newBotanicalInfoRes.data.imageUrl);
                        accept(newBotanicalInfoRes.data)
                    })
                    .catch(reject);
            } else if (typeof (image) === "string") {
                props.requestor.post("botanical-info", {
                    ...toAdd,
                    imageUrl: image,
                })
                    .then(newBotanicalInfoRes => {
                        props.setUpdatedImgUrl(newBotanicalInfoRes.data.imageUrl);
                        accept(newBotanicalInfoRes.data)
                    })
                    .catch(reject);
            } else {
                readImgContent(image as File)
                    .then(imgContent => {
                        props.requestor.post("botanical-info", {
                            ...toAdd,
                            imageContent: imgContent,
                            imageContentType: (image as File).type,
                        })
                            .then(newBotanicalInfoRes => {
                                props.setUpdatedImgUrl(newBotanicalInfoRes.data.imageUrl);
                                accept(newBotanicalInfoRes.data)
                            })
                            .catch(reject);
                    })
            }
        });
    };


    const readImgContent = (input: File): Promise<string> =>
        new Promise((resolve, reject) => {
            const reader = new FileReader();

            reader.onload = (event) => {
                const arrayBuffer = event.target?.result as ArrayBuffer;
                const byteArray = new Uint8Array(arrayBuffer);
                resolve(byteArrayToBase64(byteArray as Uint8Array));
            };

            reader.onerror = (error) => {
                reject(error);
            };

            reader.readAsArrayBuffer(input);
        });


    const byteArrayToBase64 = (byteArray: Uint8Array): string => {
        let binary = '';
        byteArray.forEach((byte) => {
            binary += String.fromCharCode(byte);
        });
        return btoa(binary);
    }

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

    const cleanup = (): void => {
        setUpdatedBotanicalInfo(undefined);
        //setInfo(undefined)
        setUseDate(true);
        setPlantNameError(undefined);
    };

    const updateBotanicalInfo = (id: number, updated: Partial<botanicalInfo>, image?: string | File): Promise<botanicalInfo> => {
        return new Promise<botanicalInfo>((accept, reject) => {
            if (image === undefined) {
                props.requestor.put(`botanical-info/${id}`, updated)
                    .then(res => accept(res.data))
                    .catch(props.printError);
            } else if (typeof (image) === "string") {
                props.requestor.put(`botanical-info/${id}`, {
                    ...updated,
                    imageUrl: image,
                    imageId: undefined
                })
                    .then(res => accept(res.data))
                    .catch(reject);
            } else {
                readImgContent(image)
                    .then(imgContent => {
                        props.requestor.put(`botanical-info/${updated.id}`, {
                            ...updated,
                            imageContent: imgContent,
                            imageContentType: image.type,
                            imageUrl: undefined,
                            imageId: undefined,
                        })
                            .then(res => accept(res.data))
                            .catch(reject);
                    })
            }
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


    const a11yProps = (index: number): {} => {
        return {
            id: `full-width-tab-${index}`,
            'aria-controls': `full-width-tabpanel-${index}`,
        };
    };


    return <Box sx={{
        position: "relative",
        top: "-80px",
        backgroundColor: "background.default",
        borderRadius: "35px",
        padding: "30px",
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

        <Tabs
            value={tabValue}
            onChange={(_e, newVal) => setTabValue(newVal)}
            indicatorColor="secondary"
            textColor="inherit"
            variant="fullWidth"
        >
            <Tab label="Species" {...a11yProps(0)} />
            {props.editModeEnabled || <Tab label="Plant" {...a11yProps(1)} />}
        </Tabs>

        <TabPanel value={tabValue} index={0} dir={theme.direction}>
            <SpecieInfoDetails
                editModeEnabled={props.editModeEnabled}
                botanicalInfoToAdd={props.botanicalInfoToAdd}
                updatedBotanicalInfo={updatedBotanicalInfo}
                updatedBotanicalInfoThumbnail={updatedBotanicalInfoThumbnail}
                setUpdatedBotanicalInfoThumbnail={setUpdatedBotanicalInfoThumbnail}
            />
        </TabPanel>
        {
            props.editModeEnabled ||
            <TabPanel value={tabValue} index={1} dir={theme.direction}>
                <PlantInfoDetails
                    entity={props.entity}
                    setEntity={props.setEntity}
                    plantNameError={plantNameError}
                />
            </TabPanel>
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
                                const thumbnail = updatedBotanicalInfoThumbnail.file || updatedBotanicalInfoThumbnail.url;
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
    const [toCreate, setToCreate] = useState<Partial<plant>>({});

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
                    entity={toCreate}
                    setEntity={setToCreate}
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
