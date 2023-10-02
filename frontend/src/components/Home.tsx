import { AxiosError, AxiosInstance } from "axios";
import React, { useEffect, useState } from "react";
import { NavigateFunction, useNavigate } from "react-router-dom";
import { Avatar, Box, InputAdornment, OutlinedInput, Typography } from "@mui/material";
import { diaryEntry, plant } from "../interfaces";
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
import Settings from "./Settings";
import secureLocalStorage from "react-secure-storage";
import EditEvent from "./EditEvent";
import { getErrMessage, isBackendReachable } from "../common";
import ErrorDialog from "./ErrorDialog";
import AddLogEntry from "./AddLogEntry";
import PlantDetails from "./PlantDetails";
import UserPlant from "./UserPlant";
import NewLogEntry from "./LogEntry";


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
            {/* <NotificationsOutlinedIcon /> */}
        </Box>
    );
}

function UserPlantsList(props: {
    requestor: AxiosInstance,
    plants: plant[],
    gotoDetails: (arg: plant) => void,
    printError: (err: AxiosError) => void;
}) {
    const [plantName, setPlantName] = useState<string>("");
    const [activeIndex, setActiveIndex] = useState<number>(0);

    return (
        <Box>
            <Box sx={{
                display: "flex",
                alignItems: "center",
            }}>
                <Typography variant="body1" style={{ fontWeight: 600 }}>Your plants</Typography>
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
                slidesPerView={"auto"}
                spaceBetween={30}
                centeredSlides={true}
                onActiveIndexChange={(swiper) => setActiveIndex(swiper.activeIndex)}
            >
                {
                    props.plants.filter(
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
                                    active={Math.abs(activeIndex - index) <= 1}
                                    printError={props.printError}
                                />
                            </SwiperSlide>;
                        })
                }
            </Swiper>
        </Box>
    );
}


function DiaryEntriesList(props: {
    logEntries: diaryEntry[],
    editEvent: (arg: diaryEntry) => void;
}) {

    return (
        <Box sx={{ marginTop: "10px" }}>
            <Typography
                variant="body1"
                style={{
                    fontWeight: 600,
                    marginBottom: "10px"
                }}>
                Your diary
            </Typography>
            <Box sx={{
                display: "flex",
                flexDirection: "column",
                gap: "20px",
            }}>
                {
                    props.logEntries.slice(0, 5).map((entity) => {
                        return <NewLogEntry
                            entity={entity}
                            key={entity.id}
                            editEvent={() => props.editEvent(entity)}
                        />;
                    })
                }
            </Box>
        </Box>
    );
}


