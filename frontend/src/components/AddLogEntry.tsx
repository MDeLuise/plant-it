import {
    Autocomplete,
    Box,
    Button,
    Checkbox,
    Drawer,
    InputLabel,
    TextField,
    Typography,
    useTheme,
} from "@mui/material";
import { AxiosError, AxiosInstance } from "axios";
import React, { useEffect, useState } from "react";
import { diaryEntry, plant } from "../interfaces";
import { GrClose } from "react-icons/gr";
import { titleCase } from "../common";
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs';
import dayjs, { Dayjs } from 'dayjs';
import { DatePicker, LocalizationProvider } from "@mui/x-date-pickers";
import SaveOutlinedIcon from '@mui/icons-material/SaveOutlined';
import CheckBoxOutlineBlankIcon from '@mui/icons-material/CheckBoxOutlineBlank';
import CheckBoxIcon from '@mui/icons-material/CheckBox';
import ErrorDialog from "./ErrorDialog";

export default function AddLogEntry(props: {
    requestor: AxiosInstance,
    eventTypes: string[],
    plants: plant[],
    open: boolean,
    setOpen: (arg: boolean) => void,
    updateLog: (arg: diaryEntry) => void,
    addForPlant?: plant;
}) {
    const [date, setDate] = useState<Dayjs | null>(dayjs(new Date()));
    const [selectedPlantName, setSelectedPlantName] = useState<string[]>([]);
    const [selectedEventType, setSelectedEventType] = useState<string[]>([]);
    const [plantNameError, setPlantNameError] = useState<string>();
    const [eventTypeError, setEventTypeError] = useState<string>();
    const [note, setNote] = useState<string>();
    const [loading, setLoading] = useState<boolean>(false);
    const theme = useTheme();
    const [errorDialogShown, setErrorDialogShown] = useState<boolean>(false);
    const [errorDialogText, setErrorDialogText] = useState<string>();


    const showErrorDialog = (res: AxiosError) => {
        setErrorDialogText((res.response?.data as any).message);
        setErrorDialogShown(true);
    };

    const addEvent = (): void => {
        if (plantNameError !== undefined) {
            return;
        }
        if (eventTypeError !== undefined) {
            return;
        }
        if (selectedPlantName.length == 0) {
            setPlantNameError("At least 1 plant must be selected");
            return;
        }
        if (selectedEventType.length == 0) {
            setEventTypeError("At least 1 event must be selected");
            return;
        }
        setLoading(true);
        selectedPlantName.forEach((plantId) => {
            selectedEventType.forEach((eventType) => {
                props.requestor.post("diary/entry", {
                    type: eventType,
                    date: date,
                    diaryId: props.plants.filter((en) => en.personalName === plantId)[0].diaryId,
                    note: note
                })
                    .then((res) => {
                        res.data.diaryTargetPersonalName = plantId; // TODO should not be necessary but backend problem
                        props.updateLog(res.data);
                        closeDrawer();
                    })
                    .catch((err) => {
                        showErrorDialog(err);
                    })
                    .finally(() => setLoading(false));
            });
        });
    };


    const changePlantName = (value: readonly string[]): void => {
        if (value.length == 0) {
            setPlantNameError("At least 1 plant must be selected");
        } else {
            setPlantNameError(undefined);
        }
        setSelectedPlantName(Array.from(value));
    };


    const changeEventType = (value: readonly string[]): void => {
        if (value.length == 0) {
            setEventTypeError("At least 1 event must be selected");
        } else {
            setEventTypeError(undefined);
        }
        setSelectedEventType(Array.from(value));
    };


    const closeDrawer = (): void => {
        setSelectedPlantName([]);
        setSelectedEventType([]);
        setNote(undefined);
        setEventTypeError(undefined);
        setPlantNameError(undefined);
        props.setOpen(false);
    };


    useEffect(() => {
        if (props.addForPlant != undefined) {
            setSelectedPlantName([props.addForPlant?.personalName]);
        } else {
            setSelectedPlantName([]);
        }
    }, [props.addForPlant, props.open]);

    return (
        <Drawer
            anchor={"bottom"}
            open={props.open}
            onClose={closeDrawer}
            PaperProps={{
                style: { borderRadius: "15px 15px 0 0" }
            }}
        >

            <ErrorDialog
                text={errorDialogText}
                open={errorDialogShown}
                close={() => setErrorDialogShown(false)}
            />

            <GrClose
                onClick={closeDrawer}
                style={{
                    position: "absolute",
                    top: "20px",
                    right: "20px",
                }}
            />

            <Box
                sx={{
                    height: "85vh",
                    display: "flex",
                    flexDirection: "column",
                    padding: "35px",
                    gap: "20px",
                }}>
                <Box sx={{ width: "100%" }}>
                    <InputLabel>Name</InputLabel>
                    <Autocomplete
                        disableCloseOnSelect
                        disablePortal
                        multiple
                        options={props.plants.map(pl => pl.personalName)}
                        disabled={props.addForPlant != undefined}
                        value={selectedPlantName}
                        onChange={(_event: any, newValue: readonly string[]) => changePlantName(newValue)}
                        fullWidth
                        renderTags={(selected) => {
                            let renderedValues = selected.join(", ");
                            return (
                                <Typography
                                    noWrap={true}
                                    color={props.addForPlant === undefined ? "textPrimary" : "text.disabled"}
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
                                {option}
                            </li>
                        )}
                        renderInput={(params) =>
                            <TextField
                                {...params}
                                fullWidth
                                error={plantNameError !== undefined}
                                helperText={plantNameError}
                            />
                        }
                    />
                </Box>

                <Box>
                    <InputLabel>Type</InputLabel>
                    <Autocomplete
                        disableCloseOnSelect
                        disablePortal
                        multiple
                        options={props.eventTypes}
                        value={selectedEventType}
                        onChange={(_event: any, newValue: readonly string[]) => changeEventType(newValue)}
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
                        renderInput={(params) =>
                            <TextField
                                {...params}
                                fullWidth
                                error={eventTypeError !== undefined}
                                helperText={eventTypeError}
                            />
                        }
                    />
                </Box>

                <Box sx={{ width: "100%" }}>
                    <InputLabel>Date</InputLabel>
                    <LocalizationProvider dateAdapter={AdapterDayjs} >
                        <DatePicker
                            value={date}
                            onChange={(newValue) => setDate(newValue)}
                            slotProps={{ textField: { fullWidth: true } }}
                            format="DD/MM/YYYY"
                        />
                    </LocalizationProvider>
                </Box>

                <Box sx={{ width: "100%" }}>
                    <TextField
                        label="Note"
                        multiline
                        rows={4}
                        onChange={(event) => setNote(event.target.value)}
                        fullWidth
                    />
                </Box>
            </Box>

            <Button sx={{
                backgroundColor: theme.palette.primary.main + " !important",
                color: "white",
                width: "90%",
                margin: "0 auto",
                marginBottom: "20px",
                padding: "15px",
            }}
                disabled={loading}
                startIcon={<SaveOutlinedIcon />}
                onClick={addEvent}
            >
                Save event
            </Button>
        </Drawer>
    );
}