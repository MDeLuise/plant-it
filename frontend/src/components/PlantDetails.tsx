import { Box, Button, Drawer, Skeleton, Tab, Tabs, Typography } from "@mui/material";
import { plant } from "../interfaces";
import ArrowBackIosNewOutlinedIcon from '@mui/icons-material/ArrowBackIosNewOutlined';
import AddAPhotoOutlinedIcon from '@mui/icons-material/AddAPhotoOutlined';
import EventOutlinedIcon from '@mui/icons-material/EventOutlined';
import Link from '@mui/material/Link';
import { useEffect, useState } from "react";
import { AxiosInstance } from "axios";
import { alpha } from "@mui/material";
import { Swiper, SwiperSlide } from "swiper/react";
import { Pagination, Virtual, FreeMode } from "swiper";
import "swiper/css";
import "swiper/css/pagination";
import 'swiper/css/virtual';
import "swiper/css/free-mode";
import { getBotanicalInfoImg } from "../common";

function AllPlantLog(props: {
    requestor: AxiosInstance,

}) {
    return (
        <>
        </>
    );
};


function PlantImage(props: {
    imgId: number,
    key: string,
    active: boolean,
    requestor: AxiosInstance,
    printError: (err: any) => void;
}) {
    const [loaded, setLoaded] = useState<boolean>(false);
    const [imgBase64, setImgBase64] = useState<string>();

    useEffect(() => {
        props.requestor.get(`/image/content/${props.imgId}`)
            .then((res) => {
                setImgBase64(res.data);
            })
            .catch((err) => {
                props.printError(err);
            });
    }, [props.imgId]);

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
                props.active && imgBase64 != undefined &&
                <img
                    key={props.key}
                    src={`data:image/png;base64,${imgBase64}`}
                    style={{
                        width: "100%",
                        height: "100%",
                        objectFit: "cover",
                    }}
                    onLoad={() => { setLoaded(true); }}
                    loading="lazy"
                />
            }
        </>);
}

function Bottombar(props: {
    requestor: AxiosInstance,
    visible: boolean,
    entity?: plant,
    addUploadedImgs: (arg: number) => void,
    printError: (err: any) => void;
}) {
    const addEntityImage = (toUpload: File): void => {
        let formData = new FormData();
        formData.append('image', toUpload);
        props.requestor.post(`/image/entity/${props.entity?.id}`, formData)
            .then((res) => {
                props.addUploadedImgs(res.data);
            })
            .catch((err) => {
                props.printError(err);
            });
    };

    return (
        <>
            <input
                id="upload-image"
                type="file"
                accept="image/*"
                hidden
                onChange={(event) => {
                    if (event.target.files != undefined) {
                        addEntityImage(event.target.files[0]);
                    }
                }}
            />
            <Box sx={{
                width: "100vw",
                flexGrow: 1,
                display: props.visible ? "flex" : "none",
                justifyContent: "space-evenly",
                alignItems: "flex-end",
                position: "fixed",
                bottom: "10px",
                padding: "15px",
            }}>
                <Button
                    sx={{
                        width: "45%",
                        borderRadius: "15px",
                        backgroundColor: alpha("#efefef", .9),
                        padding: "15px",
                    }}
                    startIcon={<EventOutlinedIcon />}
                >
                    Add event
                </Button>
                <Button
                    sx={{
                        width: "45%",
                        borderRadius: "15px",
                        backgroundColor: alpha("#efefef", .9) + " !important",
                        padding: "15px",
                    }}
                    onClick={() => {
                        document.getElementById("upload-image")?.click();
                    }}
                    startIcon={<AddAPhotoOutlinedIcon />}
                >
                    Add photo
                </Button>
            </Box>
        </>
    );
};

function ReadMoreReadLess(props: {
    text: string,
    size: number;
}) {
    const [expanded, setExpanded] = useState<boolean>(false);

    return (
        <>
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
        </>);
}

