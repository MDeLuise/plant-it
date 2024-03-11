import { AxiosInstance } from "axios";
import { reminder, reminderFrequency } from "../interfaces";
import { Dialog, DialogContent, FormGroup, DialogActions, Button, DialogTitle, InputLabel, OutlinedInput, Select, MenuItem, Box, Switch, TextField } from "@mui/material";
import { useEffect, useState } from "react";
import { titleCase } from "../common";
import { LocalizationProvider, DatePicker } from "@mui/x-date-pickers";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import dayjs, { Dayjs } from "dayjs";

export function AddOrModifyReminder(props: {
    requestor: AxiosInstance,
    plantId?: number,
    printError: (e: any) => void,
    entity?: reminder,
    open: boolean,
    setOpen: (arg: boolean) => void,
    onConfirm: () => void,
    onClose: (arg?: reminder) => void;
}) {
    const [updatedReminder, setUpdatedReminder] = useState<Partial<reminder>>({});
    const [eventTypes, setEventTypes] = useState<string[]>([]);
    const [selectedEndDate, setSelectedEndDate] = useState<Dayjs>(dayjs(new Date()));
    const [useEndDate, setUseEndDate] = useState<boolean>(false);
    const [plantId, setPlantId] = useState<number>();

    useEffect(() => {
        if (props.entity) {
            setUpdatedReminder(props.entity);
            setUseEndDate(props.entity.end != undefined);
        } else {
            cleanup();
        }
    }, [props.entity]);


    useEffect(() => {
        if (!props.open) {
            cleanup();
        }
    }, [props.open]);


    useEffect(() => {
        setPlantId(props.plantId);
    }, [props.plantId]);


    useEffect(() => {
        props.requestor.get("/diary/entry/type")
            .then(res => setEventTypes(res.data))
            .catch(props.printError);
    }, []);


    const cleanup = (): void => {
        setUpdatedReminder({
            action: "SEEDING",
            start: new Date(),
            enabled: true,
            frequency: {
                quantity: 0,
                unit: "DAYS",
            },
            repeatAfter: {
                quantity: 3,
                unit: "DAYS",
            },
        });
        //setEnabled(true);
        setUseEndDate(false);
    };


    const addOrEdit = (): void => {
        if (props.entity) {
            props.requestor.put(`reminder/${props.entity.id}`, updatedReminder)
                .then(res => props.onClose(res.data))
                .catch(props.printError);
        } else {
            props.requestor.post(`reminder`, { ...updatedReminder, targetId: plantId })
                .then(res => props.onClose(res.data))
                .catch(props.printError);
        }
    };

    return <Dialog open={props.open} onClose={() => props.onClose()}>
        <DialogContent>
            <DialogTitle sx={{ textAlign: "center" }}>
                {props.entity && "Edit reminder" || "Create reminder"}
            </DialogTitle>
            <FormGroup sx={{ display: "flex", }}>
                <InputLabel>Type</InputLabel>
                <Select
                    fullWidth
                    required
                    value={updatedReminder.action || "SEEDING"}
                    onChange={event => setUpdatedReminder({...updatedReminder, action: event.target.value})}
                    input={<OutlinedInput label="Event type" />}
                >
                    {
                        eventTypes.map(type => (
                            <MenuItem
                                key={type}
                                value={type}
                            >
                                {titleCase(type)}
                            </MenuItem>
                        ))
                    }
                </Select>

                <Box sx={{ width: "100%", margin: "20px 0" }}>
                    <InputLabel>Start date</InputLabel>
                    <LocalizationProvider dateAdapter={AdapterDayjs} >
                        <DatePicker
                            value={dayjs(updatedReminder.start)}
                            onChange={newValue => setUpdatedReminder({...updatedReminder, start: newValue?.toDate()})}
                            slotProps={{ textField: { fullWidth: true } }}
                            format="DD/MM/YYYY"
                        />
                    </LocalizationProvider>
                </Box>

                <Box sx={{ width: "100%", margin: "20px 0" }}>
                    <InputLabel>Frequency</InputLabel>
                    <Box sx={{ display: "flex", gap: "5px", justifyContent: "center", }}>
                        <TextField
                            value={updatedReminder.frequency?.quantity}
                            type="number"
                            variant="standard"
                            InputProps={{ disableUnderline: false }}
                            onChange={e => {
                                setUpdatedReminder((prevState: Partial<reminder>) => ({
                                    ...prevState!,
                                    frequency: {
                                        ...prevState.frequency,
                                        quantity: Number(e.target.value)
                                    } as reminderFrequency
                                }));
                            }}
                            sx={{
                                width: "45%",
                            }}
                        />
                        <Select
                            fullWidth
                            required
                            value={updatedReminder.frequency?.unit}
                            onChange={event => {
                                const value = event.target.value as "DAYS" | "WEEKS" | "MONTHS" | "YEARS";
                                setUpdatedReminder({...updatedReminder, frequency: {quantity: updatedReminder.frequency?.quantity || 0, unit: value}});
                            }}
                            sx={{
                                width: "45%",
                            }}
                            variant="standard"
                        >
                            <MenuItem
                                key={"DAYS"}
                                value={"DAYS"}
                            >
                                days
                            </MenuItem>
                            <MenuItem
                                key={"WEEKS"}
                                value={"WEEKS"}
                            >
                                weeks
                            </MenuItem>
                            <MenuItem
                                key={"MONTHS"}
                                value={"MONTHS"}
                            >
                                months
                            </MenuItem>
                            <MenuItem
                                key={"YEARS"}
                                value={"YEARS"}
                            >
                                years
                            </MenuItem>
                        </Select>
                    </Box>
                </Box>

                <Box sx={{ width: "100%", margin: "20px 0" }}>
                    <InputLabel>Repeat after</InputLabel>
                    <Box sx={{ display: "flex", gap: "5px", justifyContent: "center", }}>
                        <TextField
                            value={updatedReminder.repeatAfter?.quantity}
                            type="number"
                            variant="standard"
                            InputProps={{ disableUnderline: false }}
                            onChange={e => {
                                setUpdatedReminder((prevState: Partial<reminder>) => ({
                                    ...prevState!,
                                    repeatAfter: {
                                        ...prevState.repeatAfter,
                                        quantity: Number(e.target.value)
                                    } as reminderFrequency
                                }));
                            }}
                            sx={{
                                width: "45%",
                            }}
                        />
                        <Select
                            fullWidth
                            required
                            value={updatedReminder.repeatAfter?.unit}
                            onChange={event => {
                                const value = event.target.value as "DAYS" | "WEEKS" | "MONTHS" | "YEARS";
                                setUpdatedReminder({...updatedReminder, repeatAfter: {quantity: updatedReminder.repeatAfter?.quantity || 0, unit: value}});
                            }}
                            sx={{
                                width: "45%",
                            }}
                            variant="standard"
                        >
                            <MenuItem
                                key={"DAYS"}
                                value={"DAYS"}
                            >
                                days
                            </MenuItem>
                            <MenuItem
                                key={"WEEKS"}
                                value={"WEEKS"}
                            >
                                weeks
                            </MenuItem>
                            <MenuItem
                                key={"MONTHS"}
                                value={"MONTHS"}
                            >
                                months
                            </MenuItem>
                            <MenuItem
                                key={"YEARS"}
                                value={"YEARS"}
                            >
                                years
                            </MenuItem>
                        </Select>
                    </Box>
                </Box>

                <Box sx={{ width: "100%", margin: "20px 0" }}>
                    <InputLabel>
                        End date
                        <Switch
                            onChange={e => {
                                setUseEndDate(e.target.checked);
                                setUpdatedReminder({...updatedReminder, end: e.target.checked ? selectedEndDate.toDate() : undefined}); 
                            }}
                            checked={useEndDate}
                        />
                    </InputLabel>


                    <LocalizationProvider dateAdapter={AdapterDayjs} >
                        <DatePicker
                            value={dayjs(updatedReminder.end)}
                            onChange={newValue => {
                                if (newValue) {
                                    setSelectedEndDate(newValue);
                                    setUpdatedReminder({...updatedReminder, end: newValue.toDate()});
                                }
                            }}
                            slotProps={{ textField: { fullWidth: true } }}
                            format="DD/MM/YYYY"
                            disabled={!useEndDate}
                        />
                    </LocalizationProvider>
                </Box>

                <Box sx={{ width: "100%", margin: "20px 0" }}>
                    <InputLabel>Enabled</InputLabel>
                    <Switch
                        onChange={e => {
                            //setEnabled(e.target.checked);
                            setUpdatedReminder({...updatedReminder, enabled: e.target.checked});
                        }}
                        checked={updatedReminder.enabled}
                    />
                </Box>
            </FormGroup>
        </DialogContent>
        <DialogActions>
            <Button onClick={() => props.onClose()}>Cancel</Button>
            <Button onClick={addOrEdit}>Confirm</Button>
        </DialogActions>
    </Dialog>;
}
