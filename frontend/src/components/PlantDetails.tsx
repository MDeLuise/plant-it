import { Autocomplete, Avatar, Box, Button, Drawer, IconButton, List, ListItem, ListItemAvatar, ListItemText, MenuItem, Modal, Select, Skeleton, Switch, Tab, Tabs, TextField, Tooltip, Typography } from "@mui/material";
import { useTheme } from '@mui/material/styles';
import { botanicalInfo, plant, plantInfo } from "../interfaces";
import React, { useEffect, useState } from "react";
import { AxiosInstance } from "axios";
import { Swiper, SwiperSlide } from "swiper/react";
import { Pagination, Virtual, FreeMode, Navigation, Keyboard, Zoom } from "swiper";
import "swiper/css";
import "swiper/css/pagination";
import 'swiper/css/virtual';
import "swiper/css/free-mode";
import 'swiper/css/navigation';
import 'swiper/css/zoom';
import "../style/PlantDetails.scss";
import { fetchBotanicalInfo, formatHumidityRequirement, formatLightRequirement, formatPh, getAllCurrencySymbols, getPlantImg, imgToBase64, titleCase } from "../common";
import EditIcon from '@mui/icons-material/Edit';
import FavoriteBorderOutlinedIcon from '@mui/icons-material/FavoriteBorderOutlined';
import ArrowBackOutlinedIcon from '@mui/icons-material/ArrowBackOutlined';
import EventOutlinedIcon from '@mui/icons-material/Event';
import AddPhotoAlternateIcon from '@mui/icons-material/AddPhotoAlternate';
import CloseOutlinedIcon from '@mui/icons-material/CloseOutlined';
import DeleteOutlineOutlinedIcon from '@mui/icons-material/DeleteOutlineOutlined';
import SaveAsOutlinedIcon from '@mui/icons-material/SaveAsOutlined';
import { LocalizationProvider, DatePicker } from "@mui/x-date-pickers";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import dayjs from "dayjs";
import CloseIcon from '@mui/icons-material/Close';
import DeleteIcon from '@mui/icons-material/Delete';
import ConfirmDeleteDialog from "./ConfirmDialog";
import { EditableTextField } from "./EditableTextField";
import { ReadMoreReadLess } from "./ReadMoreReadLess";
import HelpOutlineIcon from '@mui/icons-material/HelpOutline';
import { HelpTooltip } from "./HelpTooltip";
import BeachAccessIcon from '@mui/icons-material/BeachAccess';
import ImageIcon from '@mui/icons-material/Image';
import WorkIcon from '@mui/icons-material/Work';
import { ReminderList } from "./Reminder";


function PlantImageFullSize(props: {
    imgIds: string[],
    imgIndex: number,
    requestor: AxiosInstance,
    open: boolean,
    printError: (err: any) => void,
    onClose: () => void,
    avatarImageId?: string,
    setAvatarImage: (id: string) => void,
    setImageIds: (arg: string[]) => void,
    openConfirmDialog: (text: string, callback: () => void) => void,
    onDelete: (arg: string) => void;
}) {
    const [indexToDisplay, setIndexToDisplay] = useState<number>(props.imgIndex);
    const [swiperInstance, setSwiperInstance] = useState<any>();
    const [imageMetadata, setImageMetadata] = useState<{
        description?: string,
        createOn: Date;
    }>();

    const style = {
        position: 'absolute',
        top: '50%',
        left: '50%',
        transform: 'translate(-50%, -50%)',
        width: "95%",
        height: "100%",
    };

    const fetchImageMetadata = (index: number) => {
        if (props.imgIds[index] === undefined) {
            return;
        }
        props.requestor.get(`image/${props.imgIds[index]}`)
            .then(res => {
                setImageMetadata({
                    description: res.data.description,
                    createOn: res.data.createOn,
                })
            })
            .catch(props.printError);
    };

    const deleteImage = () => {
        props.openConfirmDialog(
            "Are you sure you want to delete the image? This action can not be undone.",
            () => {
                const idToRemove = props.imgIds[indexToDisplay];
                props.requestor.delete(`image/${idToRemove}`)
                    .then(_res => {
                        let newImageIds: string[] = [...props.imgIds].filter(id => id !== idToRemove);
                        props.setImageIds(newImageIds);
                        props.onDelete(idToRemove);
                        if (newImageIds.length === 0) {
                            props.onClose();
                        }
                    })
                    .catch(props.printError)
            });
    };

    useEffect(() => {
        setIndexToDisplay(props.imgIndex);
    }, [props.imgIndex]);

    useEffect(() => {
        fetchImageMetadata(indexToDisplay);
    }, [indexToDisplay]);

    useEffect(() => {
        if (swiperInstance !== undefined && !swiperInstance.destroyed) {
            swiperInstance.slideTo(props.imgIndex);
        }
    }, [swiperInstance]);

    return <Modal
        open={props.open}
        onClose={props.onClose}
        sx={{
            backdropFilter: "blur(2px)",
            backgroundColor: 'rgba(0, 0, 30, .4)',
            '& .swiper-button-disabled': {
                display: "none",
            }
        }}
    >
        <Box sx={style}>
            <CloseIcon
                onClick={props.onClose}
                style={{
                    position: "absolute",
                    top: "20px",
                    left: "0",
                    color: "white",
                    fontWeight: 800,
                    zIndex: 2,
                }}
            />

            <DeleteIcon
                onClick={deleteImage}
                style={{
                    position: "absolute",
                    top: "20px",
                    right: "0",
                    color: "white",
                    zIndex: 2,
                }}
            />

            <Swiper
                slidesPerView={1}
                spaceBetween={1}
                centeredSlides={true}
                navigation={true}
                grabCursor={true}
                zoom={true}
                keyboard={{
                    enabled: true,
                }}
                modules={[Virtual, FreeMode, Navigation, Keyboard, Zoom]}
                style={{
                    height: "90%",
                }}
                onActiveIndexChange={swiper => setIndexToDisplay(swiper.activeIndex)}
                onSwiper={setSwiperInstance}
            >
                {
                    props.imgIds.map((imgId, index) => {
                        return <SwiperSlide key={`full_slide_${imgId}`}>
                            <Box className="swiper-zoom-container">
                                <PlantImage
                                    imgId={imgId}
                                    imgKey={imgId}
                                    active={Math.abs(index - indexToDisplay) < 2}
                                    requestor={props.requestor}
                                    printError={props.printError}
                                    style={{
                                        objectFit: "contain",
                                    }}
                                />
                            </Box>
                        </SwiperSlide>;
                    })
                }
            </Swiper>

            <Box sx={{
                display: "flex",
                justifyContent: "space-between",
                alignItems: "center",
                color: "white",
                padding: "0",
            }}>
                {
                    imageMetadata?.description &&
                    <Typography>{imageMetadata.description}</Typography>
                }
                <Typography>{new Date(imageMetadata?.createOn || new Date()).toDateString()}</Typography>
                {
                    props.avatarImageId !== props.imgIds[indexToDisplay] &&
                    <Button
                        onClick={() => props.setAvatarImage(props.imgIds[indexToDisplay])}
                        sx={{
                            backgroundColor: "primary.main",
                            color: "white",
                            padding: "10px 15px",
                            "&:hover": { backgroundColor: "primary.main" },
                        }}>
                        Set as plant avatar
                    </Button>
                }
            </Box>
        </Box>
    </Modal>
}


