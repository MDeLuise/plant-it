import {
    Autocomplete,
    Box,
    Button,
    Checkbox,
    Drawer,
    InputLabel,
    TextField,
    Typography,
} from "@mui/material";
import { AxiosInstance } from "axios";
import React, { useState } from "react";
import { diaryEntry, plant } from "../interfaces";
import { GrClose } from "react-icons/gr";
import { titleCase } from "../common";
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs';
import dayjs, { Dayjs } from 'dayjs';
import { DatePicker, LocalizationProvider } from "@mui/x-date-pickers";
import { alpha } from "@mui/material";
import SaveOutlinedIcon from '@mui/icons-material/SaveOutlined';
import CheckBoxOutlineBlankIcon from '@mui/icons-material/CheckBoxOutlineBlank';
import CheckBoxIcon from '@mui/icons-material/CheckBox';

export default function AddLogEntry(props: {
    requestor: AxiosInstance,
    eventTypes: string[],
    plants: plant[],
    open: boolean,
    setOpen: (arg: boolean) => void,
    updateLog: (arg: diaryEntry) => void,
}) {
    const [date, setDate] = useState<Dayjs | null>(dayjs(new Date()));
    const [selectedPlantName, setSelectedPlantName] = useState<string[]>([]);
    const [selectedEventType, setSelectedEventType] = useState<string[]>([]);
    const [note, setNote] = useState<string>();
    const [loading, setLoading] = useState<boolean>(false);

    const addEvent = (): void => {
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
                        props.setOpen(false);
                    })
                    .finally(() => setLoading(false));
            });
        });
    };

    return (
        <Drawer
            anchor={"bottom"}
            open={props.open}
            onClose={() => props.setOpen(false)}
            PaperProps={{
                style: { borderRadius: "15px 15px 0 0" }
            }}
        >

            <GrClose
                onClick={() => props.setOpen(false)}
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
                        value={selectedPlantName}
                        onChange={(_event: any, newValue: string[]) => setSelectedPlantName(newValue)}
                        fullWidth
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
                                {option}
                            </li>
                        )}
                        renderInput={(params) => <TextField {...params} fullWidth />}
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
                        onChange={(_event: any, newValue: string[]) => setSelectedEventType(newValue)}
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
                        renderInput={(params) => <TextField {...params} fullWidth />}
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
                backgroundColor: loading ? alpha("#3a5e49", .7) : "primary.main",
                color: "white",
                width: "90%",
                margin: "0 auto",
                marginBottom: "20px",
                padding: "15px",
            }}
                disabled={loading}
                onClick={addEvent}
                startIcon={<SaveOutlinedIcon />}
            >Save event</Button>
        </Drawer>
    );
}