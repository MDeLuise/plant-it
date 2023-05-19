import { AxiosInstance } from "axios";
import { Fragment, ReactElement, useEffect, useState } from "react";
import { NavigateFunction, useNavigate } from "react-router-dom";
import "../style/Home.scss";
import "../style/Base.scss";
import { Avatar, BottomNavigation, BottomNavigationAction, Box, List, ListItem, ListItemAvatar, ListItemText, Paper, Skeleton, SvgIconTypeMap, Typography } from "@mui/material";
import { diaryEntry, trackedEntity } from "../interfaces";
import MenuBookRoundedIcon from '@mui/icons-material/MenuBookRounded';
import ForestRoundedIcon from '@mui/icons-material/ForestRounded';
import SettingsRoundedIcon from '@mui/icons-material/SettingsRounded';
import PlantEntity from "./PlantEntity";
import AddPlantPlaceholder from "./AddPlantPlaceholder";
import { isBigScreen, titleCase } from "../common";
import QuestionMarkRoundedIcon from '@mui/icons-material/QuestionMarkRounded';
import WaterDropRoundedIcon from '@mui/icons-material/WaterDropRounded';
import YardRoundedIcon from '@mui/icons-material/YardRounded';
import AutorenewRoundedIcon from '@mui/icons-material/AutorenewRounded';
import AddRoundedIcon from '@mui/icons-material/AddRounded';


function ListOfUserEntities(props: { loading: boolean, entities: trackedEntity[], requestor: AxiosInstance }) {
    return (
        <Box sx={{ display: "flex", gap: "40px", flexWrap: "wrap", marginTop: "30px" }}>
            <AddPlantPlaceholder />
            {
                props.loading &&
                <>
                    <Skeleton variant="rounded" sx={{ height: isBigScreen() ? "20vw" : "39vw", width: isBigScreen() ? "20vw" : "39vw" }} />
                    <Skeleton variant="rounded" sx={{ height: isBigScreen() ? "20vw" : "39vw", width: isBigScreen() ? "20vw" : "39vw" }} />
                </>
            }
            {props.entities.map((en: trackedEntity) => {
                return <PlantEntity entity={en} requestor={props.requestor} />
            })}
        </Box>
    )
}


function ListOfUserDiariesEntries(props: { loading: boolean, entities: diaryEntry[], requestor: AxiosInstance }) {
    let navigate: NavigateFunction = useNavigate();
    const [entitiesNames, setEntitiesNames] = useState(new Map<number, string>());

    const getTypeIcon = (type: string): ReactElement<any, any> => {
        switch (type.toLowerCase()) {
            case "watering": return <WaterDropRoundedIcon />
            case "seeding": return <YardRoundedIcon />
            case "transplanting": return <AutorenewRoundedIcon />
            default: return <QuestionMarkRoundedIcon />
        }
    };

    const getEntityName = (id: number): void => {
        if (entitiesNames.has(id)) {
            return;
        }
        props.requestor.get(`/tracked-entity/${id}`)
            .then((response) => {
                let name = response.data.personalName != undefined ?
                    response.data.personalName :
                    "Plant " + id;
                entitiesNames.set(id, name);
            })
    };

    useEffect(() => {
        props.entities.forEach((en) => {
            getEntityName(en.diaryTargetId);
        })
    }, [props.entities]);

    return (
        <List sx={{ display: "flex", flexWrap: "wrap", marginTop: "30px" }}>
            <ListItem sx={{backgroundColor: "primary.main", borderRadius: "5px"}} onClick={() => navigate("/diary/add")}>
                <ListItemAvatar>
                    <Avatar>
                        <AddRoundedIcon />
                    </Avatar>
                </ListItemAvatar>
                <ListItemText primary="Add new" />
            </ListItem>
            {
                props.entities.map((en: diaryEntry) => {
                    return (
                        <ListItem alignItems="flex-start" sx={{borderRadius: "5px"}} onClick={() => navigate(`/diary/edit/${en.id}`)}>
                            <ListItemAvatar>
                                <Avatar>
                                    {getTypeIcon(en.type)}
                                </Avatar>
                            </ListItemAvatar>
                            <ListItemText
                                primary={entitiesNames.get(en.diaryTargetId)}
                                secondary={
                                    <Fragment>
                                        <Typography
                                            sx={{ display: 'inline' }}
                                            component="span"
                                            variant="body2"
                                            color="text.primary"
                                        >
                                            {titleCase(en.type)}
                                        </Typography>

                                        {` - ${new Date(en.date).toLocaleDateString()}`}
                                    </Fragment>
                                }
                            />
                        </ListItem>
                    )
                })
            }
        </List>

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
                    <ListOfUserEntities entities={entities} requestor={props.requestor} loading={loadingPlants} />
                </Box>

                <Box sx={{ display: activeTab === 1 ? "visible" : "none" }}>
                    <ListOfUserDiariesEntries entities={diariesEntries} requestor={props.requestor} loading={loadingDiaryEntries} />
                </Box>

                <Paper sx={{ position: 'fixed', bottom: 0, left: 0, right: 0 }} elevation={3}>
                    <BottomNavigation
                        showLabels
                        value={activeTab}
                        onChange={(_event, newValue) => {
                            setActiveTab(newValue);
                        }}

                    >
                        <BottomNavigationAction label="My plants" icon={<ForestRoundedIcon />} />
                        <BottomNavigationAction label="Diary" icon={<MenuBookRoundedIcon />} />
                        <BottomNavigationAction label="Menu" icon={<SettingsRoundedIcon />} />
                    </BottomNavigation>
                </Paper>
            </Box>
        </>
    );
}