function PlantImageThumbnail(props: {
    imgId: string,
    active: boolean,
    requestor: AxiosInstance,
    imgKey: string,
    printError: (err: any) => void,
    onClick: () => void,
    close: () => void;
}) {
    const [downloaded, setDownloaded] = useState<boolean>(false);
    const [imgBase64, setImgBase64] = useState<string>();

    const getImgBase64 = (): void => {
        props.requestor.get(`image/thumbnail/${props.imgId}`)
            .then(res => {
                setImgBase64(res.data);
                setDownloaded(true);
            })
            .catch(props.printError);
    };

    useEffect(() => {
        getImgBase64();
    }, [props.active]);

    return (
        <Box
            sx={{
                width: "100%",
                height: "100%",
                borderRadius: "10px",
                overflow: "hidden",
            }}
            onClick={downloaded ? props.onClick : undefined}
        >
            {
                !downloaded &&
                <Skeleton
                    variant="rectangular"
                    animation="wave"
                    sx={{
                        width: "100%",
                        height: "100%",
                        zIndex: 1,
                    }}
                />
            }
            {
                downloaded &&
                <img
                    src={`data:application/octet-stream;base64,${imgBase64}`}
                    style={{
                        width: "100%",
                        height: "100%",
                        objectFit: "cover",
                        zIndex: 2,
                    }}
                    key={props.imgKey}
                    loading="lazy"
                />
            }
        </Box>);
}


function PlantImage(props: {
    imgId: string,
    active: boolean,
    requestor: AxiosInstance,
    imgKey: string,
    printError: (err: any) => void,
    style?: {};
}) {
    const [downloaded, setDownloaded] = useState<boolean>(false);
    const [imgBase64, setImgBase64] = useState<string>();

    const getImgBase64 = (): void => {
        props.requestor.get(`/image/content/${props.imgId}`)
            .then(res => {
                setImgBase64(res.data);
                setDownloaded(true);
            })
            .catch(err => {
                props.printError(err);
                getPlantImg(props.requestor, undefined)
                    .then(res => {
                        imgToBase64(res, (arg: string) => {
                            setImgBase64(arg);
                            setDownloaded(true);
                        });
                    })
                    .catch(err => {
                        console.error(err);
                        props.printError(`Cannot load image with id ${props.imgId}`);
                    });
            });
    };

    useEffect(() => {
        if (props.active) {
            getImgBase64();
        }
    }, [props.active]);

    return (
        <>
            {
                !downloaded &&
                <Skeleton
                    variant="rectangular"
                    animation="wave"
                    sx={{
                        width: "100%",
                        height: "50%",
                        backgroundColor: "rgb(154 154 154 / 60%)",
                        zIndex: 2,
                    }}
                />
            }
            {
                props.active && downloaded &&
                <img
                    src={`data:application/octet-stream;base64,${imgBase64}`}
                    style={{
                        width: "100%",
                        height: "100%",
                        objectFit: "cover",
                        zIndex: 1,
                        ...props.style,
                    }}
                    key={props.imgKey}
                    loading="lazy"
                />
            }
        </>);
}

function PlantHeader(props: {
    requestor: AxiosInstance,
    entity?: plant,
    printError: (err: any) => void,
    toggleEditPlantMode: () => void,
    closePlantDetails: () => void;
}) {
    const [imageDownloaded, setImageDownloaded] = useState<boolean>(false);
    const [imageSrc, setImageSrc] = useState<string>();

    useEffect(() => {
        if (props.entity === undefined) {
            return;
        }
        getPlantImg(props.requestor, props.entity.avatarImageUrl)
            .then(res => {
                setImageSrc(res);
                setImageDownloaded(true);
            })
            .catch(err => {
                console.error(err);
                props.printError("Cannot load plant's avatar image");
                getPlantImg(props.requestor, undefined)
                    .then(res => {
                        setImageSrc(res);
                        setImageDownloaded(true);
                    })
            })
    }, [props.entity]);

    return (
        <Box
            sx={{
                height: "70vh",
                overflow: "hidden",
                transition: ".5s height",
            }}
            id="plant-header"
        >
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
                    onClick={props.closePlantDetails}
                />
                <EditIcon
                    sx={{
                        backdropFilter: "blur(10px)",
                        color: "white",
                        borderRadius: "50%",
                        padding: "5px",
                        backgroundColor: "rgba(32, 32, 32, .1)",
                    }}
                    fontSize="large"
                    onClick={props.toggleEditPlantMode}
                />
            </Box>
            {
                !imageDownloaded &&
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
                imageDownloaded &&
                <img
                    src={imageSrc}
                    style={{
                        objectFit: "cover",
                        width: "100%",
                        height: "100%",
                    }}
                />
            }
        </Box>
    );
}


