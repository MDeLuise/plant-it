import { AxiosInstance } from "axios";
import { Fragment, ReactElement, useEffect, useState } from "react";
import { NavigateFunction, useNavigate } from "react-router-dom";
import "../style/Home.scss";
import "../style/Base.scss";
import { Avatar, BottomNavigation, BottomNavigationAction, Box, InputAdornment, List, ListItem, ListItemAvatar, ListItemText, OutlinedInput, Paper, Skeleton, SvgIconTypeMap, Typography } from "@mui/material";
import { diaryEntry, trackedEntity } from "../interfaces";
import MenuBookOutlinedIcon from '@mui/icons-material/MenuBookOutlined';
import HomeOutlinedIcon from '@mui/icons-material/HomeOutlined';
import PersonOutlinedIcon from '@mui/icons-material/PersonOutlined';
import UserPlant from "./UserPlant";
import AddPlantPlaceholder from "./AddPlantPlaceholder";
import { isBigScreen, titleCase } from "../common";
import QuestionMarkOutlinedIcon from '@mui/icons-material/QuestionMarkOutlined';
import FavoriteOutlinedIcon from '@mui/icons-material/FavoriteOutlined';
import WaterDropOutlinedIcon from '@mui/icons-material/WaterDropOutlined';
import YardOutlinedIcon from '@mui/icons-material/YardOutlined';
import AutorenewOutlinedIcon from '@mui/icons-material/AutorenewOutlined';
import AddOutlinedIcon from '@mui/icons-material/AddOutlined';
import NotificationsOutlinedIcon from '@mui/icons-material/NotificationsOutlined';
import SearchOutlinedIcon from '@mui/icons-material/SearchOutlined';
import CloseOutlinedIcon from '@mui/icons-material/CloseOutlined';
import ForestOutlinedIcon from '@mui/icons-material/ForestOutlined';


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

    useEffect(() => {
        props.requestor.get("/tracked-entity")
        .then((res) => {
            setEntities(res.data.content);
        })
    }, []);

    return (
        <Box>
            <Typography variant="subtitle1" style={{ fontWeight: 600 }}>Your plants</Typography>
            <OutlinedInput
                fullWidth
                startAdornment={
                    <InputAdornment position="start" sx={{ opacity: 0.5 }}>
                        <SearchOutlinedIcon />
                    </InputAdornment>
                }
                endAdornment={
                    <InputAdornment position="start" sx={{ opacity: 0.5 }}>
                        <CloseOutlinedIcon />
                    </InputAdornment>
                }
                placeholder="Search your plants"
                sx={{
                    margin: "10px 0"
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
                    return <UserPlant entity={entity} requestor={props.requestor} key={entity.id}/>
                })}
            </Box>
        </Box>
    )
}


function DiaryEntriesList(props: {requestor: AxiosInstance}) {
    const [entities, setEntities] = useState<trackedEntity[]>([]);

    useEffect(() => {
        props.requestor.get("/tracked-entity")
        .then((res) => {
            setEntities(res.data.content);
        })
    }, []);

    const getTypeIcon = (type: string): ReactElement<any, any> => {
        switch (type.toLowerCase()) {
            case "watering": return <WaterDropOutlinedIcon />
            case "seeding": return <YardOutlinedIcon />
            case "transplanting": return <AutorenewOutlinedIcon />
            default: return <QuestionMarkOutlinedIcon />
        }
    };

    return (
        <Box sx={{marginTop: "20px"}}>
            <Typography variant="subtitle1" style={{ fontWeight: 600 }}>Your logs</Typography>
            
            {/* <Box sx= {{
                display: "flex",
                gap: "10px",
                overflowX: "scroll",
            }}>
                {entities.map((entity) => {
                    return <UserPlant entity={entity} requestor={props.requestor} key={entity.id}/>
                })}
            </Box> */}
        </Box>
    )
}


export default function Home(props: { isLoggedIn: () => boolean, requestor: AxiosInstance }) {
    let navigate: NavigateFunction = useNavigate();
    const [activeTab, setActiveTab] = useState<number>(0);
    const [error, setError] = useState<string>();
    const [entities, setEntities] = useState<trackedEntity[]>([]);
    const [loadingPlants, setLoadingPlants] = useState<boolean>(true);
    const [diariesEntries, setDiariesEntries] = useState<diaryEntry[]>([]);
    const [loadingDiaryEntries, setLoadingDiaryEntries] = useState<boolean>(true);


    const getEntities = (): void => {
        props.requestor.get("/tracked-entity")
            .then((response) => {
                let newEntities: trackedEntity[] = [];
                response.data.content.forEach((en: trackedEntity) => {
                    newEntities.push(en);
                })
                setEntities(newEntities);
            })
            .catch((err) => setError(err))
            .finally(() => setLoadingPlants(false))
    };

    const getDiariesEntries = (): void => {
        setLoadingDiaryEntries(true);
        props.requestor.get("/diary/entry")
            .then((response) => {
                let newEntries: diaryEntry[] = [];
                response.data.content.forEach((en: diaryEntry) => {
                    newEntries.push(en);
                });
                setDiariesEntries(newEntries);
            })
            .finally(() => setLoadingDiaryEntries(false))
    };

    useEffect(() => {
        getEntities();
        getDiariesEntries();
    }, []);

    return (
        <>
            <Box sx={{ pb: 7, width: "90%", margin: "40px auto" }}>

                <Box sx={{ display: activeTab === 0 ? "visible" : "none" }}>
                    <UserTopBar></UserTopBar>

                    <UserPlantsList requestor={props.requestor}/>

                    <DiaryEntriesList requestor={props.requestor}/>
                    {/* <ListOfUserEntities entities={entities} requestor={props.requestor} loading={loadingPlants} /> */}
                </Box>

                <Box sx={{ display: activeTab === 1 ? "visible" : "none" }}>
                    {/* <ListOfUserDiariesEntries entities={diariesEntries} requestor={props.requestor} loading={loadingDiaryEntries} /> */}
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
                        <BottomNavigationAction label="Whishlist" icon={<FavoriteOutlinedIcon />} />
                        <BottomNavigationAction label="Profile" icon={<PersonOutlinedIcon />} />
                    </BottomNavigation>
                </Paper>
            </Box>
        </>
    );
}
