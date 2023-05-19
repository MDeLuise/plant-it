import { Accordion, AccordionDetails, AccordionSummary, Box, CircularProgress, FormControl, InputLabel, MenuItem, Select, Typography } from "@mui/material";
import { AxiosInstance } from "axios";
import LogEntry from "./LogEntry";
import { useState, useEffect, useRef } from "react";
import { diaryEntry, plant } from "../interfaces";
import ArrowForwardIosSharpIcon from '@mui/icons-material/ArrowForwardIosSharp';
import { titleCase } from "../common";
import { GrClose } from "react-icons/gr";
import { BsFilter } from "react-icons/bs";

function Filters(props: {
    entityNames: string[],
    entityIds: number[],
    setFilteredPlantIds: (ids: number[]) => void,
    eventTypes: string[],
    setFilteredEventType: (types: string[]) => void;
}) {
    const [selectedFilteredEntitiyNames, setSelectedFilteredEntitiyNames] = useState<string[]>([]);
    const [selectedFilteredEventTypes, setSelectedFilteredEventTypes] = useState<string[]>([]);

    return (
        <Accordion disableGutters square elevation={0} sx={{
            backgroundColor: "background.default",
            '&:not(:last-child)': {
                borderBottom: 0,
            },
            '&:before': {
                display: 'none',
            },
            borderLeft: "1px solid grey",
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
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "space-between",
                }}>
                    <Box sx={{display: "flex", alignItems: "center", gap: "5px"}}>
                        <BsFilter />
                        <Typography>Filter</Typography>
                    </Box>
                    <GrClose
                        style={{
                            fontSize: '0.9rem',
                            visibility: selectedFilteredEntitiyNames.length > 0 || selectedFilteredEventTypes.length > 0 ? "visible" : "hidden",
                        }}
                        onClick={() => {
                            setSelectedFilteredEntitiyNames([]);
                            props.setFilteredPlantIds([]);
                            setSelectedFilteredEventTypes([]);
                            props.setFilteredEventType([]);
                        }}
                    />
                </Box>
            </AccordionSummary>
            <AccordionDetails sx={{ display: "flex", gap: "10px", justifyContent: "center" }}>
                <FormControl fullWidth>
                    <InputLabel id="plant-filter-label">Plant</InputLabel>
                    <Select
                        labelId="plant-filter-label"
                        value={selectedFilteredEntitiyNames}
                        label="Plant"
                        multiple
                        onChange={(event) => {
                            props.setFilteredPlantIds([...event.target.value].map((en) => Number(en)));
                            setSelectedFilteredEntitiyNames([...event.target.value]);
                        }}
                        sx={{ width: "100%" }}
                    >
                        {
                            props.entityNames.map((name: string, index: number) => {
                                return <MenuItem
                                    value={props.entityIds[index]}
                                >
                                    {name}
                                </MenuItem>;
                            })
                        }
                    </Select>
                </FormControl>
                <FormControl fullWidth>
                    <InputLabel id="event-filter-label">Event</InputLabel>
                    <Select
                        labelId="event-filter-label"
                        value={selectedFilteredEventTypes}
                        label="Event"
                        multiple
                        onChange={(event) => {
                            props.setFilteredEventType([...event.target.value]);
                            setSelectedFilteredEventTypes([...event.target.value]);
                        }}
                        sx={{ width: "100%" }}
                    >
                        {
                            props.eventTypes.map((name: string) => {
                                return <MenuItem
                                    value={name}
                                >
                                    {titleCase(name)}
                                </MenuItem>;
                            })
                        }
                    </Select>
                </FormControl>
            </AccordionDetails>
        </Accordion>
    );
}

export default function AllLogs(props: {
    requestor: AxiosInstance,
    eventTypes: string[],
    entries: diaryEntry[],
    plants: plant[],
    openEditEvent: (arg: diaryEntry) => void,
}) {
    const pageSize = 5;
    const [entities, setEntities] = useState<diaryEntry[]>([]);
    const [pageNo, setPageNo] = useState<number>(-1);
    const [circularProgressVisible, setCircularProgressVisible] = useState<boolean>(false);
    const [fetchNew, setFetchNew] = useState<boolean>(true);
    const [filteredPlantId, setFilteredPlantId] = useState<number[]>([]);
    const [filteredEventType, setFilteredEventType] = useState<string[]>([]);

    const observerCallback = (entries: IntersectionObserverEntry[], _observer: IntersectionObserver) => {
        const entry = entries[0];
        if (entry.isIntersecting) {
            setFetchNew(true);
        }
    };

    const observer = new IntersectionObserver(observerCallback, {
        rootMargin: '0px',
        threshold: 1.0,
    });

    useEffect(() => {
        if (pageNo === -1) {
            return;
        }
        if ((pageNo * pageSize === entities.length) && fetchNew) {
            getPage();
        }
    }, [pageNo, entities, fetchNew]);

    useEffect(() => {
        setPageNo(0);
        setEntities([]);
        setFetchNew(true);
    }, [filteredPlantId, filteredEventType, props.entries]);

    const getPage = () => {
        if (myRef.current !== undefined && myRef.current !== null) {
            observer.unobserve(myRef.current);
        }
        setFetchNew(false);
        setCircularProgressVisible(true);
        props.requestor.get("/diary/entry", {
            params: {
                pageNo: pageNo,
                pageSize: pageSize,
                eventTypes: filteredEventType.join(","),
                plantIds: filteredPlantId.join(","),
            }
        })
            .then((res) => {
                let newEntitites: diaryEntry[] = [];
                entities.forEach((en: diaryEntry) => {
                    newEntitites.push(en);
                });
                res.data.content.forEach((en: diaryEntry) => {
                    newEntitites.push(en);
                });
                setEntities(newEntitites);
                setPageNo(pageNo + 1);
                if (!res.data.last) {
                    setTimeout(() => {
                        if (myRef.current !== undefined && myRef.current != null) {
                            observer.observe(myRef.current as Element);
                            setCircularProgressVisible(false);
                        }
                    }, 500);
                } else {
                    setCircularProgressVisible(false);
                }
            });
    };

    useEffect(() => {
        setPageNo(0);
        setTimeout(() => {
            if (myRef.current !== undefined) {
                observer.observe(myRef.current as Element);
            }
        }, 700);
    }, []);

    const myRef = useRef<Element>();

    return (
        <Box sx={{ marginTop: "20px" }}>
            <Box sx={{
                display: "flex",
                flexDirection: "column",
                gap: "20px",
            }}>

                <Filters
                    entityNames={props.plants.map((en) => en.personalName)}
                    entityIds={props.plants.map((en) => en.id)}
                    setFilteredPlantIds={setFilteredPlantId}
                    eventTypes={props.eventTypes}
                    setFilteredEventType={setFilteredEventType}
                />

                {/*
                  * FIXME: If page refresh and immediately click on "calendar icon",
                  * then mess with diary log entries order
                */}

                {
                    entities.map((entity, index) => {
                        return <LogEntry
                            entity={entity}
                            last={index == entities.length - 1}
                            key={entity.id}
                            lastRef={myRef}
                            editEvent={() => props.openEditEvent(entity)}
                        />;
                    })
                }
                <CircularProgress
                    sx={{
                        margin: "0 auto",
                        visibility: circularProgressVisible ? "visible" : "hidden"
                    }}
                />
            </Box>
        </Box>
    );
};