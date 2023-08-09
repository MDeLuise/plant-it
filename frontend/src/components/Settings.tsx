import { Accordion, AccordionDetails, AccordionSummary, Box, Button, FormControl, InputLabel, MenuItem, Select, Typography } from "@mui/material";
import LogoutRoundedIcon from '@mui/icons-material/LogoutRounded';
import secureLocalStorage from "react-secure-storage";
import { NavigateFunction, useNavigate } from "react-router-dom";
import { useEffect, useState } from "react";
import { AxiosInstance } from "axios";
import ArrowForwardIosSharpIcon from '@mui/icons-material/ArrowForwardIosSharp';

function StatsSection(props: {
    title: string,
    value: number;
}) {
    return (
        <Box sx={{
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            width: "45%",
            borderRadius: "5px",
            backgroundColor: "background.default",
            padding: "15px",
        }}>
            <Box>
                {props.title}
            </Box>
            <Box>
                {props.value}
            </Box>
        </Box>
    );
}

function Stats(props: {
    requestor: AxiosInstance,
    visibility: boolean;
}) {
    const [expanded, setExpanded] = useState<boolean>(true);
    const [totalEvents, setTotalEvents] = useState<number>(0);
    const [totalPlants, setTotalPlants] = useState<number>(0);
    const [totalBotanicalInfo, setTotalBotanicalInfo] = useState<number>(0);
    const [totalPhotos, setTotalPhotos] = useState<number>(0);

    useEffect(() => {
        if (props.visibility) {
            props.requestor.get("diary/entry/_count")
                .then((res) => setTotalEvents(res.data));
            props.requestor.get("plant/_count")
                .then((res) => setTotalPlants(res.data));
            props.requestor.get("plant/_countBotanicalInfo")
                .then((res) => setTotalBotanicalInfo(res.data));
            props.requestor.get("image/entity/_count")
                .then((res) => setTotalPhotos(res.data));
        }
    });

    return (
        <Accordion
            disableGutters
            square
            elevation={0}
            expanded={expanded}
            onChange={(_event: React.SyntheticEvent, newExpanded: boolean) => setExpanded(newExpanded)}
            sx={{
                backgroundColor: "background.paper",
                borderRadius: "10px",
                '&:not(:last-child)': {
                    borderBottom: 0,
                },
                '&:before': {
                    display: 'none',
                },
            }}>
            <AccordionSummary
                expandIcon={<ArrowForwardIosSharpIcon sx={{ fontSize: '0.9rem', rotate: "90deg" }} />}
                sx={{
                    '&:not(:last-child)': {
                        borderBottom: 0,
                    },
                    '&:before': {
                        display: 'none',
                    },
                }}
            >
                <Box sx={{
                    width: "98%",
                }}>
                    <Box
                        sx={{
                            display: "flex",
                            alignItems: "center",
                            gap: "5px",
                            padding: 0,
                        }}
                    >
                        <Typography>Stats</Typography>
                    </Box>
                </Box>
            </AccordionSummary>
            <AccordionDetails
                sx={{
                    display: "flex",
                    gap: "10px",
                    justifyContent: "center",
                    flexWrap: "wrap",
                }}
            >
                <StatsSection
                    title="Events"
                    value={totalEvents}
                />
                <StatsSection
                    title="Plants"
                    value={totalPlants}
                />
                <StatsSection
                    title="Species"
                    value={totalBotanicalInfo}
                />
                <StatsSection
                    title="Photos"
                    value={totalPhotos}
                />
                {/* <Box sx={{ width: "45%" }} /> */}
            </AccordionDetails>
        </Accordion>
    );
}

// TODO make stats responsive on changes
export default function Settings(props: {
    requestor: AxiosInstance,
    visibility: boolean;
}) {
    let navigate: NavigateFunction = useNavigate();
    const [version, setVersion] = useState<string>();

    const logout = (): void => {
        secureLocalStorage.removeItem("plant-it-key");
        navigate("/auth");
    };

    const getVersion = (): void => {
        props.requestor.get("/info/version")
            .then((res) => setVersion(res.data));
    };

    useEffect(() => {
        getVersion();
    }, []);

    return <Box sx={{
        display: "flex",
        gap: "10px",
        flexDirection: "column",
    }}>

        <Stats requestor={props.requestor} visibility={props.visibility}/>
        <Box
            sx={{
                backgroundColor: "background.paper",
                borderRadius: "10px",
                display: "flex",
                justifyContent: "space-between",
                padding: "15px",
            }}>
            <Box>App version</Box>
            <Box>{version}</Box>
        </Box>
        <Box>
            <Button
                variant="contained"
                color="error"
                fullWidth
                onClick={logout}
                startIcon={<LogoutRoundedIcon />}
            >
                Log out
            </Button>
        </Box>
    </Box>;
}