function PlantInfo(props: {
    requestor: AxiosInstance,
    open: boolean,
    plant?: plant,
    botanicalInfo?: botanicalInfo,
    editModeEnabled: boolean,
    imageIds: string[],
    setImageIds: (arg: string[]) => void,
    printError: (arg: any) => void,
    setBotanicalInfoId: (arg: number) => void,
    setPersonalName: (arg: string) => void,
    setNote: (arg: string) => void,
    setDate: (arg: Date) => void,
    setUseDate: (arg: boolean) => void,
    setSpeciesThumbnail: (arg: string) => void,
    uploadAndSetSpeciesThumbnail: (arg: File) => void,
    setAvatarMode: (arg: "NONE" | "RANDOM" | "LAST" | "SPECIFIED") => void,
    plantImgFullSizeState?: {
        imgIndex: number,
        open: boolean;
    },
    setPlantImgFullSizeState: (arg: {
        imgIndex: number,
        open: boolean;
    }) => void,
    setNewBotanicalInfoToSave: (arg?: botanicalInfo) => void,
    setBotanicalInfoSynonyms: (arg: string[]) => void,
    setInfo: (arg: plantInfo) => void;
}) {
    const theme = useTheme();
    const [tabValue, setTabValue] = useState<0 | 1>(0);


    useEffect(() => {
        if (props.plant === undefined) {
            return;
        }
        props.requestor.get(`/image/entity/all/${props.plant?.id}`)
            .then(res => props.setImageIds(res.data))
            .catch(props.printError);
    }, [props.plant]);


    const a11yProps = (index: number): {} => {
        return {
            id: `full-width-tab-${index}`,
            'aria-controls': `full-width-tabpanel-${index}`,
        };
    }


    return <Box
        sx={{
            position: "relative",
            top: "-30px",
            backgroundColor: "background.default",
            borderRadius: "35px",
            padding: "30px 30px 100px 30px",
            minHeight: "100vh",
            zIndex: 1,
        }}
    >

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
            sx={{
                display: "flex",
                alignItems: "center",
                justifyContent: "space-between",
                marginBottom: "50px",
            }}
        >
            <Box
                sx={{
                    display: "flex",
                    flexDirection: "column",
                    width: "100%",
                }}
            >
                <EditableTextField
                    editable={props.editModeEnabled}
                    text={props.plant?.info.personalName}
                    variant="h6"
                    style={{
                        fontWeight: "bold",
                        flexGrow: props.editModeEnabled ? 1 : 0,
                    }}
                    onChange={props.setPersonalName}
                />
                {
                    props.editModeEnabled ||
                    <Typography>
                        {props.botanicalInfo?.species}
                    </Typography>
                }
            </Box>

            {/* <FavoriteBorderOutlinedIcon /> */}
        </Box>

        <Tabs
            value={tabValue}
            onChange={(_e, newVal) => setTabValue(newVal)}
            indicatorColor="secondary"
            textColor="inherit"
            variant="fullWidth"
        >
            <Tab label="Species" {...a11yProps(0)} />
            <Tab label="Plant" {...a11yProps(1)} />
        </Tabs>

        <TabPanel value={tabValue} index={0} dir={theme.direction}>
            <SpecieInfoDetails
                requestor={props.requestor}
                printError={props.printError}
                editModeEnabled={props.editModeEnabled}
                setBotanicalInfoId={props.setBotanicalInfoId}
                setNewBotanicalInfoToSave={props.setNewBotanicalInfoToSave}
                setBotanicalInfoSynonyms={props.setBotanicalInfoSynonyms}
                plant={props.plant}
                botanicalInfo={props.botanicalInfo}
            />
        </TabPanel>

        <TabPanel value={tabValue} index={1} dir={theme.direction}>
            <PlantInfoDetails
                editModeEnabled={props.editModeEnabled}
                setNote={props.setNote}
                setDate={props.setDate}
                setUseDate={props.setUseDate}
                setSpeciesThumbnail={props.setSpeciesThumbnail}
                setAvatarMode={props.setAvatarMode}
                imageIds={props.imageIds}
                requestor={props.requestor}
                printError={props.printError}
                setPlantImgFullSizeState={props.setPlantImgFullSizeState}
                plant={props.plant}
                setInfo={props.setInfo}
            />
        </TabPanel>
    </Box >;
}


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


