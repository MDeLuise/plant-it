import { Accordion, AccordionDetails, AccordionSummary, Autocomplete, Box, Checkbox, CircularProgress, FormControl, InputLabel, MenuItem, Select, TextField, Typography } from "@mui/material";
import { AxiosInstance } from "axios";
import { useState, useEffect, useRef } from "react";
import { diaryEntry, plant } from "../interfaces";
import ArrowForwardIosSharpIcon from '@mui/icons-material/ArrowForwardIosSharp';
import { titleCase } from "../common";
import { GrClose } from "react-icons/gr";
import { BsFilter } from "react-icons/bs";
import CheckBoxOutlineBlankIcon from '@mui/icons-material/CheckBoxOutlineBlank';
import CheckBoxIcon from '@mui/icons-material/CheckBox';
import NewLogEntry from "./LogEntry";

function Filters(props: {
    plants: plant[],
    setFilteredPlantIds: (ids: number[]) => void,
    eventTypes: string[],
    setFilteredEventType: (types: string[]) => void,
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
                    <Box sx={{ display: "flex", alignItems: "center", gap: "5px" }}>
                        <BsFilter />
                        <Typography>Filter</Typography>
                    </Box>
                    <GrClose
                        style={{
                            fontSize: '0.9rem',
                            visibility: selectedFilteredEntitiyNames.length > 0 || selectedFilteredEventTypes.length > 0 ? "visible" : "hidden",
                        }}
                        onClick={() => {
                            setSelectedFilteredEventTypes([]);
                            props.setFilteredEventType([]);
                            setSelectedFilteredEntitiyNames([]);
                            props.setFilteredPlantIds([]);
                        }}
                    />
                </Box>
            </AccordionSummary>
            <AccordionDetails
                sx={{
                    display: "flex",
                    gap: "10px",
                    justifyContent: "center"
                }}
            >
                <FormControl fullWidth>
                    <Autocomplete
                        disableCloseOnSelect
                        disablePortal
                        multiple
                        options={props.plants.map(pl => pl.personalName)}
                        value={selectedFilteredEntitiyNames}
                        onChange={(_event: any, newValue: readonly string[]) => {
                            let selectedIds = props.plants.filter(pl => newValue.includes(pl.personalName)).map(pl => pl.id);
                            props.setFilteredPlantIds(selectedIds);
                            setSelectedFilteredEntitiyNames(Array.from(newValue));
                        }}
                        renderTags={(selected) => {
                            let renderedValues = selected.join(", ");
                            return (
                                <Typography
                                    noWrap={true}
                                    color="textPrimary"
                                >
                                    {renderedValues}
                                </Typography>
                            );
                        }}
                        sx={{
                            ".MuiAutocomplete-inputRoot": {
                                flexWrap: "nowrap !important",
                            }
                        }}
                        renderOption={(props, option, { selected }) => (
                            <li {...props}>
                                <Checkbox
                                    icon={<CheckBoxOutlineBlankIcon fontSize="small" />}
                                    checkedIcon={<CheckBoxIcon fontSize="small" />}
                                    style={{ marginRight: 8 }}
                                    checked={selected}
                                />
                                {titleCase(option)}
                            </li>
                        )}
                        renderInput={(params) => <TextField {...params} label="Plant" fullWidth />}
                    />
                </FormControl>
                <FormControl fullWidth>
                    <Autocomplete
                        disableCloseOnSelect
                        disablePortal
                        multiple
                        options={props.eventTypes}
                        value={selectedFilteredEventTypes}
                        onChange={(_event: any, newValue: readonly string[]) => {
                            props.setFilteredEventType(Array.from(newValue));
                            setSelectedFilteredEventTypes(Array.from(newValue));
                        }}
                        renderTags={(selected) => {
                            let renderedValues = selected.map(ev => titleCase(ev)).join(", ");
                            return (
                                <Typography
                                    noWrap={true}
                                    color="textPrimary"
                                >
                                    {renderedValues}
                                </Typography>
                            );
                        }}
                        sx={{
                            ".MuiAutocomplete-inputRoot": {
                                flexWrap: "nowrap !important",
                            }
                        }}
                        renderOption={(props, option, { selected }) => (
                            <li {...props}>
                                <Checkbox
                                    icon={<CheckBoxOutlineBlankIcon fontSize="small" />}
                                    checkedIcon={<CheckBoxIcon fontSize="small" />}
                                    style={{ marginRight: 8 }}
                                    checked={selected}
                                />
                                {titleCase(option)}
                            </li>
                        )}
                        renderInput={(params) => <TextField {...params} label="Event" fullWidth />}
                    />
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
    printError: (err: any) => void,
    active: boolean,
}) {
    const pageSize = 5;
    const [entities, setEntities] = useState<diaryEntry[]>([]);
    const [pageNo, setPageNo] = useState<number>(-1);
    const [circularProgressVisible, setCircularProgressVisible] = useState<boolean>(false);
    const [fetchNew, setFetchNew] = useState<boolean>(true);
    const [filteredPlantId, setFilteredPlantId] = useState<number[]>([]);
    const [filteredEventType, setFilteredEventType] = useState<string[]>([]);
    const [wasAlreadyRendered, setWasAlreadyRendered] = useState<boolean>(false);


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


    useEffect(() => {
        if (!wasAlreadyRendered && props.active) {
            setTimeout(() => {
                if (myRef.current !== undefined) {
                    observer.observe(myRef.current as Element);
                }
            }, 700);
            setWasAlreadyRendered(true);
        }
    }, [props.active]);


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
            })
            .catch((err) => {
                props.printError(err);
            });
    };

    useEffect(() => {
        setPageNo(0);
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
                    plants={props.plants}
                    setFilteredPlantIds={setFilteredPlantId}
                    eventTypes={props.eventTypes}
                    setFilteredEventType={setFilteredEventType}
                />

                {
                    entities.map((entity, index) => {
                        return <NewLogEntry
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