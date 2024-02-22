import { AxiosInstance } from "axios";
import { reminder } from "../interfaces";
import { Dialog, DialogContent, FormGroup, DialogActions, Button, DialogTitle, InputLabel, OutlinedInput, Select, MenuItem, Box, Switch, TextField } from "@mui/material";
import { useEffect, useState } from "react";
import { titleCase } from "../common";
import { LocalizationProvider, DatePicker } from "@mui/x-date-pickers";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import CheckBox from "@mui/icons-material/CheckBox";
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
    const [enabled, setEnabled] = useState<boolean>(true);
    const [plantId, setPlantId] = useState<number>();

    useEffect(() => {
        if (props.entity) {
            setUpdatedReminder(props.entity);
            setEnabled(props.entity.enabled);
            setUseEndDate(props.entity.end != undefined);
        } else {
            setUpdatedReminder({
                action: "SEEDING",
                start: new Date(),
                enabled: true,
                frequency: {
                    quantity: 0,
                    unit: "DAYS",
                }
            });
            setEnabled(true);
            setUseEndDate(false);
        }
    }, [props.entity]);


    useEffect(() => {
        setPlantId(props.plantId);
    }, [props.plantId]);


    useEffect(() => {
        props.requestor.get("/diary/entry/type")
            .then(res => setEventTypes(res.data))
            .catch(props.printError);
    }, []);


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
                    defaultValue={updatedReminder.action || "SEEDING"}
                    onChange={event => updatedReminder.action = event.target.value}
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
                            onChange={newValue => updatedReminder.start = newValue?.toDate()}
                            slotProps={{ textField: { fullWidth: true } }}
                            format="DD/MM/YYYY"
                        />
                    </LocalizationProvider>
                </Box>

                <Box sx={{ width: "100%", margin: "20px 0" }}>
                    <InputLabel>Frequency</InputLabel>
                    <Box sx={{ display: "flex", gap: "5px", justifyContent: "center", }}>
                        <TextField
                            defaultValue={updatedReminder.frequency?.quantity}
                            type="number"
                            variant="standard"
                            InputProps={{ disableUnderline: false }}
                            onChange={e => {
                                updatedReminder.frequency!.quantity = Number(e.target.value);
                            }}
                            sx={{
                                width: "45%",
                            }}
                        />
                        <Select
                            fullWidth
                            required
                            defaultValue={updatedReminder.frequency?.unit}
                            onChange={event => {
                                const value = event.target.value as "DAYS" | "WEEKS" | "MONTHS" | "YEARS";
                                updatedReminder.frequency!.unit = value;
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
                                updatedReminder.end = e.target.checked ? selectedEndDate?.toDate() : undefined;
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
                                    updatedReminder.end = newValue.toDate();
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
                            setEnabled(e.target.checked);
                            updatedReminder.enabled = e.target.checked
                        }}
                        checked={enabled}
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
