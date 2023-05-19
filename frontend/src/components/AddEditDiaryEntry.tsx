import { AxiosInstance } from "axios";
import TopBar from "./TopBar";
import { InputLabel, Select, OutlinedInput, MenuItem, Theme, useTheme, SelectChangeEvent, Box, Button, TextField, Alert, Snackbar } from "@mui/material";
import { useEffect, useState } from "react";
import { trackedEntity } from "../interfaces";
import { titleCase } from "../common";
import dayjs, { Dayjs } from "dayjs";
import { LocalizationProvider, DateTimePicker } from "@mui/x-date-pickers";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import AddRoundedIcon from '@mui/icons-material/AddRounded';
import ModeRoundedIcon from '@mui/icons-material/ModeRounded';
import { useParams } from "react-router-dom";

export default function AddEditDiaryEntry(props: {
    requestor: AxiosInstance,
    isLoggedIn: () => boolean
}) {
    const { diaryEntryId } = useParams();
    const [entities, setEntities] = useState<trackedEntity[]>([]);
    const [selectedIds, setSelectedIds] = useState<string[]>([]);
    const [diaryTypes, setDiaryTypes] = useState<string[]>([]);
    const [selectedDiaryTypes, setSelectedDiaryTypes] = useState<string[]>([]);
    const [note, setNote] = useState<string>();
    const [date, setDate] = useState<Dayjs>(dayjs(new Date()));
    const [snackbarOpen, setSnackbarOpen] = useState<boolean>(false);
    const [snackbarMessage, setSnackbarMessage] = useState<string>("");
    const [snackbarSeverity, setSnackbarSeverity] = useState<"success" | "error" | "warning" | "info">("success");
    const theme = useTheme();

    function getName(en: trackedEntity): string {
        return en.personalName != undefined ? en.personalName : "plant " + en.id;
    };

    function getStyles(id: number | string, selected: string[], theme: Theme) {
        return {
            fontWeight:
                selected.indexOf(id.toString()) === -1
                    ? theme.typography.fontWeightRegular
                    : theme.typography.fontWeightMedium,
        };
    };

    const getAllEntities = (): void => {
        props.requestor.get("tracked-entity/_count")
            .then((res) => {
                getEntities(res.data);
            })
    };

    const getEntities = (count: number): void => {
        props.requestor.get(`tracked-entity?pageSize=${count}`)
            .then((res) => {
                let newEntities: trackedEntity[] = [];
                res.data.content.forEach((en: trackedEntity) => {
                    newEntities.push(en);
                });
                setEntities(newEntities);
            })
    };

    const getDiaryEvents = (): void => {
        props.requestor.get("diary/entry/type")
            .then((res) => {
                setDiaryTypes(res.data);
            })
    }


    const ITEM_HEIGHT = 48;
    const ITEM_PADDING_TOP = 8;
    const MenuProps = {
        PaperProps: {
            style: {
                maxHeight: ITEM_HEIGHT * 4.5 + ITEM_PADDING_TOP,
                width: 250,
            },
        },
    };

    const handleSelectEntityId = (event: SelectChangeEvent<typeof selectedIds>) => {
        const {
            target: { value },
        } = event;
        setSelectedIds(
            // On autofill we get a stringified value.
            typeof value === 'string' ? value.split(',') : value,
        );
    };

    const handleSelectEventType = (event: SelectChangeEvent<typeof selectedIds>) => {
        const {
            target: { value },
        } = event;
        setSelectedDiaryTypes(
            // On autofill we get a stringified value.
            typeof value === 'string' ? value.split(',') : value,
        );
    };

    const addEvent = (): void => {
        selectedIds.forEach((selectedId) => {
            selectedDiaryTypes.forEach((eventType) => {
                props.requestor.post("diary/entry", {
                    type: eventType,
                    date: date,
                    diaryId: entities.filter((en) => en.id === Number(selectedId))[0].diaryId,
                    note: note
                })
                    .then((_res) => {
                        setSnackbarSeverity("success");
                        setSnackbarMessage("Diaries entries added successfully");
                        setSnackbarOpen(true);
                    })
                    .catch((error) => {
                        setSnackbarSeverity("error");
                        setSnackbarMessage(error.message);
                        setSnackbarOpen(true);
                    })
            })
        })
    };

    const handleSnackbarClose = (event?: React.SyntheticEvent | Event, reason?: string) => {
        if (reason === 'clickaway') {
            return;
        }
        setSnackbarOpen(false);
    };

    const fetchEntityToEdit = (): void => {
        if (diaryEntryId != undefined) {
            props.requestor.get(`/diary/entry/${diaryEntryId}`)
                .then((res) => {
                    setSelectedIds([res.data.diaryTargetId.toString()]);
                    setSelectedDiaryTypes([res.data.type]);
                    setNote(res.data.note);
                    setDate(res.data.date);
                })
        }
    };

    useEffect(() => {
        fetchEntityToEdit();
        getAllEntities();
        getDiaryEvents();
    }, []);

    return (
        <Box sx={{
            width: "90%",
            margin: "0 auto",
            height: "100vh",
            display: "flex",
            flexDirection: "column",
            gap: "20px"
        }}>
            <TopBar text="New diary entry" />

            <Snackbar open={snackbarOpen} autoHideDuration={6000} onClose={handleSnackbarClose}>
                <Alert onClose={handleSnackbarClose} severity={snackbarSeverity} sx={{ width: '100%' }} variant="filled">
                    {snackbarMessage}
                </Alert>
            </Snackbar>


            <Box>
                <InputLabel id="name-label">Name</InputLabel>
                <Select
                    labelId="name-label"
                    multiple
                    fullWidth
                    value={selectedIds}
                    onChange={handleSelectEntityId}
                    input={<OutlinedInput label="Name" />}
                    MenuProps={MenuProps}
                >
                    {
                        entities.map((en) => {
                            let name: string = getName(en);
                            return <MenuItem
                                key={en.id}
                                value={en.id}
                                style={getStyles(en.id, selectedIds, theme)}
                            >
                                {name}
                            </MenuItem>
                        })
                    }
                </Select>
            </Box>

            <Box>
                <InputLabel id="event-type-label">Event</InputLabel>
                <Select
                    labelId="event-type-label"
                    multiple
                    fullWidth
                    value={selectedDiaryTypes}
                    onChange={handleSelectEventType}
                    input={<OutlinedInput label="Event" />}
                    MenuProps={MenuProps}
                >
                    {
                        diaryTypes.map((diaryType) => {
                            return <MenuItem
                                key={diaryType}
                                value={diaryType}
                                style={getStyles(diaryType, selectedIds, theme)}
                            >
                                {titleCase(diaryType)}
                            </MenuItem>
                        })
                    }
                </Select>
            </Box>

            <Box>
                <InputLabel id="event-date-label">Date</InputLabel>
                <LocalizationProvider labelId="event-date-label" dateAdapter={AdapterDayjs} sx={{ width: "100%" }}>
                    <DateTimePicker sx={{ width: "100%" }} defaultValue={dayjs(new Date())} onChange={(newValue) => setDate(newValue != null ? newValue : dayjs(new Date()))} />
                </LocalizationProvider>
            </Box>

            <Box>
                <InputLabel>Note</InputLabel>
                <TextField
                    fullWidth
                    multiline
                    rows={4}
                    variant="standard"
                    onChange={(event) => setNote(event.target.value)}
                />
            </Box>

            <Box sx={{ flexGrow: "1" }}></Box>

            <Button
                variant="contained"
                endIcon={diaryEntryId == undefined ? <AddRoundedIcon /> : <ModeRoundedIcon />}
                onClick={addEvent}
                sx={{
                    width: "100%",
                    marginBottom: "20px"
                }}
            >
                {diaryEntryId == undefined ? "Add" : "Update"}
            </Button>
        </Box>

    )
}