function PlantHeader(props: {
    requestor: AxiosInstance,
    entity?: plant,
    printError: (err: any) => void,
    bufferUploadedImgsIds: number[],
}) {
    const [imageLoaded, setImageLoaded] = useState<boolean>(false);
    const [checkedImages, setCheckedImages] = useState<boolean>(false);
    const [imageIds, setImageIds] = useState<number[]>([]);
    const [activeIndex, setActiveIndex] = useState<number>(0);
    const [imageSrc, setImageSrc] = useState<string>();

    useEffect(() => {
        props.requestor.get(`/image/entity/all/${props.entity?.id}`)
            .then((res) => {
                if (res.data.length === 0) {
                    getBotanicalInfoImg(props.requestor, props.entity?.botanicalInfo.imageUrl)
                        .then(res => {
                            setImageSrc(res);
                            setCheckedImages(true);
                        })
                        .catch((err) => {
                            props.printError(err);
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

    return (
        <Box sx={{
            height: "45%",
            overflow: "hidden",
        }}>
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
                imageIds.length === 0 && checkedImages &&
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
                    pagination={{
                        clickable: true,
                        dynamicBullets: true,
                    }}
                    modules={[Pagination, Virtual, FreeMode]}
                    style={{
                        height: "100%",
                    }}
                    onActiveIndexChange={(swiper) => setActiveIndex(swiper.activeIndex)}
                >
                    {
                        props.bufferUploadedImgsIds.map((imgId, index) => {
                            return <SwiperSlide key={`slide_${index}`}>
                                <PlantImage
                                    imgId={imgId}
                                    key={index.toString()}
                                    active={index === activeIndex}
                                    requestor={props.requestor}
                                    printError={props.printError}
                                />
                            </SwiperSlide>;
                        })
                    }
                    {
                        imageIds.map((imgId, index) => {
                            return <SwiperSlide key={`slide_${(index + props.bufferUploadedImgsIds.length)}`}>
                                <PlantImage
                                    imgId={imgId}
                                    key={(index + props.bufferUploadedImgsIds.length).toString()}
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

function PlantOverview(props: {
    entity?: plant,
    visible: boolean;
}) {
    return (
        <Box
            sx={{
                visibility: props.visible ? "visible" : "hidden",
                display: "flex",
                flexDirection: "column",
                gap: "20px",
                marginTop: "20px",
            }} >
            <Typography variant="body1" fontWeight={"bold"}>
                Botanical info
            </Typography>
            <Box sx={{
                display: "flex",
                justifyContent: "center",
                gap: "20px",
            }}>
                <Box>
                    <Typography variant="body1" fontWeight={"bold"}>Family</Typography>
                    <Typography variant="body2">
                        {props.entity?.botanicalInfo.family != undefined ?
                            props.entity?.botanicalInfo.family : "-"}
                    </Typography>
                </Box>
                <Box sx={{ borderRight: "1px solid grey" }} />
                <Box>
                    <Typography variant="body1" fontWeight={"bold"}>Genus</Typography>
                    <Typography variant="body2">
                        {props.entity?.botanicalInfo.genus != undefined ?
                            props.entity?.botanicalInfo.genus : "-"}
                    </Typography>
                </Box>
                <Box sx={{ borderRight: "1px solid grey" }} />
                <Box>
                    <Typography variant="body1" fontWeight={"bold"}>Species</Typography>
                    <Typography variant="body2">
                        {props.entity?.botanicalInfo.species != undefined ?
                            props.entity?.botanicalInfo.species : "-"}
                    </Typography>
                </Box>
            </Box>

            <Box>
                <Typography variant="body1" fontWeight={"bold"}>
                    Note
                </Typography>
                <ReadMoreReadLess
                    text={props.entity?.note != undefined ? props.entity?.note : "-"}
                    size={150}
                />
            </Box>
        </Box>
    );
}

export default function PlantDetails(props: {
    open: boolean,
    close: () => void;
    entity?: plant,
    requestor: AxiosInstance,
    printError: (err: any) => void;
}) {
    const [selectedTab, setSelectedTab] = useState<number>(0);
    const [bufferUploadedImgsIds, setBufferedUploadedImgsIds] = useState<number[]>([]);

    useEffect(() => {
        setBufferedUploadedImgsIds([]);
    }, [props.open]);

    return (
        <Drawer
            anchor={"bottom"}
            open={props.open}
            onClose={props.close}
        >

            <Box
                sx={{
                    position: "fixed",
                    top: "10px",
                    left: "10px",
                    backdropFilter: "blur(10px)",
                    color: "white",
                    borderRadius: "50%",
                    zIndex: 2,
                    padding: "5px",
                }}
                onClick={props.close}
            >
                <ArrowBackIosNewOutlinedIcon />
            </Box>

            <Box sx={{
                height: "100vh",
            }}>
                <PlantHeader
                    requestor={props.requestor}
                    entity={props.entity}
                    printError={props.printError}
                    bufferUploadedImgsIds={bufferUploadedImgsIds}
                />

                <Box sx={{
                    width: "90vw",
                    margin: "0 auto",
                    padding: "10px 0 70px 0",
                }}>

                    <Typography
                        variant="h5"
                        fontWeight={"bold"}>
                        {props.entity?.personalName}
                    </Typography>

                    <Tabs
                        value={selectedTab}
                        onChange={(_e, newValue) => setSelectedTab(newValue)}
                        centered
                        variant="fullWidth"
                        sx={{
                            marginTop: "10px",
                            backgroundColor: "background.default",
                            borderRadius: "15px",
                            padding: "8px",
                            '& .MuiTab-root': {
                                borderRadius: "10px",
                            },
                            '& .MuiTabs-indicator': {
                                height: "100%",
                                width: "100%",
                                backgroundColor: "background.paper",
                                color: "red",
                                borderRadius: "10px",
                                zIndex: 1,
                            },
                            '& .Mui-selected': {
                                color: "primary.main",
                                zIndex: 2,
                                fontWeight: "bold",
                            },
                        }}>
                        <Tab label="Overview" />
                        <Tab label="Events" />
                    </Tabs>

                    <PlantOverview entity={props.entity} visible={selectedTab === 0} />
                </Box>
                <Bottombar
                    requestor={props.requestor}
                    visible={selectedTab === 0}
                    entity={props.entity}
                    addUploadedImgs={(arg: number) => {
                        setBufferedUploadedImgsIds([arg, ...bufferUploadedImgsIds]);
                    }}
                    printError={props.printError}
                />
            </Box>
        </Drawer>
    );
}