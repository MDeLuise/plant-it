import { Box, Button, Dialog, DialogActions, DialogContent, DialogContentText, Drawer, Link, Skeleton, Switch, TextField, Typography, useTheme } from "@mui/material";
import { plant } from "../interfaces";
import React, { useEffect, useState } from "react";
import { AxiosInstance } from "axios";
import { Swiper, SwiperSlide } from "swiper/react";
import { Virtual, FreeMode } from "swiper";
import "swiper/css";
import "swiper/css/pagination";
import 'swiper/css/virtual';
import "swiper/css/free-mode";
import "../style/PlantDetails.scss";
import { getBotanicalInfoImg, imgToBase64, titleCase } from "../common";
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


function ConfirmDeleteDialog(props: {
    open: boolean,
    close: () => void,
    printError: (msg: any) => void,
    confirmCallBack: () => void;
}) {
    return <Dialog open={props.open} onClose={props.close}>
        <DialogContent>
            <DialogContentText>
                Are you sure you want to delete the plant? This action can not be undone.
            </DialogContentText>
        </DialogContent>
        <DialogActions>
            <Button onClick={props.close}>Cancel</Button>
            <Button onClick={props.confirmCallBack}>Confirm</Button>
        </DialogActions>
    </Dialog>;
}


function PlantImage(props: {
    imgId: string,
    active: boolean,
    requestor: AxiosInstance,
    imgKey: string,
    printError: (err: any) => void;
}) {
    const [loaded, setLoaded] = useState<boolean>(false);
    const [imgBase64, setImgBase64] = useState<string>();

    const getImgBase64 = (): void => {
        props.requestor.get(`/image/content/${props.imgId}`)
            .then((res) => {
                setImgBase64(res.data);
                setLoaded(true);
            })
            .catch((err) => {
                props.printError(err);
                getBotanicalInfoImg(props.requestor, undefined)
                    .then((res) => {
                        imgToBase64(res, (arg: string) => {
                            setImgBase64(arg);
                            setLoaded(true);
                        });
                    })
                    .catch((err) => {
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
                !loaded &&
                <Skeleton
                    variant="rounded"
                    animation="wave"
                    sx={{
                        width: "100%",
                        height: "100%",
                        zIndex: 1
                    }}
                />
            }
            {
                props.active &&
                <img
                    src={`data:image/png;base64,${imgBase64}`}
                    style={{
                        width: "100%",
                        height: "100%",
                        objectFit: "cover",
                        zIndex: "200",
                    }}
                    onLoad={() => { setLoaded(true); }}
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
    bufferUploadedImgsIds: string[],
    toggleEditPlantMode: () => void,
    closePlantDetails: () => void,
    setImagesCount: (arg: number) => void;
}) {
    const [imageLoaded, setImageLoaded] = useState<boolean>(false);
    const [checkedImages, setCheckedImages] = useState<boolean>(false);
    const [imageIds, setImageIds] = useState<string[]>([]);
    const [activeIndex, setActiveIndex] = useState<number>(0);
    const [imageSrc, setImageSrc] = useState<string>();
    const [swiperInstance, setSwiperInstance] = useState<any>();

    useEffect(() => {
        if (props.entity === undefined) {
            return;
        }

        props.requestor.get(`/image/entity/all/${props.entity?.id}`)
            .then((res) => {
                props.setImagesCount(res.data.length);
                if (res.data.length === 0) {
                    getBotanicalInfoImg(props.requestor, props.entity?.botanicalInfo.imageUrl)
                        .then(res => {
                            setImageSrc(res);
                            setCheckedImages(true);
                        })
                        .catch(err => {
                            getBotanicalInfoImg(props.requestor, undefined)
                                .then(res => {
                                    console.error(err);
                                    setImageSrc(res);
                                    setCheckedImages(true);
                                    props.printError(`Cannot load image for botanical info "${props.entity?.botanicalInfo.scientificName}"`);
                                })
                                .catch(err => {
                                    console.error(err);
                                    props.printError("Cannot load default image");
                                });
                        });
                    return;
                }
                setImageIds(res.data.reverse());
                setCheckedImages(true);
            })
            .catch((err) => {
                props.printError(err);
            });
    }, [props.entity]);

    useEffect(() => {
        setActiveIndex(0);
        if (swiperInstance != null && props.bufferUploadedImgsIds.length > 1) {
            swiperInstance.slideTo(0);
        }
    }, [props.bufferUploadedImgsIds]);

    return (
        <Box
            sx={{
                height: "70vh",
                overflow: "hidden",
                transition: ".5s height"
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
                !imageLoaded && !checkedImages &&
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
                (imageIds.length + props.bufferUploadedImgsIds.length) === 0 &&
                checkedImages &&
                <img
                    src={imageSrc}
                    style={{
                        objectFit: "cover",
                        width: "100%",
                        height: "100%",
                    }}
                    onLoad={() => setImageLoaded(true)}
                />
                ||
                <Swiper
                    slidesPerView={1}
                    spaceBetween={0}
                    centeredSlides={true}
                    modules={[Virtual, FreeMode]}
                    style={{
                        height: "100%",
                    }}
                    onActiveIndexChange={(swiper) => setActiveIndex(swiper.activeIndex)}
                    onSwiper={setSwiperInstance}
                >
                    {
                        props.bufferUploadedImgsIds.map((imgId, index) => {
                            return <SwiperSlide key={`slide_${imgId}`}>
                                <PlantImage
                                    imgId={imgId}
                                    imgKey={imgId}
                                    active={index === activeIndex}
                                    requestor={props.requestor}
                                    printError={props.printError}
                                />
                            </SwiperSlide>;
                        })
                    }
                    {
                        imageIds.map((imgId, index) => {
                            return <SwiperSlide key={`slide_${imgId}`}>
                                <PlantImage
                                    imgId={imgId}
                                    imgKey={imgId}
                                    active={(index + props.bufferUploadedImgsIds.length) === activeIndex}
                                    requestor={props.requestor}
                                    printError={props.printError}
                                />
                            </SwiperSlide>;
                        })
                    }
                </Swiper>
            }
        </Box>
    );
}


function EditableTextField(props: {
    editable: boolean,
    text?: string;
    onChange?: (arg: string) => void,
    variant?: "body1" | "h6",
    style?: {};
}) {
    const [value, setValue] = useState<string>(props.text || "");

    useEffect(() => {
        setValue(props.text || "");
    }, [props.text]);

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
                ...props.style,
                color: "black",
            }}
        />
        :
        <Typography sx={{ ...props.style }} variant={props.variant}>
            {props.text}
        </Typography>;
}




function ReadMoreReadLess(props: {
    text: string,
    size: number;
}) {
    const [expanded, setExpanded] = useState<boolean>(false);

    return (
        <Box sx={{ width: "100%", }}>
            {
                <Typography
                    sx={{
                        border: "1px solid #b4b4b4",
                        borderRadius: "10px",
                        padding: "16.5px 14px",
                        whiteSpace: "pre-line",
                    }}
                >
                    {
                        props.text.length > props.size && !expanded &&
                        props.text.substring(0, props.size) + "…" ||
                        props.text + " "
                    }
                    {
                        props.text.length > props.size && " " &&
                        <Link onClick={() => { setExpanded(!expanded); }}>
                            {expanded ? "Read less" : "Read more"}
                        </Link>
                    }
                </Typography>
            }
        </Box>);
}


function PlantInfo(props: {
    requestor: AxiosInstance,
    plant?: plant,
    editModeEnabled: boolean,
    printError: (arg: any) => void,
    imagesCount: number,
    setFamily: (arg: string) => void,
    setGenus: (arg: string) => void,
    setSpecies: (arg: string) => void,
    setPersonalName: (arg: string) => void,
    setNote: (arg: string) => void,
    setDate: (arg: Date) => void,
    setUseDate: (arg: boolean) => void;
}) {
    const [diaryEntryStats, setDiaryEntryStats] = useState<any[]>([]);
    const [plantStats, setPlantStats] = useState<{
        photos?: number,
        events?: number;
    }>({});
    const [useDate, setUseDate] = useState<boolean>(true);

    useEffect(() => {
        if (props.plant === undefined) {
            return;
        }

        setUseDate(props.plant.startDate !== undefined);
        props.requestor.get(`diary/entry/${props.plant?.id}/stats`)
            .then(res => {
                setDiaryEntryStats(res.data);
            })
            .catch(err => {
                props.printError(err);
            });
        fetchAndSetPlantStats();
    }, [props.plant]);


    const fetchAndSetPlantStats = (): void => {
        props.requestor.get(`diary/entry/${props.plant?.id}/_count`)
            .then(res => {
                setPlantStats({ ...plantStats, events: res.data });
            })
            .catch(err => props.printError(err));
    };

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
                }}
            >
                <EditableTextField
                    editable={props.editModeEnabled}
                    text={props.plant?.personalName}
                    variant="h6"
                    style={{ fontWeight: "bold" }}
                    onChange={props.setPersonalName}
                />
                {
                    props.editModeEnabled ||
                    <Typography>
                        {props.plant?.botanicalInfo.species}
                    </Typography>
                }
            </Box>

            {/* <FavoriteBorderOutlinedIcon /> */}
        </Box>

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
                    text={props.plant?.botanicalInfo.family}
                    editable={props.editModeEnabled}
                    onChange={props.setFamily}
                />
            </Box>
            <Box className="plant-detail-entry">
                <Typography>
                    Genus
                </Typography>
                <EditableTextField
                    text={props.plant?.botanicalInfo.genus}
                    editable={props.editModeEnabled}
                    onChange={props.setGenus}
                />
            </Box>
            <Box className="plant-detail-entry">
                <Typography>
                    Species
                </Typography>
                <EditableTextField
                    text={props.plant?.botanicalInfo.species}
                    editable={props.editModeEnabled}
                    onChange={props.setSpecies}
                />
            </Box>
            {/* <Box className="plant-detail-entry">
                <Typography>
                    Thumbnail
                </Typography>
                <EditableThumbnail
                    editable={props.editModeEnabled}
                    text={props.plant?.botanicalInfo.imageUrl}
                />
            </Box> */}
        </Box>

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
                    props.editModeEnabled || (props.plant?.startDate !== null) ?
                        <LocalizationProvider dateAdapter={AdapterDayjs}>
                            <DatePicker
                                value={dayjs(props.plant?.startDate || new Date())}
                                readOnly={!props.editModeEnabled}
                                disabled={!useDate}
                                onChange={newValue => props.setDate(newValue != undefined ? newValue.toDate() : new Date())}
                                slotProps={{ textField: { variant: 'standard', } }}
                            />
                        </LocalizationProvider>
                        :
                        <Typography>-</Typography>
                }
            </Box>
            <Box className="plant-detail-entry" style={{ flexDirection: "column" }}>
                <Typography>
                    Note
                </Typography>
                {
                    props.editModeEnabled ?
                        <TextField
                            fullWidth
                            multiline
                            defaultValue={props.plant?.note}
                            rows={4}
                            onChange={e => props.setNote(e.currentTarget.value)}
                        />
                        :
                        <ReadMoreReadLess
                            text={props.plant?.note || ""}
                            size={50}
                        />
                }
            </Box>
            {/* <Box className="plant-detail-entry">
                <Typography>
                    Thumbnail
                </Typography>
                <EditableThumbnail
                    editable={props.editModeEnabled}
                    text={props.plant?.botanicalInfo.imageUrl}
                />
            </Box> */}
        </Box>

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
                    {props.imagesCount}
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
                        props.plant?.startDate &&
                        Math.floor(((new Date()).getTime() - new Date(props.plant?.startDate).getTime()) / (1000 * 3600 * 24))
                        || "-"
                    }
                </Typography>
            </Box>
        </Box>

        <Box
            className="plant-detail-section">
            <Typography variant="h6">
                Events stats
            </Typography>
            {
                diaryEntryStats.map((value: { type: string, date: Date; }) => {
                    return <Box style={{
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
    </Box>;
}

function BottomBar(props: {
    requestor: AxiosInstance,
    openAddLog: () => void,
    plant?: plant,
    addUploadedImgs: (arg: string) => void,
    printError: (err: any) => void,
    editModeEnabled: boolean,
    toggleEditPlantMode: () => void,
    updatedPlant?: plant,
    onUpdate: (arg: plant) => void,
    onDelete: (arg: plant) => void;
    close: () => void;
}) {
    const [openConformDialog, setOpenConfirmDialog] = useState<boolean>(false);

    const updatePlant = (): void => {
        props.requestor.put("/plant", props.updatedPlant)
            .then(res => {
                props.onUpdate(res.data);
                props.close();
            })
            .catch(err => {
                props.printError(err);
            });
    };

    const deletePlant = (): void => {
        props.requestor.delete(`plant/${props.plant?.id}`)
            .then((_res) => {
                props.onDelete(props.plant!);
                props.close();
            })
            .catch((err) => {
                props.printError(err);
            });
    };

    const addEntityImage = (toUpload: File): void => {
        let formData = new FormData();
        formData.append('image', toUpload);
        props.requestor.post(`/image/entity/${props.plant?.id}`, formData)
            .then(res => {
                props.addUploadedImgs(res.data);
            })
            .catch(err => {
                props.printError(err);
            });
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

        <ConfirmDeleteDialog
            open={openConformDialog}
            close={() => setOpenConfirmDialog(false)}
            printError={props.printError}
            confirmCallBack={deletePlant}
        />

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
                        onClick={() => setOpenConfirmDialog(true)}
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
                        onChange={event => {
                            if (event.target.files != undefined) {
                                addEntityImage(event.target.files[0]);
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
    onUpdate: (arg: plant) => void,
    onDelete: (arg: plant) => void;
}) {
    const [bufferUploadedImgsIds, setBufferedUploadedImgsIds] = useState<string[]>([]);
    const [editModeEnabled, setEditModeEnabled] = useState<boolean>(false);
    const [updatedEntity, setUpdatedEntity] = useState<plant>();
    const [imagesCount, setImagesCount] = useState<number>(0);

    const setFamily = (arg: string): void => {
        if (updatedEntity === undefined) {
            return;
        }
        updatedEntity.botanicalInfo.family = arg;
    };

    const setGenus = (arg: string): void => {
        if (updatedEntity === undefined) {
            return;
        }
        updatedEntity.botanicalInfo.genus = arg;
    };

    const setSpecies = (arg: string): void => {
        if (updatedEntity === undefined) {
            return;
        }
        updatedEntity.botanicalInfo.species = arg;
        updatedEntity.botanicalInfo.scientificName = arg;
    };

    const setPersonalName = (arg: string): void => {
        if (updatedEntity === undefined) {
            return;
        }
        updatedEntity.personalName = arg;
    };

    const setNote = (arg: string): void => {
        console.debug(arg);
        if (updatedEntity === undefined) {
            return;
        }
        updatedEntity.note = arg;
    };

    const setDate = (arg: Date): void => {
        if (updatedEntity === undefined) {
            return;
        }
        updatedEntity.startDate = arg;
    };

    const setUseDate = (arg: boolean): void => {
        if (updatedEntity === undefined) {
            return;
        }
        if (!arg) {
            updatedEntity.startDate = undefined;
        }
    };

    useEffect(() => {
        if (props.plant !== undefined) {
            setUpdatedEntity({ ...props.plant });
        } else {
            setUpdatedEntity(undefined);
        }
    }, [props.plant]);

    useEffect(() => {
        setBufferedUploadedImgsIds([]);
        if (!props.open) {
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
                //console.debug(currentScroll)
                if (currentScroll < 50) {
                    document.getElementById("plant-header")!.style.height = "70vh";
                } else {
                    document.getElementById("plant-header")!.style.height = "40vh";
                }
            }
        }}
    >

        <Box>
            <PlantHeader
                requestor={props.requestor}
                entity={updatedEntity}
                printError={props.printError}
                bufferUploadedImgsIds={bufferUploadedImgsIds}
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
                setImagesCount={setImagesCount}
            />
            <PlantInfo
                plant={updatedEntity}
                editModeEnabled={editModeEnabled}
                printError={props.printError}
                requestor={props.requestor}
                imagesCount={imagesCount}
                setFamily={setFamily}
                setGenus={setGenus}
                setSpecies={setSpecies}
                setPersonalName={setPersonalName}
                setNote={setNote}
                setDate={setDate}
                setUseDate={setUseDate}
            />
            <BottomBar
                openAddLog={props.openAddLogEntry}
                requestor={props.requestor}
                plant={props.plant}
                addUploadedImgs={(arg: string) => {
                    setImagesCount(imagesCount + 1);
                    setBufferedUploadedImgsIds([arg, ...bufferUploadedImgsIds]);
                }}
                printError={props.printError}
                editModeEnabled={editModeEnabled}
                updatedPlant={updatedEntity}
                toggleEditPlantMode={() => {
                    let currentEditModeEnabled = editModeEnabled;
                    setEditModeEnabled(!editModeEnabled);

                    if (!currentEditModeEnabled) {
                        document.getElementById("plant-header")!.style.height = "40vh";
                    } else {
                        document.getElementById("plant-header")!.style.height = "70vh";
                    }
                }}
                onUpdate={props.onUpdate}
                onDelete={props.onDelete}
                close={props.close}
            />
        </Box>
    </Drawer>;
}