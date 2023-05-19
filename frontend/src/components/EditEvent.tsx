import {
    Box,
    Button,
    Dialog,
    DialogActions,
    DialogContent,
    DialogContentText,
    DialogTitle,
    Drawer,
    InputLabel,
    MenuItem,
    OutlinedInput,
    Select,
    TextField,
    alpha,
} from "@mui/material";
import { AxiosInstance } from "axios";
import React, { useEffect, useState } from "react";
import { diaryEntry, plant } from "../interfaces";
import { titleCase } from "../common";
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs';
import dayjs, { Dayjs } from 'dayjs';
import { DatePicker, LocalizationProvider } from "@mui/x-date-pickers";
import { GrClose } from "react-icons/gr";
import EditOutlinedIcon from '@mui/icons-material/EditOutlined';
import DeleteOutlinedIcon from '@mui/icons-material/DeleteOutlined';
import SaveOutlinedIcon from '@mui/icons-material/SaveOutlined';
import ClearOutlinedIcon from '@mui/icons-material/ClearOutlined';


function ConfirmDialog(props: {
    open: boolean,
    close: () => void,
    confirm: () => void,
    title: string,
    text: string;
}) {
    return (
        <Dialog
            open={props.open}
            onClose={props.close}
        >
            <DialogTitle>
                {props.title}
            </DialogTitle>
            <DialogContent>
                <DialogContentText>
                    {props.text}
                </DialogContentText>
            </DialogContent>
            <DialogActions>
                <Button onClick={props.close}>
                    Cancel
                </Button>
                <Button onClick={props.confirm} autoFocus>
                    Ok
                </Button>
            </DialogActions>
        </Dialog>
    );
}


