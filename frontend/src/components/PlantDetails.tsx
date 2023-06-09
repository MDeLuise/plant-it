import { Box, Button, Drawer, Skeleton, Tab, Tabs, Typography } from "@mui/material";
import { trackedEntity } from "../interfaces";
import ArrowBackIosNewOutlinedIcon from '@mui/icons-material/ArrowBackIosNewOutlined';
import AddAPhotoOutlinedIcon from '@mui/icons-material/AddAPhotoOutlined';
import EventOutlinedIcon from '@mui/icons-material/EventOutlined';
import Link from '@mui/material/Link';
import { useEffect, useState } from "react";
import { AxiosInstance } from "axios";
import { alpha } from "@mui/material";
import { Buffer } from "buffer";
import { Swiper, SwiperSlide } from "swiper/react";
import { Pagination, Virtual, FreeMode } from "swiper";
import "swiper/css";
import "swiper/css/pagination";
import 'swiper/css/virtual';
import "swiper/css/free-mode";

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
    requestor: AxiosInstance;
}) {
    const [loaded, setLoaded] = useState<boolean>(false);
    const [imgBase64, setImgBase64] = useState<string>();

    useEffect(() => {
        props.requestor.get(`/image/${props.imgId}`)
            .then((res) => {
                setImgBase64(res.data.content);
            });
    }, [props.imgId]);

    return (
        <>
            {
                !loaded &&
                <Skeleton
                    variant="rounded"
                    animation="wave"
                    sx={{ width: "100%", height: "100%", zIndex: 1 }}
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
    entity?: trackedEntity,
    addImageBase64: (arg: string) => void;
}) {
    const addEntityImage = (toUpload: File): void => {
        let formData = new FormData();
        formData.append('image', toUpload);
        props.requestor.post(`/image/entity/${props.entity?.id}`, formData)
            .then((_res) => {
                fileToBase64(toUpload).then((base64: string) => {
                    props.addImageBase64(base64);
                });
            });
    };

    const fileToBase64 = (file: File | Blob): Promise<string> =>
        new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onload = () => {
                resolve(reader.result as string);
            };

            reader.readAsDataURL(file);
            reader.onerror = reject;
        });

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
                        backgroundColor: alpha("#efefef", .9),
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
    entity?: trackedEntity;
}) {
    const [imageLoaded, setImageLoaded] = useState<boolean>(false);
    const [checkedImages, setCheckedImages] = useState<boolean>(false);
    const [imageIds, setImageIds] = useState<number[]>([]);
    const [downloadedBotanicalInfoImg, setDownloadedBotanicalInfoImg] = useState<string>();
    const [activeIndex, setActiveIndex] = useState<number>(0);
    let botanicalInfoimgSrc = props.entity?.botanicalInfo.imageUrl != undefined ?
        props.entity?.botanicalInfo.imageUrl :
        props.entity?.botanicalInfo.imageId != undefined ?
            `data:image/png;base64,${downloadedBotanicalInfoImg}` : process.env.PUBLIC_URL + "botanical-info-no-img.png";

    const readBotanicalInfoImage = (): void => {
        props.requestor.get(`/image/${props.entity?.botanicalInfo.imageId}`)
            .then((res) => {
                setDownloadedBotanicalInfoImg(Buffer.from(res.data.content, "utf-8").toString());
                setCheckedImages(true);
            });
    };

    useEffect(() => {
        props.requestor.get(`/image/all/${props.entity?.id}`)
            .then((res) => {
                if (res.data.length === 0 && !props.entity?.botanicalInfo.systemWide) {
                    readBotanicalInfoImage();
                    return;
                }
                setImageIds(res.data.reverse());
                setCheckedImages(true);
            });
    }, [props.entity]);

    return (
        <Box sx={{
            height: "45%",
            overflow: "hidden",
        }}>
            {
                !imageLoaded && !checkedImages &&
                <Skeleton variant="rounded" animation="wave" sx={{ width: "100%", height: "100%", }} />
            }
            {
                imageIds.length === 0 && checkedImages &&
                <img
                    src={botanicalInfoimgSrc}
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
                        imageIds.map((imgId, index) => {
                            return <SwiperSlide key={`slide_${index}`}>
                                <PlantImage
                                    imgId={imgId}
                                    key={index.toString()}
                                    active={index === activeIndex}
                                    requestor={props.requestor}
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
    entity?: trackedEntity,
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
    entity?: trackedEntity,
    requestor: AxiosInstance;
}) {
    const [selectedTab, setSelectedTab] = useState<number>(0);

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
                <PlantHeader requestor={props.requestor} entity={props.entity} />

                <Box sx={{
                    width: "90vw",
                    margin: "0 auto",
                    padding: "10px 0 70px 0",
                }}>

                    <Typography variant="h5" fontWeight={"bold"}>{props.entity?.personalName}</Typography>

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
                    addImageBase64={(arg: string) => {

                    }}
                />
            </Box>
        </Drawer>
    );
}