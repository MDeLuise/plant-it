import { AxiosInstance } from "axios";
import { useEffect, useState } from "react";
import { NavigateFunction, useNavigate } from "react-router-dom";
import { Avatar, Box, InputAdornment, Link, OutlinedInput, Typography } from "@mui/material";
import { diaryEntry, trackedEntity } from "../interfaces";
import UserPlant from "./UserPlant";
import NotificationsOutlinedIcon from '@mui/icons-material/NotificationsOutlined';
import SearchOutlinedIcon from '@mui/icons-material/SearchOutlined';
import CloseOutlinedIcon from '@mui/icons-material/CloseOutlined';
import SearchPage from "./SearchPage";
import BottomBar from "./BottomBar";
import { Swiper, SwiperSlide } from "swiper/react";
import { Pagination, Virtual, FreeMode } from "swiper";
import "swiper/css";
import "swiper/css/pagination";
import 'swiper/css/virtual';
import "swiper/css/free-mode";
import AllLogs from "./AllLogs";
import LogEntry from "./LogEntry";
import Settings from "./Settings";
import secureLocalStorage from "react-secure-storage";
import EditEvent from "./EditEvent";
import PlantDetails from "./PlantDetails";


function UserTopBar(props: {}) {
    const username = secureLocalStorage.getItem("plant-it-username") as string;

    return (
        <Box sx={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
            marginBottom: "30px"
        }}>
            <Box sx={{
                display: "flex",
                gap: "15px"
            }}>
                <Avatar alt={username} src="/static/images/avatar/1.jpg" />
                <Box>
                    <Typography variant="body2">Welcome back</Typography>
                    <Typography variant="body1" style={{ fontWeight: 600 }}>{username} 👋</Typography>
                </Box>
            </Box>
            <NotificationsOutlinedIcon />
        </Box>
    );
}

function UserPlantsList(props: {
    requestor: AxiosInstance,
    trackedEntities: trackedEntity[],
    gotoDetails: (arg: trackedEntity) => void;
}) {
    const [plantName, setPlantName] = useState<string>("");

    return (
        <Box>
            <Box sx={{
                display: "flex",
                alignItems: "center",
            }}>
                <Typography variant="body1" style={{ fontWeight: 600 }}>Your plants</Typography>
                {/* <Box sx={{ flexGrow: 1 }}></Box>
                <Typography variant="body1" mx={.5}><Link href="#">All</Link></Typography>
                <Typography variant="body1" mx={.5}><Link href="#" onClick={() => setAddPlantOpen(true)}>Add</Link></Typography> */}
            </Box>
            <OutlinedInput
                fullWidth
                startAdornment={
                    <InputAdornment position="start" sx={{ opacity: 0.5 }}>
                        <SearchOutlinedIcon />
                    </InputAdornment>
                }
                endAdornment={
                    <InputAdornment position="start" sx={{ opacity: 0.5 }}>
                        <CloseOutlinedIcon
                            sx={{ visibility: plantName === "" ? "hidden" : "initial" }}
                            onClick={() => setPlantName("")}
                        />
                    </InputAdornment>
                }
                placeholder="Search in your plants"
                onChange={(event: React.ChangeEvent<HTMLInputElement>) => setPlantName(event.target.value)}
                value={plantName}
                sx={{
                    margin: "10px 0",
                    backgroundColor: "#eae8e8",
                }}
            />
            <Swiper
                pagination={{
                    dynamicBullets: true,
                    clickable: true,
                }}
                modules={[Pagination, Virtual, FreeMode]}
                className="mySwiper"
                slidesPerView={"auto"}
                spaceBetween={30}
                centeredSlides={true}
            >
                {
                    props.trackedEntities.filter(
                        (en) => en.personalName.toLocaleLowerCase().includes(plantName.toLocaleLowerCase()))
                        .map((entity, index) => {
                            return <SwiperSlide
                                key={entity.id}
                                style={{ width: "45vw" }}
                                virtualIndex={index}
                            >
                                <UserPlant
                                    entity={entity}
                                    key={entity.id}
                                    requestor={props.requestor}
                                    onClick={() => props.gotoDetails(entity)}
                                />
                            </SwiperSlide>;
                        })
                }
            </Swiper>
        </Box >
    );
}


function DiaryEntriesList(props: {
    logEntries: diaryEntry[],
    editEvent: (arg: diaryEntry) => void;
}) {

    return (
        <Box sx={{ marginTop: "20px" }}>
            <Box sx={{
                display: "flex",
                alignItems: "center",
                margin: "10px 0"
            }}>
                <Typography variant="body1" style={{ fontWeight: 600 }}>Your diary</Typography>
                {/* <Box sx={{ flexGrow: 1 }}></Box>
                <Typography variant="body1" mx={.5}><Link href="#">All</Link></Typography>
                <Typography variant="body1" mx={.5}><Link href="#">Add</Link></Typography> */}
            </Box>

            <Box sx={{
                display: "flex",
                flexDirection: "column",
                gap: "20px",
            }}>
                {props.logEntries.slice(0, 5).map((entity) => {
                    return <LogEntry
                        entity={entity}
                        key={entity.id}
                        editEvent={() => props.editEvent(entity)}
                    />;
                })}
            </Box>
        </Box>
    );
}