function SpecieInfoDetails(props: {
    requestor: AxiosInstance,
    printError: (arg: any) => void,
    plant?: plant,
    editModeEnabled: boolean,
    botanicalInfo?: botanicalInfo,
    setBotanicalInfoId: (arg: number) => void,
    setNewBotanicalInfoToSave: (arg?: botanicalInfo) => void,
    setBotanicalInfoSynonyms: (arg: string[]) => void;
}) {
    const [autoCompleteValue, setAutoCompleteValue] = useState<botanicalInfo>();
    const [autoCompleteOptions, setAutoCompleteOptions] = useState<botanicalInfo[]>([]);


    const fetchNewBotanicalInfoOptions = (partialScientificName: string) => {
        if (partialScientificName === "") {
            props.requestor.get("botanical-info")
                .then(res => {
                    setAutoCompleteOptions(res.data);
                })
                .catch(props.printError);
        } else {
            props.requestor.get(`botanical-info/partial/${partialScientificName}`)
                .then(res => {
                    setAutoCompleteOptions(res.data);
                })
                .catch(props.printError);
        }
    };


    useEffect(() => {
        setAutoCompleteValue(props.botanicalInfo);
    }, [props.botanicalInfo]);


    useEffect(() => {
        if (autoCompleteValue !== undefined) {
            if (autoCompleteValue.id !== undefined && autoCompleteValue.id !== null) {
                props.setBotanicalInfoId(autoCompleteValue.id);
                props.setNewBotanicalInfoToSave(undefined);
            } else {
                props.setNewBotanicalInfoToSave(autoCompleteValue);
            }
        } else {
            props.setNewBotanicalInfoToSave(undefined);
        }
    }, [autoCompleteValue]);


    useEffect(() => {
        if (props.plant === undefined) {
            return;
        }
        if (props.botanicalInfo !== undefined) {
            setAutoCompleteOptions([props.botanicalInfo]);
        }
    }, [props.plant]);


    return <>
        <Box
            className="plant-detail-section">
            <Typography variant="h6">
                Scientific classification
            </Typography>

            {
                props.editModeEnabled ?
                    <Autocomplete
                        onChange={(_e, v) => {
                            if (v !== null) {
                                setAutoCompleteValue(v);
                            }
                        }}
                        onInputChange={(_e, v) => {
                            fetchNewBotanicalInfoOptions(v);
                        }}
                        options={autoCompleteOptions}
                        getOptionLabel={botInf => `${botInf.scientificName} (${botInf.creator.toLocaleLowerCase()})`}
                        value={autoCompleteValue}
                        isOptionEqualToValue={(op, val) => op.scientificName === val.scientificName}
                        renderInput={(params) => (
                            <TextField
                                {...params}
                                variant="outlined"
                            />
                        )}
                    />
                    :
                    <>
                        <Box className="plant-detail-entry">
                            <Typography>
                                Family
                            </Typography>
                            <Typography>
                                {props.botanicalInfo?.family}
                            </Typography>
                        </Box>
                        <Box className="plant-detail-entry">
                            <Typography>
                                Genus
                            </Typography>
                            <Typography>
                                {props.botanicalInfo?.genus}
                            </Typography>
                        </Box>
                        <Box className="plant-detail-entry">
                            <Typography>
                                Species
                            </Typography>
                            <Typography>
                                {props.botanicalInfo?.species}
                            </Typography>
                        </Box>
                    </>
            }
        </Box>

        {
            !props.editModeEnabled && props.botanicalInfo?.synonyms &&
            <Box className="plant-detail-section">
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
                        props.editModeEnabled &&
                        <TextField
                            fullWidth
                            multiline
                            defaultValue={props.botanicalInfo?.synonyms?.join("; ") || ""}
                            rows={4}
                            onChange={ev => props.setBotanicalInfoSynonyms(ev.target.value.split(";").map(syn => syn.trim()))}
                        />
                        ||
                        <ReadMoreReadLess
                            text={props.botanicalInfo?.synonyms?.join("; ") || ""}
                            size={50}
                        />
                    }
                </Box>
            </Box>
        }

        {
            !props.editModeEnabled &&
            <Box
                className="plant-detail-section">
                <Typography variant="h6">
                    Care info
                </Typography>
                {
                    (!props.editModeEnabled && props.botanicalInfo?.plantCareInfo.allNull) &&
                    <Typography sx={{ fontStyle: 'italic' }}>not provided</Typography>
                }
                {
                    (props.botanicalInfo?.plantCareInfo.light) &&
                    <Box className="plant-detail-entry">
                        <Typography>
                            Light
                        </Typography>
                        <EditableTextField
                            editable={props.editModeEnabled}
                            text={formatLightRequirement(props.botanicalInfo?.plantCareInfo.light, false)}
                        />
                    </Box>
                }
                {
                    (props.botanicalInfo?.plantCareInfo.humidity) &&
                    <Box className="plant-detail-entry">
                        <Typography>
                            Soil humidity
                        </Typography>
                        <EditableTextField
                            editable={props.editModeEnabled}
                            text={formatHumidityRequirement(props.botanicalInfo?.plantCareInfo.humidity, false)}
                        />
                    </Box>
                }
                {
                    (props.botanicalInfo?.plantCareInfo.maxTemp) &&
                    <Box className="plant-detail-entry">
                        <Typography>
                            Maximum temperature
                        </Typography>
                        <EditableTextField
                            editable={props.editModeEnabled}
                            text={props.botanicalInfo?.plantCareInfo.maxTemp + " °C"}
                        />
                    </Box>
                }
                {
                    (props.botanicalInfo?.plantCareInfo.minTemp) &&
                    <Box className="plant-detail-entry">
                        <Typography>
                            Minimum temperature
                        </Typography>
                        <EditableTextField
                            editable={props.editModeEnabled}
                            text={props.botanicalInfo?.plantCareInfo.minTemp + " °C"}
                        />
                    </Box>
                }
                {
                    (props.botanicalInfo?.plantCareInfo.phMax) &&
                    <Box className="plant-detail-entry">
                        <Typography>
                            Maximum ph
                        </Typography>
                        <EditableTextField
                            editable={props.editModeEnabled}
                            text={formatPh(props.botanicalInfo?.plantCareInfo.phMax)}
                        />
                    </Box>
                }
                {
                    (props.botanicalInfo?.plantCareInfo.phMin) &&
                    <Box className="plant-detail-entry">
                        <Typography>
                            Minimum ph
                        </Typography>
                        <EditableTextField
                            editable={props.editModeEnabled}
                            text={formatPh(props.botanicalInfo?.plantCareInfo.phMin)}
                        />
                    </Box>
                }
            </Box>
        }
    </>
}