export default function EditEvent(props: {
    requestor: AxiosInstance,
    eventTypes: string[],
    plants: plant[],
    updateLog: (arg: diaryEntry) => void,
    toEdit?: diaryEntry,
    open: boolean,
    setOpen: (arg: boolean) => void,
    removeFromLog: (arg: number) => void;
}) {
    const [date, setDate] = useState<Dayjs>(dayjs());
    const [selectedPlantName, setSelectedPlantName] = useState<string>();
    const [selectedEventType, setSelectedEventType] = useState<string>();
    const [note, setNote] = useState<string>();
    const [loading, setLoading] = useState<boolean>(false);
    const [edit, setEdit] = useState<boolean>(false);
    const [confirmDialogOpen, setConfirmDialogOpen] = useState<boolean>(false);
    const [confirmDialogTitle, setConfirmDialogTitle] = useState<string>("");
    const [confirmDialogText, setConfirmDialogText] = useState<string>("");
    const [confirmDialogCallback, setConfirmDialogCallback] = useState<() => void>(() => () => { });

    const updateEvent = (): void => {
        let newTarget: plant = props.plants.filter((en) => en.personalName === selectedPlantName)[0];
        props.requestor.put(`/diary/entry/${props.toEdit?.id}`, {
            type: selectedEventType,
            note: note,
            date: date,
            diaryId: newTarget.diaryId,
        })
            .then((res) => {
                props.removeFromLog(props.toEdit?.id!);
                props.updateLog(res.data);
                props.setOpen(false);
                setEdit(false);
            });
    };

    const deleteEvent = (): void => {
        props.requestor.delete(`/diary/entry/${props.toEdit?.id}`)
            .then((_res) => {
                props.removeFromLog(props.toEdit?.id!);
                props.setOpen(false);
                setEdit(false);
                setConfirmDialogOpen(false);
            });
    };

    useEffect(() => {
        setSelectedPlantName(props.toEdit?.diaryTargetPersonalName);
        setSelectedEventType(props.toEdit?.type);
        setDate(dayjs(props.toEdit?.date));
        setNote(props.toEdit?.note);
        setEdit(false);
        setConfirmDialogCallback(() => deleteEvent);
    }, [props.toEdit]);

    return (
        <>
            <ConfirmDialog
                open={confirmDialogOpen}
                close={() => setConfirmDialogOpen(false)}
                text={confirmDialogText}
                title={confirmDialogTitle}
                confirm={confirmDialogCallback}
            />
            <Drawer
                anchor={"bottom"}
                open={props.open}
                onClose={() => {
                    props.setOpen(false);
                    setEdit(false);
                }}
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
                        height: "95vh",
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
                            value={selectedPlantName}
                            onChange={(event) => setSelectedPlantName(event.target.value)}
                            placeholder="Plants names"
                            input={<OutlinedInput label="Name" />}
                            disabled={!edit}
                        >
                            {props.plants.map((entity) => (
                                <MenuItem
                                    key={entity.id}
                                    value={entity.personalName}
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
                            required
                            value={selectedEventType}
                            onChange={(event) => setSelectedEventType(event.target.value)}
                            input={<OutlinedInput label="Event type" />}
                            disabled={!edit}
                        >
                            {props.eventTypes.map((type) => (
                                <MenuItem
                                    key={type}
                                    value={type}
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
                                onChange={(newValue) => setDate(newValue!)}
                                slotProps={{ textField: { fullWidth: true } }}
                                format="DD/MM/YYYY"
                                disabled={!edit}
                            />
                        </LocalizationProvider>
                    </Box>

                    <Box sx={{ width: "100%" }}>
                        <TextField
                            label="Note"
                            multiline
                            rows={4}
                            onChange={(event) => setNote(event.target.value)}
                            disabled={!edit}
                            fullWidth
                            value={note}
                        />
                    </Box>

                    <Box sx={{
                        display: "flex",
                        flexDirection: "row",
                        flexGrow: 1,
                        alignItems: "end",
                        gap: "10px",
                    }}
                    >
                        <Button sx={{
                            width: "100%",
                            margin: "0 auto",
                            marginBottom: "20px",
                            padding: "15px",
                            display: edit ? "none" : "flex",
                        }}
                            disabled={loading}
                            onClick={() => {
                                setConfirmDialogTitle("Confirm deletion");
                                setConfirmDialogText("Are you sure to remove the selected event? This operation cannot be reverted.");
                                setConfirmDialogCallback(() => deleteEvent);
                                setConfirmDialogOpen(true);
                            }}
                            startIcon={<DeleteOutlinedIcon />}
                            color="error"
                            variant="contained"
                        >
                            Remove
                        </Button>
                        <Button sx={{
                            backgroundColor: loading ? alpha("#3a5e49", .7) : "primary.main",
                            color: "white",
                            width: "100%",
                            margin: "0 auto",
                            marginBottom: "20px",
                            padding: "15px",
                            display: edit ? "none" : "flex",
                        }}
                            disabled={loading}
                            onClick={() => setEdit(true)}
                            startIcon={<EditOutlinedIcon />}
                        >
                            Edit
                        </Button>
                        <Button sx={{
                            color: "white",
                            width: "100%",
                            margin: "0 auto",
                            marginBottom: "20px",
                            padding: "15px",
                            display: edit ? "flex" : "none",
                        }}
                            disabled={loading}
                            onClick={() => {
                                setEdit(false);
                                props.setOpen(false);
                            }}
                            startIcon={<ClearOutlinedIcon />}
                            color="error"
                            variant="contained"
                        >
                            Cancel
                        </Button>
                        <Button sx={{
                            backgroundColor: loading ? alpha("#3a5e49", .7) : "primary.main",
                            color: "white",
                            width: "100%",
                            margin: "0 auto",
                            marginBottom: "20px",
                            padding: "15px",
                            display: edit ? "flex" : "none",
                        }}
                            disabled={loading}
                            onClick={updateEvent}
                            startIcon={<SaveOutlinedIcon />}
                        >
                            Update
                        </Button>
                    </Box>
                </Box>
            </Drawer>
        </>
    );
}