export default function Home(props: { isLoggedIn: () => boolean, requestor: AxiosInstance; }) {
    let navigate: NavigateFunction = useNavigate();
    const logPageSize = 5;
    const [plants, setPlants] = useState<plant[]>([]);
    const [logEntries, setLogEntries] = useState<diaryEntry[]>([]);
    const [activeTab, setActiveTab] = useState<number>(0);
    const [allEventTypes, setAllEventTypes] = useState<string[]>([]);
    const [editEventVisible, setEditEventVisible] = useState<boolean>(false);
    const [eventToEdit, setEventToEdit] = useState<diaryEntry>();
    const [plantDetails, setPlantDetails] = useState<{ plant?: plant, open: boolean; }>({ open: false });
    const [addDiaryLogOpen, setAddDiaryLogOpen] = useState<boolean>(false);
    const [errorDialogShown, setErrorDialogShown] = useState<boolean>(false);
    const [errorDialogText, setErrorDialogText] = useState<string>();

    const getAllEntities = (): void => {
        props.requestor.get("plant/_count")
            .then(res => {
                let entitiesSize = res.data > 0 ? res.data : 1;
                getEntities(entitiesSize);
            })
            .catch(printError);
    };

    const getEntities = (count: number): void => {
        props.requestor.get(`plant?sortBy=personalName&sortDir=ASC&pageSize=${count}`)
            .then(res => {
                let newEntities: plant[] = [];
                res.data.content.forEach((en: plant) => {
                    newEntities.push(en);
                });
                setPlants(newEntities);
            })
            .catch(printError);
    };

    const getLog = (): void => {
        props.requestor.get(`/diary/entry?pageSize=${logPageSize}`)
            .then(res => {
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
            })
            .catch(printError);
    };

    const getDiaryEvents = (): void => {
        props.requestor.get("diary/entry/type")
            .then(res => {
                setAllEventTypes(res.data.sort());
            })
            .catch(printError);
    };


    const printError = (err: any) => {
        setErrorDialogText(getErrMessage(err));
        setErrorDialogShown(true);
    };


    const updatePlantFetchedCopy = (updated: plant) => {
        const indexToUpdate: number = plants.map(pl => pl.id).indexOf(updated.id);
        //plants[indexToUpdate] = updated;
        const updatedPlants = [...plants];
        updatedPlants[indexToUpdate] = updated;
        setPlants(updatedPlants);
    };


    const deletePlantFetchedCopy = (deleted?: plant) => {
        if (deleted === undefined) {
            return;
        }
        const indexToRemove: number = plants.map(pl => pl.id).indexOf(deleted.id);
        const updatedPlants = [...plants];
        updatedPlants.splice(indexToRemove, 1);
        setPlants(updatedPlants);
    };


    const updateEventFetchedCopy = (updatedPlant: plant) => {
        const newLogEntries: diaryEntry[] = [...logEntries];
        newLogEntries.forEach(event => {
            if (event.diaryTargetId === updatedPlant.id) {
                event.diaryTargetPersonalName = updatedPlant.personalName;
            }
        });
        setLogEntries(newLogEntries);
    };


    const deleteEventFetchedCopy = (deletedPlant?: plant) => {
        if (deletedPlant === undefined) {
            return;
        }
        const newLogEntries: diaryEntry[] = logEntries.filter((ev) => ev.diaryTargetId !== deletedPlant.id);
        setLogEntries(newLogEntries);
    };

    useEffect(() => {
        if (!props.isLoggedIn()) {
            navigate("/auth");
        } else {
            isBackendReachable(props.requestor)
                .then(res => {
                    if (!res) {
                        setErrorDialogText("Cannot connect to the backend");
                        setErrorDialogShown(true);
                    }
                });
            getDiaryEvents();
            getAllEntities();
            getLog();
        }
    }, []);

    if (!props.isLoggedIn()) {
        return <></>;
    }

    const allLogsComponent: React.JSX.Element = <AllLogs
        requestor={props.requestor}
        entries={logEntries}
        eventTypes={allEventTypes}
        plants={plants}
        openEditEvent={(arg: diaryEntry) => {
            setEventToEdit(arg);
            setEditEventVisible(true);
        }}
        printError={printError}
        active={activeTab == 1}
    />;

    const addLogEntryComponent: React.JSX.Element = <AddLogEntry
        requestor={props.requestor}
        eventTypes={allEventTypes}
        plants={plants}
        open={addDiaryLogOpen}
        setOpen={setAddDiaryLogOpen}
        updateLog={(arg: diaryEntry) => {
            // https://www.digitalocean.com/community/tutorials/react-getting-atomic-updates-with-setstate
            setLogEntries((prevState) => ([arg, ...prevState]));
        }}
        addForPlant={plantDetails.plant}
        onClose={() => {
            if (plantDetails.plant !== undefined) {
                setPlantDetails({ ...plantDetails, plant: { ...plantDetails.plant } });
            }
        }} // just to live update the plant info section in Plant Details
    />;

    return (
        <>
            <ErrorDialog
                text={errorDialogText}
                open={errorDialogShown}
                close={() => setErrorDialogShown(false)}
            />

            {addLogEntryComponent}

            <EditEvent
                requestor={props.requestor}
                plants={plants}
                eventTypes={allEventTypes}
                open={editEventVisible}
                setOpen={(arg: boolean) => setEditEventVisible(arg)}
                updateLog={(arg: diaryEntry) => {
                    let newLogEntry = [arg, ...logEntries.filter((a) => a.id !== arg.id)];
                    newLogEntry.sort((a, b) => {
                        return new Date(b.date).getTime() - new Date(a.date).getTime();
                    });
                    setLogEntries(newLogEntry);
                }}
                removeFromLog={(diaryEntryId: number) => {
                    let newLogEntries = [...logEntries].filter((en) => en.id !== diaryEntryId);
                    setLogEntries(newLogEntries);
                }}
                toEdit={eventToEdit}
                printError={printError}
            />

            <PlantDetails
                open={plantDetails.open}
                close={() => setPlantDetails({ plant: undefined, open: false })}
                plant={plantDetails.plant}
                requestor={props.requestor}
                printError={printError}
                openAddLogEntry={() => setAddDiaryLogOpen(true)}
                onUpdate={updated => {
                    updatePlantFetchedCopy(updated);
                    updateEventFetchedCopy(updated);
                }}
                onDelete={deleted => {
                    deletePlantFetchedCopy(deleted);
                    deleteEventFetchedCopy(deleted);
                }}
            />

            <Box sx={{ pb: 7, width: "90%", margin: "40px auto" }}>

                <Box sx={{ display: activeTab === 0 ? "visible" : "none" }}>
                    <UserTopBar />

                    <UserPlantsList
                        requestor={props.requestor}
                        plants={plants}
                        gotoDetails={(arg: plant) => {
                            setPlantDetails({ plant: arg, open: true });
                        }}
                        printError={printError}
                    />

                    <DiaryEntriesList
                        logEntries={logEntries}
                        editEvent={(arg: diaryEntry) => {
                            setEditEventVisible(true);
                            setEventToEdit(arg);
                        }}
                    />
                </Box>

                <Box sx={{ display: activeTab === 1 ? "visible" : "none" }}>
                    {allLogsComponent}
                </Box>

                <Box sx={{ display: activeTab === 2 ? "visible" : "none" }}>
                    <SearchPage
                        requestor={props.requestor}
                        plants={plants}
                        printError={printError}
                    />
                </Box>

                <Box sx={{ display: activeTab === 3 ? "visible" : "none" }}>
                    <Settings
                        requestor={props.requestor}
                        visibility={activeTab === 3}
                        printError={printError}
                    />
                </Box>
            </Box>

            <BottomBar
                activeTab={activeTab}
                setActiveTab={setActiveTab}
                requestor={props.requestor}
                openAddLogEntry={() => setAddDiaryLogOpen(true)}
            />
        </>
    );
}
