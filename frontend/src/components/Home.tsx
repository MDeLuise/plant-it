import { AxiosInstance } from "axios";
import { useEffect, useState } from "react";
import { NavigateFunction, useNavigate } from "react-router-dom";
import "../style/Home.scss";
import "../style/Base.scss";
import { Avatar, BottomNavigation, BottomNavigationAction, Box, InputAdornment, Link, OutlinedInput, Paper, Typography } from "@mui/material";
import { diaryEntry, trackedEntity } from "../interfaces";
import MenuBookOutlinedIcon from '@mui/icons-material/MenuBookOutlined';
import HomeOutlinedIcon from '@mui/icons-material/HomeOutlined';
import PersonOutlinedIcon from '@mui/icons-material/PersonOutlined';
import UserPlant from "./UserPlant";
import NotificationsOutlinedIcon from '@mui/icons-material/NotificationsOutlined';
import SearchOutlinedIcon from '@mui/icons-material/SearchOutlined';
import CloseOutlinedIcon from '@mui/icons-material/CloseOutlined';
import ForestOutlinedIcon from '@mui/icons-material/ForestOutlined';
import LogEntry from "./LogEntry";
import AllPlants from "./AllPlants";
import SearchPage from "./SearchPage";


function UserTopBar(props: {}) {
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
                    <Typography variant="body1" style={{ fontWeight: 600 }}>user 👋</Typography>
                </Box>
            </Box>
            <NotificationsOutlinedIcon />
        </Box>
    )
}

function UserPlantsList(props: {requestor: AxiosInstance}) {
    const [entities, setEntities] = useState<trackedEntity[]>([]);
    const [plantName, setPlantName] = useState<string>("");

    useEffect(() => {
        props.requestor.get("/tracked-entity")
        .then((res) => {
            setEntities(res.data.content);
        })
    }, []);

    return (
        <Box>
            <Box sx={{
                display: "flex",
                alignItems: "center",
            }}>
                <Typography variant="body1" style={{ fontWeight: 600 }}>Your plants</Typography>
                <Box sx={{flexGrow: 1}}></Box>
                <Typography variant="body1" mx={.5}><Link href="#">All</Link></Typography>
                <Typography variant="body1" mx={.5}><Link href="#">Add</Link></Typography>
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
                            sx={{visibility: plantName === "" ? "hidden" : "initial"}}
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
            <Box sx= {{
                display: "flex",
                gap: "20px",
                overflowX: "scroll",
                padding: "5px 0",
                '&::-webkit-scrollbar': {display: "none"}
            }}>
                {entities.map((entity) => {
                    return <UserPlant entity={entity} key={entity.id}/>
                })}
            </Box>
        </Box>
    )
}


function DiaryEntriesList(props: {requestor: AxiosInstance}) {
    const [entities, setEntities] = useState<diaryEntry[]>([]);

    useEffect(() => {
        props.requestor.get("/diary/entry")
        .then((res) => {
            setEntities(res.data.content);
        })
    }, []);

    return (
        <Box sx={{marginTop: "20px"}}>
            <Box sx={{
                display: "flex",
                alignItems: "center",
                margin: "10px 0"
            }}>
                <Typography variant="body1" style={{ fontWeight: 600 }}>Your diary</Typography>
                <Box sx={{flexGrow: 1}}></Box>
                <Typography variant="body1" mx={.5}><Link href="#">All</Link></Typography>
                <Typography variant="body1" mx={.5}><Link href="#">Add</Link></Typography>
            </Box>
            
            <Box sx={{
                display: "flex",
                flexDirection: "column",
                gap: "20px",
            }}>
                {entities.map((entity, index) => {
                    return <LogEntry entity={entity} last={index == entities.length - 1} key={entity.id}/>
                })}
            </Box>
        </Box>
    )
}


export default function Home(props: { isLoggedIn: () => boolean, requestor: AxiosInstance }) {
    let navigate: NavigateFunction = useNavigate();
    const [activeTab, setActiveTab] = useState<number>(0);
    const [error, setError] = useState<string>();

    return (
        <>
            <Box sx={{ pb: 7, width: "90%", margin: "40px auto" }}>

                <Box sx={{ display: activeTab === 0 ? "visible" : "none" }}>
                    <UserTopBar></UserTopBar>

                    <UserPlantsList requestor={props.requestor}/>

                    <DiaryEntriesList requestor={props.requestor}/>
                </Box>

                <Box sx={{ display: activeTab === 1 ? "visible" : "none" }}>
                    <AllPlants requestor={props.requestor}/>
                </Box>

                <Box sx={{ display: activeTab === 3 ? "visible" : "none" }}>
                    <SearchPage requestor={props.requestor}/>
                </Box>

                <Paper sx={{ position: 'fixed', bottom: 0, left: 0, right: 0 }} elevation={3}>
                    <BottomNavigation
                        showLabels
                        value={activeTab}
                        onChange={(_event, newValue) => {
                            setActiveTab(newValue);
                        }}

                    >
                        <BottomNavigationAction label="Home" icon={<HomeOutlinedIcon />} />
                        <BottomNavigationAction label="Garden" icon={<ForestOutlinedIcon />} />
                        <BottomNavigationAction label="Diary" icon={<MenuBookOutlinedIcon />} />
                        <BottomNavigationAction label="Search" icon={<SearchOutlinedIcon />} />
                        <BottomNavigationAction label="Profile" icon={<PersonOutlinedIcon />} />
                    </BottomNavigation>
                </Paper>
            </Box>
        </>
    );
}
