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
import Flicking, { ViewportSlot } from "@egjs/react-flicking";
import "@egjs/react-flicking/dist/flicking.css";
import { Pagination, Perspective } from "@egjs/flicking-plugins";
import "@egjs/flicking-plugins/dist/pagination.css";
import AllLogs from "./AllLogs";
import LogEntry from "./LogEntry";
import Settings from "./Settings";
import secureLocalStorage from "react-secure-storage";


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
                <Avatar alt="user" src="/static/images/avatar/1.jpg" />
                <Box>
                    <Typography variant="body2">Welcome back</Typography>
                    <Typography variant="body1" style={{ fontWeight: 600 }}>{username} 👋</Typography>
                </Box>
            </Box>
            <NotificationsOutlinedIcon />
        </Box>
    );
}

function UserPlantsList(props: { requestor: AxiosInstance, trackedEntities: trackedEntity[]; }) {
    const [plantName, setPlantName] = useState<string>("");
    const [addPlantOpen, setAddPlantOpen] = useState<boolean>(false);

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
                placeholder="Search your plants"
                onChange={(event: React.ChangeEvent<HTMLInputElement>) => setPlantName(event.target.value)}
                value={plantName}
                sx={{
                    margin: "10px 0",
                    backgroundColor: "#eae8e8"
                }}
            />
            <Flicking
                align="center"
                //bound={true}
                circular={true}
                plugins={[new Perspective({ rotate: 0, scale: 0 }), new Pagination({ type: "bullet" })]}
                moveType={"snap"}
                bulletCount={1}
                style={{ marginTop: "10px" }}
            >
                {props.trackedEntities.map((entity) => {
                    return <Box sx={{ margin: "0 10px" }} className="card-panel" key={entity.id}>
                        <UserPlant entity={entity} key={entity.id} />
                    </Box>;
                })}
                <ViewportSlot>
                    <Box className="flicking-pagination"></Box>
                </ViewportSlot>
            </Flicking>
        </Box >
    );
}


function DiaryEntriesList(props: { logEntries: diaryEntry[]; }) {
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
                {props.logEntries.map((entity) => {
                    return <LogEntry entity={entity} key={entity.id} />;
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
    const logPageSize = 5;

    const getAllEntities = (): void => {
        props.requestor.get("tracked-entity/_count")
            .then((res) => {
                getEntities(res.data);
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
            });
    };

    useEffect(() => {
        if (!props.isLoggedIn()) {
            navigate("/auth");
        } else {
            getAllEntities();
            getLog();
        }
    }, []);

    if (!props.isLoggedIn()) {
        return <></>;
    }

    return (
        <>
            <Box sx={{ pb: 7, width: "90%", margin: "40px auto" }}>

                <Box sx={{ display: activeTab === 0 ? "visible" : "none" }}>
                    <UserTopBar />

                    <UserPlantsList
                        requestor={props.requestor}
                        trackedEntities={trackedEntities}
                    />

                    <DiaryEntriesList logEntries={logEntries} />
                </Box>

                <Box sx={{ display: activeTab === 1 ? "visible" : "none" }}>
                    <AllLogs
                        requestor={props.requestor}
                        entries={logEntries}
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
                updateLogEntries={(arg: diaryEntry) => {
                    logEntries.unshift(arg);
                    setLogEntries(logEntries.slice(0, logPageSize));
                }}
            ></BottomBar>
        </>
    );
}