export default function Home(props: { isLoggedIn: () => boolean, requestor: AxiosInstance; }) {
    let navigate: NavigateFunction = useNavigate();
    const [trackedEntities, setTrackedEntities] = useState<trackedEntity[]>([]);
    const [logEntries, setLogEntries] = useState<diaryEntry[]>([]);
    const [activeTab, setActiveTab] = useState<number>(0);
    const [error, setError] = useState<string>();
    const [allEventTypes, setAllEventTypes] = useState<string[]>([]);
    const logPageSize = 5;
    const [editEventVisible, setEditEventVisible] = useState<boolean>(false);
    const [eventToEdit, setEventToEdit] = useState<diaryEntry>();
    const [plantDetailsOpen, setPlantDetailsOpen] = useState<boolean>(false);
    const [plantDetails, setPlantDetails] = useState<trackedEntity>();

    const getAllEntities = (): void => {
        props.requestor.get("tracked-entity/_count")
            .then((res) => {
                let entitiesSize = res.data > 0 ? res.data : 1;
                getEntities(entitiesSize);
            });
    };

    const getEntities = (count: number): void => {
        props.requestor.get(`tracked-entity?pageSize=${count}`)
            .then((res) => {
                let newEntities: trackedEntity[] = [];
                res.data.content.forEach((en: trackedEntity) => {
                    newEntities.push(en);
                });
                setTrackedEntities(newEntities);
            });
    };

    const getLog = (): void => {
        props.requestor.get(`/diary/entry?pageSize=${logPageSize}`)
            .then((res) => {
                setLogEntries(res.data.content);
                // it should not be necessary, but if omitted the first time the edit event dialog is
                // opened, the plantName and eventType are not loaded. Don't know why.
                if (res.data.content.length > 0) {
                    setEventToEdit(res.data.content[0]);
                } else {
                    setEventToEdit({
                        id: -1,
                        type: "WATERING",
                        note: "This event is a dummy",
                        date: new Date(),
                        diaryId: -1,
                        diaryTargetId: -1,
                        diaryTargetPersonalName: "Foo",
                    } as diaryEntry);
                }
            });
    };

    const getDiaryEvents = (): void => {
        props.requestor.get("diary/entry/type")
            .then((res) => {
                setAllEventTypes(res.data);
            });
    };

    useEffect(() => {
        if (!props.isLoggedIn()) {
            navigate("/auth");
        } else {
            getDiaryEvents();
            getAllEntities();
            getLog();
        }
    }, []);

    if (!props.isLoggedIn()) {
        return <></>;
    }

    return (
        <>
            <EditEvent
                requestor={props.requestor}
                trackedEntities={trackedEntities}
                eventTypes={allEventTypes}
                open={editEventVisible}
                setOpen={(arg: boolean) => setEditEventVisible(arg)}
                updateLog={(arg: diaryEntry) => {
                    setLogEntries([arg, ...logEntries]);
                }}
                removeFromLog={(diaryEntryId: number) => {
                    let newLogEntries = [...logEntries].filter((en) => en.id !== diaryEntryId);
                    setLogEntries(newLogEntries);
                }}
                toEdit={eventToEdit}
            />

            <PlantDetails
                open={plantDetailsOpen}
                close={() => setPlantDetailsOpen(false)}
                entity={plantDetails}
                requestor={props.requestor}
            />

            <Box sx={{ pb: 7, width: "90%", margin: "40px auto" }}>

                <Box sx={{ display: activeTab === 0 ? "visible" : "none" }}>
                    <UserTopBar />

                    <UserPlantsList
                        requestor={props.requestor}
                        trackedEntities={trackedEntities}
                        gotoDetails={(arg: trackedEntity) => {
                            setPlantDetails(arg);
                            setPlantDetailsOpen(true);
                        }}
                    />

                    <DiaryEntriesList
                        logEntries={logEntries}
                        editEvent={(arg: diaryEntry) => {
                            setEditEventVisible(true);
                            setEventToEdit(arg);
                        }} />
                </Box>

                <Box sx={{ display: activeTab === 1 ? "visible" : "none" }}>
                    <AllLogs
                        requestor={props.requestor}
                        entries={logEntries}
                        eventTypes={allEventTypes}
                        trackedEntities={trackedEntities}
                        openEditEvent={(arg: diaryEntry) => {
                            setEventToEdit(arg);
                            setEditEventVisible(true);
                        }}
                    />
                </Box>

                <Box sx={{ display: activeTab === 2 ? "visible" : "none" }}>
                    <SearchPage
                        requestor={props.requestor}
                        trackedEntities={trackedEntities}
                    />
                </Box>

                <Box sx={{ display: activeTab === 3 ? "visible" : "none" }}>
                    <Settings requestor={props.requestor} />
                </Box>
            </Box>

            <BottomBar
                activeTab={activeTab}
                setActiveTab={setActiveTab}
                requestor={props.requestor}
                trackedEntities={trackedEntities}
                eventTypes={allEventTypes}
                updateLogEntries={(arg: diaryEntry) => {
                    // https://www.digitalocean.com/community/tutorials/react-getting-atomic-updates-with-setstate
                    setLogEntries((prevState) => ([arg, ...prevState]));
                }}
            ></BottomBar>
        </>
    );
}