function PlantInfoDetails(props: {
    editModeEnabled: boolean,
    plant?: plant,
    setNote: (arg: string) => void,
    setDate: (arg: Date) => void,
    setUseDate: (arg: boolean) => void,
    setSpeciesThumbnail: (arg: string) => void,
    setAvatarMode: (arg: "NONE" | "RANDOM" | "LAST" | "SPECIFIED") => void,
    imageIds: string[],
    requestor: AxiosInstance,
    printError: (arg: any) => void,
    plantImgFullSizeState?: {
        imgIndex: number,
        open: boolean;
    },
    setPlantImgFullSizeState: (arg: {
        imgIndex: number,
        open: boolean;
    }) => void,
    setInfo: (arg: plantInfo) => void;
}) {
    const [diaryEntryStats, setDiaryEntryStats] = useState<any[]>([]);
    const [useDate, setUseDate] = useState<boolean>(true);
    const [selectedAvatarMode, setSelectedAvatarMode] = useState<string>("NONE");
    const [initialAvatarMode, setInitialAvatarMode] = useState<string>("NONE");
    const [plantStats, setPlantStats] = useState<{
        photos?: number,
        events?: number;
    }>({});
    const [activeIndex, setActiveIndex] = useState<number>(0);
    const [swiperInstance, setSwiperInstance] = useState<any>();


    const fetchAndSetPlantStats = (): void => {
        props.requestor.get(`diary/entry/${props.plant?.id}/_count`)
            .then(res => {
                setPlantStats({ ...plantStats, events: res.data });
            })
            .catch(props.printError);
    };


    const formatAvatarMode = (arg: string): string => {
        switch (arg) {
            case "NONE": return "species";
            case "SPECIFIED": return "chosen";
            default: return arg.toLocaleLowerCase();
        }
    };


    const formatPurchasedPrice = (): string => {
        const price = props.plant?.info.purchasedPrice;
        const currency = props.plant?.info.currencySymbol;
        let result = "";
        if (price) {
            result += price;
        }
        if (currency) {
            result += ` ${currency}`;
        }
        return result;
    }


    useEffect(() => {
        if (props.plant === undefined) {
            return;
        }
        setUseDate(props.plant.info.startDate != undefined);
        setSelectedAvatarMode(props.plant.avatarMode || "NONE");
        setInitialAvatarMode(props.plant.avatarMode || "NONE");
        props.requestor.get(`diary/entry/${props.plant?.id}/stats`)
            .then(res => setDiaryEntryStats(res.data))
            .catch(props.printError);
        fetchAndSetPlantStats();
    }, [props.plant]);


    useEffect(() => {
        setActiveIndex(0);
        if (swiperInstance != undefined && swiperInstance.destroyed !== true) {
            swiperInstance.slideTo(0);
        }
    }, [props.imageIds]);

    return <>
        <Box
            className="plant-detail-section">
            <Typography variant="h6">
                Plant info
            </Typography>

            <Box className="plant-detail-entry" >
                <Typography>
                    Use date
                </Typography>
                <Switch
                    checked={useDate}
                    disabled={!props.editModeEnabled}
                    onChange={event => {
                        setUseDate(event.target.checked);
                        props.setUseDate(event.target.checked);
                    }}
                />
            </Box>

            <Box className="plant-detail-entry">
                <Typography>
                    Date
                </Typography>
                {
                    props.editModeEnabled ?
                        <LocalizationProvider dateAdapter={AdapterDayjs}>
                            <DatePicker
                                value={dayjs(props.plant?.info.startDate || new Date())}
                                readOnly={!props.editModeEnabled}
                                disabled={!useDate}
                                onChange={newValue => props.setDate(newValue != undefined ? newValue.toDate() : new Date())}
                                slotProps={{ textField: { variant: 'standard', } }}
                                format="DD/MM/YYYY"
                            />
                        </LocalizationProvider>
                        :
                        <Typography>
                            {
                                props.plant?.info.startDate !== null ?
                                    new Date(props.plant?.info.startDate || new Date()).toDateString()
                                    :
                                    "-"
                            }
                        </Typography>
                }
            </Box>
            <Box className="plant-detail-entry">
                <Typography>
                    Avatar
                </Typography>
                {
                    props.editModeEnabled ?
                        <Select
                            variant="standard"
                            value={selectedAvatarMode}
                            onChange={ev => {
                                let value = ev.target.value as "NONE" | "LAST" | "RANDOM" | "SPECIFIED";
                                props.setAvatarMode(value);
                                setSelectedAvatarMode(value);
                            }}
                            readOnly={!props.editModeEnabled}
                            disableUnderline
                        >
                            {
                                initialAvatarMode === "SPECIFIED" &&
                                <MenuItem value="SPECIFIED">chosen</MenuItem>
                            }
                            <MenuItem value="NONE">species</MenuItem>
                            <MenuItem value="LAST">last</MenuItem>
                            <MenuItem value="RANDOM">random</MenuItem>
                        </Select>
                        :
                        <Typography>{formatAvatarMode(selectedAvatarMode)}</Typography>
                }
            </Box>

            {
                (props.editModeEnabled || props.plant?.info.purchasedPrice) &&
                <Box className="plant-detail-entry">
                    <Typography>
                        Purchased price
                    </Typography>
                    {
                        props.editModeEnabled ?
                            <Box sx={{ display: "flex", gap: "5px", justifyContent: "end" }}>
                                <TextField
                                    variant="standard"
                                    InputProps={{ disableUnderline: false }}
                                    onChange={e => {
                                        props.setInfo({ ...props.plant?.info!, purchasedPrice: Number(e.target.value) });
                                    }}
                                    value={props.plant?.info.purchasedPrice}
                                    sx={{
                                        color: "black",
                                        width: "40%",
                                    }}
                                    type="number"
                                />
                                <Select
                                    defaultValue={props.plant?.info.currencySymbol || ""}
                                    variant="standard"
                                    onChange={e => {
                                        props.setInfo({ ...props.plant?.info!, currencySymbol: e.target.value as (string | undefined) });
                                    }}
                                >
                                    {
                                        getAllCurrencySymbols().map(symbol => {
                                            return <MenuItem value={symbol}>{symbol}</MenuItem>
                                        })
                                    }
                                </Select>
                            </Box>
                            :
                            <Typography>{formatPurchasedPrice()}</Typography>
                    }
                </Box>
            }
            {
                (props.editModeEnabled || props.plant?.info.seller) &&
                <Box className="plant-detail-entry">
                    <Typography>
                        Seller
                    </Typography>
                    <EditableTextField
                        editable={props.editModeEnabled}
                        text={props.plant?.info.seller || ""}
                        onChange={val => props.setInfo({ ...props.plant?.info!, seller: val })}
                    />
                </Box>
            }
            {
                (props.editModeEnabled || props.plant?.info.location) &&
                <Box className="plant-detail-entry">
                    <Typography>
                        Location
                    </Typography>
                    <EditableTextField
                        editable={props.editModeEnabled}
                        text={props.plant?.info.location || ""}
                        onChange={val => props.setInfo({ ...props.plant?.info!, location: val })}
                    />
                </Box>
            }

            <Box className="plant-detail-entry" style={{ flexDirection: "column" }}>
                <Typography>
                    Note
                </Typography>
                {
                    props.editModeEnabled ?
                        <TextField
                            fullWidth
                            multiline
                            defaultValue={props.plant?.info.note}
                            rows={4}
                            onChange={e => props.setNote(e.currentTarget.value)}
                        />
                        :
                        <ReadMoreReadLess
                            text={props.plant?.info.note || ""}
                            size={50}
                        />
                }
            </Box>
        </Box>

        {!props.editModeEnabled &&
            <Box
                className="plant-detail-section">
                <Typography variant="h6">
                    Plant stats
                </Typography>

                <Box className="plant-detail-entry">
                    <Typography>
                        Photos
                    </Typography>
                    <Typography>
                        {props.imageIds.length}
                    </Typography>
                </Box>
                <Box className="plant-detail-entry">
                    <Typography>
                        Events
                    </Typography>
                    <Typography>
                        {plantStats.events}
                    </Typography>
                </Box>
                <Box className="plant-detail-entry">
                    <Typography>
                        Age (days)
                    </Typography>
                    <Typography>
                        {
                            props.plant?.info.startDate &&
                            Math.floor(((new Date()).getTime() - new Date(props.plant?.info.startDate).getTime()) / (1000 * 3600 * 24))
                            || "-"
                        }
                    </Typography>
                </Box>
            </Box>
        }

        {
            !props.editModeEnabled &&
            <Box
                className="plant-detail-section">
                <Typography variant="h6">
                    Events stats
                </Typography>
                {
                    diaryEntryStats.length == 0 ?
                        <Typography sx={{ fontStyle: 'italic' }}>no event present</Typography>
                        :
                        diaryEntryStats.map((value: { type: string, date: Date; }) => {
                            return <Box
                                key={value.type}
                                style={{
                                    display: "flex",
                                    alignItems: "baseline",
                                    gap: "5px",
                                    justifyContent: "space-between",
                                }}>
                                <Typography>
                                    Last {titleCase(value.type).toLowerCase()}
                                </Typography>
                                <Typography>
                                    {Math.floor(((new Date()).getTime() - new Date(value.date).getTime()) / (1000 * 3600 * 24))} days ago
                                </Typography>
                            </Box>;
                        })
                }
            </Box>
        }
        {
            props.editModeEnabled ||
            <Box
                className="plant-detail-section">
                <Typography variant="h6">
                    Reminders
                </Typography>
                <ReminderList
                    plantId={props.plant?.id}
                    requestor={props.requestor}
                    printError={props.printError}
                />
            </Box>
        }
        {
            !props.editModeEnabled && props.imageIds.length > 0 &&
            <Box className="plant-detail-entry">
                <Typography variant="h6" sx={{ marginBottom: "10px", }}>
                    Gallery
                </Typography>

                <Swiper
                    slidesPerView={3}
                    spaceBetween={"10px"}
                    onActiveIndexChange={(swiper) => setActiveIndex(swiper.activeIndex)}
                    onSwiper={setSwiperInstance}
                    modules={[Pagination, Virtual, FreeMode]}
                    pagination={{
                        dynamicBullets: true,
                        clickable: true,
                    }}
                    style={{
                        paddingBottom: "30px",
                    }}
                >
                    {
                        props.imageIds.map((imgId, index) => {
                            return <SwiperSlide
                                key={`slide_${imgId}`}
                                style={{
                                    width: "30%",
                                    aspectRatio: 1,
                                }}
                            >
                                <PlantImageThumbnail
                                    imgId={imgId}
                                    imgKey={imgId}
                                    active={Math.abs(activeIndex - index) <= 2}
                                    requestor={props.requestor}
                                    printError={props.printError}
                                    onClick={() => {
                                        props.setPlantImgFullSizeState({
                                            imgIndex: index,
                                            open: true,
                                        });
                                    }}
                                    close={() => {
                                        props.setPlantImgFullSizeState({
                                            imgIndex: props.plantImgFullSizeState?.imgIndex || 0,
                                            open: false,
                                        });
                                    }}
                                />
                            </SwiperSlide>
                        })
                    }
                </Swiper>
            </Box>
        }
    </>
}


