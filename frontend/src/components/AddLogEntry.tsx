import {
    Box,
    Button,
    Drawer,
    InputLabel,
    MenuItem,
    OutlinedInput,
    Select,
    SelectChangeEvent,
    TextField,
    Theme,
    useTheme
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

export default function AddLogEntry(props: {
    requestor: AxiosInstance,
    eventTypes: string[],
    plants: plant[],
    open: boolean,
    setOpen: (arg: boolean) => void,
    updateLog: (arg: diaryEntry) => void,
}) {
    const [date, setDate] = useState<Dayjs | null>(dayjs(new Date()));
    const theme = useTheme();
    const [selectedPlantName, setSelectedPlantName] = useState<string[]>([]);
    const [selectedEventType, setSelectedEventType] = useState<string[]>([]);
    const [note, setNote] = useState<string>();
    const [loading, setLoading] = useState<boolean>(false);
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

    function getStyles(name: string, plantName: string[], theme: Theme) {
        return {
            fontWeight:
                plantName.indexOf(name) === -1
                    ? theme.typography.fontWeightRegular
                    : theme.typography.fontWeightMedium,
        };
    };

    const handleChange = (event: SelectChangeEvent<typeof selectedPlantName>) => {
        const {
            target: { value },
        } = event;
        setSelectedPlantName(
            // On autofill we get a stringified value.
            typeof value === 'string' ? value.split(',') : value,
        );
    };

    function getEventTypeStyles(name: string, eventName: string[], theme: Theme) {
        return {
            fontWeight:
                eventName.indexOf(name) === -1
                    ? theme.typography.fontWeightRegular
                    : theme.typography.fontWeightMedium,
        };
    };

    const handleEventTypeChange = (event: SelectChangeEvent<typeof selectedEventType>) => {
        const {
            target: { value },
        } = event;
        setSelectedEventType(
            // On autofill we get a stringified value.
            typeof value === 'string' ? value.split(',') : value,
        );
    };

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
                <Box>
                    <InputLabel id="plants-names">Name</InputLabel>
                    <Select
                        labelId="plants-names"
                        fullWidth
                        required
                        multiple
                        value={selectedPlantName}
                        onChange={handleChange}
                        MenuProps={MenuProps}
                        placeholder="Plants names"
                        input={<OutlinedInput label="Name" />}
                    >
                        {props.plants.map((entity) => (
                            <MenuItem
                                key={entity.id}
                                value={entity.personalName}
                                style={getStyles(entity.personalName, selectedPlantName, theme)}
                            >
                                {entity.personalName}
                            </MenuItem>
                        ))}
                    </Select>
                </Box>

                <Box>
                    <InputLabel id="event-type">Type</InputLabel>
                    <Select
                        labelId="event-type"
                        fullWidth
                        multiple
                        required
                        value={selectedEventType}
                        onChange={handleEventTypeChange}
                        MenuProps={MenuProps}
                        input={<OutlinedInput label="Event type" />}
                    >
                        {props.eventTypes.map((type) => (
                            <MenuItem
                                key={type}
                                value={type}
                                style={getEventTypeStyles(type, selectedEventType, theme)}
                            >
                                {titleCase(type)}
                            </MenuItem>
                        ))}
                    </Select>
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

            {/* <Button sx={{
                backgroundColor: "primary.main",
                color: "white",
                width: "90%",
                margin: "0 auto",
                marginBottom: "20px",
                padding: "15px",
            }}
                onClick={addEvent}
            >Save event</Button> */}
            {/* <LoadingButton
                loading={loading}
                loadingPosition="center"
                sx={{
                    backgroundColor: "primary.main",
                    color: "secondary",
                    width: "90%",
                    margin: "0 auto",
                    marginBottom: "20px",
                    padding: "15px",
                }}
                variant="contained"
                onClick={addEvent}
            >
                Save event
            </LoadingButton> */}
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