function BottomBar(props: {
    requestor: AxiosInstance,
    openAddLog: () => void,
    plant?: plant,
    botanicalInfo?: botanicalInfo,
    addUploadedImgs: (arg: string) => void,
    printError: (err: any) => void,
    editModeEnabled: boolean,
    toggleEditPlantMode: () => void,
    updatedPlant?: plant,
    newSpeciesThumbnailToUploadAndUse?: File,
    onUpdate: (arg: plant) => void,
    onDelete: (arg: plant) => void,
    openConfirmDialog: (text: string, callback: () => void) => void,
    close: () => void,
    changedBotanicalInfo?: botanicalInfo,
    online: boolean;
}) {

    const updatePlant = (): void => {
        if (props.changedBotanicalInfo === undefined) {
            props.requestor.put(`/plant/${props.plant?.id}`, props.updatedPlant)
                .then(res => {
                    props.onUpdate(res.data);
                    props.toggleEditPlantMode();
                })
                .catch(props.printError);
        } else {
            props.requestor.post("botanical-info", props.changedBotanicalInfo)
                .then(savedBotanicalInfoRes => {
                    if (props.changedBotanicalInfo!.imageUrl !== undefined) {
                        props.requestor.post(`image/botanical-info/${savedBotanicalInfoRes.data.id}/url/`, {
                            url: props.changedBotanicalInfo!.imageUrl,
                        })
                            .catch(props.printError);
                    }
                    props.requestor.put(`/plant/${props.plant?.id}`, {
                        ...props.updatedPlant,
                        botanicalInfoId: savedBotanicalInfoRes.data.id,
                    })
                        .then(plantRes => {
                            props.onUpdate(plantRes.data);
                            props.toggleEditPlantMode();
                        })
                        .catch(props.printError);
                })
                .catch(props.printError);
        }
    };

    const deletePlant = (): void => {
        props.requestor.delete(`plant/${props.plant?.id}`)
            .then(_res => {
                props.onDelete(props.plant!);
                props.close();
            })
            .catch(props.printError);
    };

    const addEntityImages = (toUpload: FileList, description?: string): void => {
        Array.from(toUpload).forEach(file => {
            const creationDate = new Date(file.lastModified);
            addEntityImage(file, creationDate, description);
        })
    };

    const addEntityImage = (toUpload: File, creationDate?: Date, description?: string): void => {
        let formData = new FormData();
        formData.append('image', toUpload);
        formData.append('creationDate', creationDate ? creationDate.toISOString() : '');
        formData.append('description', description || '');
        props.requestor.post(`/image/entity/${props.plant?.id}`, formData)
            .then(res => {
                props.addUploadedImgs(res.data);
            })
            .catch(props.printError);
    };

    return <Box
        sx={{
            position: "fixed",
            bottom: 0,
            width: "100%",
            padding: "20px",
            backgroundColor: "white",
            borderRadius: "35px 35px 0 0",
            zIndex: 2,
            display: "flex",
            justifyContent: "space-around",
        }}>
        {
            props.editModeEnabled ?
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
                        onClick={props.toggleEditPlantMode}
                    >
                        <CloseOutlinedIcon fontSize="medium" />
                    </Button>
                    <Button
                        sx={{
                            width: "20%",
                            backgroundColor: "error.main",
                            padding: "20px 0",
                            color: "white",
                            "&:hover": { backgroundColor: "error.main" },
                        }}
                        onClick={() => props.openConfirmDialog(
                            "Are you sure you want to delete the plant? This action can not be undone.",
                            deletePlant)
                        }
                        disabled={!props.online}
                    >
                        <DeleteOutlineOutlinedIcon fontSize="medium" />
                    </Button>
                    <Button
                        sx={{
                            width: "70%",
                            backgroundColor: "primary.main",
                            padding: "20px 0",
                            color: "white",
                            "&:hover": { backgroundColor: "primary.main" },
                        }}
                        onClick={updatePlant}
                    >
                        <SaveAsOutlinedIcon fontSize="medium" />
                    </Button>
                </Box>
                :
                <Box
                    sx={{
                        display: "flex",
                        justifyContent: "space-around",
                        width: "100%",
                    }}>
                    <input
                        id="upload-image"
                        type="file"
                        accept="image/*"
                        hidden
                        multiple
                        onChange={event => {
                            if (event.target.files != undefined) {
                                addEntityImages(event.target.files);
                            }
                        }}
                    />

                    <Button
                        sx={{
                            backgroundColor: "accent.secondary",
                            padding: "20px 0",
                            color: "white",
                            "&:hover": { backgroundColor: "accent.secondary" },
                        }}
                        onClick={props.openAddLog}
                        disabled={!props.online}
                    >
                        <EventOutlinedIcon fontSize="medium" />
                    </Button>
                    <Button
                        sx={{
                            width: "70%",
                            backgroundColor: "primary.main",
                            padding: "20px 0",
                            color: "white",
                            "&:hover": { backgroundColor: "primary.main" },
                        }}
                        onClick={() => {
                            document.getElementById("upload-image")?.click();
                        }}
                        disabled={!props.online}
                    >
                        <AddPhotoAlternateIcon fontSize="medium" />
                    </Button>
                </Box>
        }
    </Box>;
}

export default function PlantDetails(props: {
    open: boolean,
    close: () => void,
    plant?: plant,
    requestor: AxiosInstance,
    printError: (err: any) => void,
    openAddLogEntry: () => void,
    onPlantUpdate: (arg: plant) => void,
    onPlantDelete: (arg: plant) => void,
    online: boolean;
}) {
    const [botanicalInfo, setBotanicalInfo] = useState<botanicalInfo>();
    const [editModeEnabled, setEditModeEnabled] = useState<boolean>(false);
    const [updatedEntity, setUpdatedEntity] = useState<plant>();
    const [imageIds, setImageIds] = useState<string[]>([]);
    const [plantImgFullSizeState, setPlantImgFullSizeState] = useState<{
        imgIndex: number,
        open: boolean,
    }>({ imgIndex: 0, open: false });
    const [confirmDialogStatus, setConfirmDialogStatus] = useState<{
        text: string,
        confirmCallBack: () => void,
        open: boolean;
    }>({
        text: "",
        confirmCallBack: () => { },
        open: false,
    });
    const [newSpeciesThumbnailToUploadAndUse, setNewSpeciesThumbnailToUploadAndUse] = useState<File>();
    const [newBotanicalInfoToSave, setNewBotanicalInfoToSave] = useState<botanicalInfo>();

    const setBotanicalInfoId = (arg: number): void => {
        if (updatedEntity === undefined) {
            return;
        }
        updatedEntity.botanicalInfoId = arg;
    }

    const setPersonalName = (arg: string): void => {
        if (updatedEntity === undefined) {
            return;
        }
        updatedEntity.info.personalName = arg;
    };

    const setNote = (arg: string): void => {
        if (updatedEntity === undefined) {
            return;
        }
        updatedEntity.info.note = arg;
    };

    const setDate = (arg: Date): void => {
        if (updatedEntity === undefined) {
            return;
        }
        updatedEntity.info.startDate = arg;
    };

    const setUseDate = (arg: boolean): void => {
        if (updatedEntity === undefined) {
            return;
        }
        if (!arg) {
            updatedEntity.info.startDate = undefined;
        }
    };

    const setCustomSpeciesThumbnail = (url: string) => {
        if (botanicalInfo === undefined) {
            return;
        }
        botanicalInfo.imageUrl = url;
    }

    const setAvatarMode = (arg: "LAST" | "RANDOM" | "SPECIFIED" | "NONE"): void => {
        if (updatedEntity === undefined) {
            return;
        }
        updatedEntity.avatarMode = arg;
    };

    const setSynonyms = (arg: string[]): void => {
        if (botanicalInfo === undefined) {
            return;
        }
        botanicalInfo.synonyms = arg;
    };

    const setInfo = (arg: plantInfo): void => {
        if (updatedEntity === undefined) {
            return;
        }
        updatedEntity.info = arg;
    }

    const setAvatarImage = (id: string): void => {
        props.requestor.post(`image/plant/${props.plant?.id}/${id}`)
            .then(res => {
                props.onPlantUpdate(res.data);
            })
            .catch(props.printError);
    };

    useEffect(() => {
        if (props.plant !== undefined) {
            setUpdatedEntity({ ...props.plant });
            fetchBotanicalInfo(props.requestor, props.plant)
                .then(setBotanicalInfo)
                .catch(props.printError);
        } else {
            setUpdatedEntity(undefined);
        }
    }, [props.plant]);

    useEffect(() => {
        if (!props.open) {
            setImageIds([]);
            setEditModeEnabled(false);
            setUpdatedEntity(undefined);
        }
    }, [props.open]);

    return <Drawer
        anchor={"bottom"}
        open={props.open}
        onClose={props.close}
        SlideProps={{
            onScroll: (event: any) => {
                let currentScroll = event.target.scrollTop;
                if (currentScroll < 50) {
                    document.getElementById("plant-header")!.style.height = "70vh";
                } else {
                    document.getElementById("plant-header")!.style.height = "40vh";
                }
            }
        }}
    >

        <PlantImageFullSize
            imgIds={imageIds}
            imgIndex={plantImgFullSizeState?.imgIndex || 0}
            requestor={props.requestor}
            open={plantImgFullSizeState?.open || false}
            printError={props.printError}
            setAvatarImage={setAvatarImage}
            setImageIds={setImageIds}
            avatarImageId={updatedEntity?.avatarMode === "SPECIFIED" ? updatedEntity.avatarImageId : undefined}
            openConfirmDialog={(text: string, callback: () => void) => {
                setConfirmDialogStatus({ text: text, confirmCallBack: callback, open: true });
            }}
            onClose={() => {
                setPlantImgFullSizeState({
                    imgIndex: plantImgFullSizeState?.imgIndex || 0,
                    open: false,
                })
            }}
            onDelete={(imgId: string) => {
                if (props.plant === undefined || updatedEntity === undefined || imgId != updatedEntity.avatarImageId) {
                    return;
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
            height: "100vh",
        }}>
            <PlantHeader
                requestor={props.requestor}
                entity={updatedEntity}
                printError={props.printError}
                closePlantDetails={props.close}
                toggleEditPlantMode={() => {
                    let currentEditModeEnabled = editModeEnabled;
                    setEditModeEnabled(!editModeEnabled);
                    if (!currentEditModeEnabled) {
                        document.getElementById("plant-header")!.style.height = "40vh";
                    } else {
                        document.getElementById("plant-header")!.style.height = "70vh";
                    }
                }}
            />

            <PlantInfo
                plant={updatedEntity}
                open={true}
                editModeEnabled={editModeEnabled}
                printError={props.printError}
                requestor={props.requestor}
                setBotanicalInfoId={setBotanicalInfoId}
                setPersonalName={setPersonalName}
                setNote={setNote}
                setDate={setDate}
                setUseDate={setUseDate}
                plantImgFullSizeState={plantImgFullSizeState}
                setPlantImgFullSizeState={setPlantImgFullSizeState}
                imageIds={imageIds}
                setImageIds={setImageIds}
                setAvatarMode={setAvatarMode}
                setSpeciesThumbnail={setCustomSpeciesThumbnail}
                uploadAndSetSpeciesThumbnail={setNewSpeciesThumbnailToUploadAndUse}
                botanicalInfo={botanicalInfo}
                setNewBotanicalInfoToSave={setNewBotanicalInfoToSave}
                setBotanicalInfoSynonyms={setSynonyms}
                setInfo={setInfo}
            />
            <BottomBar
                openAddLog={props.openAddLogEntry}
                requestor={props.requestor}
                plant={props.plant}
                addUploadedImgs={(arg: string) => {
                    setImageIds([arg, ...imageIds]);
                    if (props.plant !== undefined) {
                        props.onPlantUpdate(props.plant);
                    }
                }}
                printError={props.printError}
                editModeEnabled={editModeEnabled}
                updatedPlant={updatedEntity}
                openConfirmDialog={(text: string, callback: () => void) => {
                    setConfirmDialogStatus({ text: text, confirmCallBack: callback, open: true })
                }}
                toggleEditPlantMode={() => {
                    let currentEditModeEnabled = editModeEnabled;
                    setEditModeEnabled(!editModeEnabled);
                    if (!currentEditModeEnabled) {
                        document.getElementById("plant-header")!.style.height = "40vh";
                    } else {
                        document.getElementById("plant-header")!.style.height = "70vh";
                    }
                }}
                onUpdate={props.onPlantUpdate}
                onDelete={props.onPlantDelete}
                close={props.close}
                newSpeciesThumbnailToUploadAndUse={newSpeciesThumbnailToUploadAndUse}
                botanicalInfo={botanicalInfo}
                changedBotanicalInfo={newBotanicalInfoToSave}
                online={props.online}
            />
        </Box>
    </Drawer>;
}
