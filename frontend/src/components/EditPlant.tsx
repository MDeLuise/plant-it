import { Box, Button, Dialog, DialogActions, DialogContent, DialogContentText, Divider, Drawer, Switch, TextField, Typography } from "@mui/material";
import { AxiosInstance } from "axios";
import CloseIcon from '@mui/icons-material/Close';
import DeleteIcon from '@mui/icons-material/Delete';
import "../style/EditPlant.scss";
import { plant } from "../interfaces";
import { useEffect, useState } from "react";
import { LocalizationProvider, DatePicker } from "@mui/x-date-pickers";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import dayjs, { Dayjs } from "dayjs";
import SaveOutlinedIcon from '@mui/icons-material/SaveOutlined';

function ConfirmDeleteDialog(props: {
    open: boolean,
    close: () => void,
    printError: (msg: any) => void,
    confirmCallBack: () => void;
}) {
    return <Dialog open={props.open} onClose={props.close}>
        <DialogContent>
            <DialogContentText>
                Are you sure you want to delete the plant? This action can not be undone.
            </DialogContentText>
        </DialogContent>
        <DialogActions>
            <Button onClick={props.close}>Cancel</Button>
            <Button onClick={props.confirmCallBack}>Confirm</Button>
        </DialogActions>
    </Dialog>;
}


export default function EditPlant(props: {
    open: boolean,
    close: () => void,
    requestor: AxiosInstance,
    plant?: plant,
    printError: (arg: any) => void,
    updatePlant: (arg: plant) => void,
    onDelete: (arg?: plant) => void;
}) {
    const [plantName, setPlantName] = useState<string>();
    const [plantNameError, setPlantNameError] = useState<string>();
    const [date, setDate] = useState<Dayjs>(dayjs(new Date()));
    const [useDate, setUseDate] = useState<boolean>(false);
    const [family, setFamily] = useState<string>();
    const [genus, setGenus] = useState<string>();
    const [species, setSpecies] = useState<string>("");
    const [openConformDialog, setOpenConfirmDialog] = useState<boolean>(false);

    const updatePlant = (): void => {
        props.requestor.put("/plant", {
            ...props.plant,
            personalName: plantName,
            botanicalInfo: {
                ...props.plant?.botanicalInfo,
                family: family,
                genus: genus,
                species: species,
                scientificName: species,
                imageId: undefined,
                imageUrl: undefined,
            },
            state: "ALIVE",
            startDate: useDate ? date : null,
        })
            .then((res) => {
                props.updatePlant(res.data);
                props.close();
            })
            .catch((err) => {
                props.printError(err);
            });
    };

    const deletePlant = (): void => {
        props.requestor.delete(`plant/${props.plant?.id}`)
            .then((_res) => {
                props.onDelete(props.plant);
                props.close();
            })
            .catch((err) => {
                props.printError(err);
            });
    };

    useEffect(() => {
        setPlantName(props.plant?.personalName);
        setUseDate(props.plant?.startDate != undefined);
        if (props.plant?.startDate != undefined) {
            setDate(dayjs(props.plant?.startDate));
        }
        setFamily(props.plant?.botanicalInfo.family);
        setGenus(props.plant?.botanicalInfo.genus);
        if (props.plant != undefined) {
            setSpecies(props.plant?.botanicalInfo.species);
        }
    }, [props.plant]);

    return <Drawer
        anchor={"bottom"}
        open={props.open}
        onClose={props.close}
        id="edit-plant"
    >

        <ConfirmDeleteDialog
            open={openConformDialog}
            close={() => setOpenConfirmDialog(false)}
            printError={props.printError}
            confirmCallBack={deletePlant}
        />

        <Box sx={{
            height: "100vh",
            display: "flex",
            flexDirection: "column",
            width: "90%",
            alignItems: "center",
            margin: "0 auto",

        }}>
            <Box sx={{
                display: "flex",
                width: "100%",
                justifyContent: "space-between",
                alignItems: "center",
                padding: "10px 0px",
            }}>
                <CloseIcon
                    sx={{
                        backdropFilter: "blur(50px)",
                        color: "white",
                        borderRadius: "10px",
                        padding: "5px",
                        backgroundColor: "rgba(32, 32, 32, .5)",
                    }}
                    onClick={props.close}
                    fontSize="large"
                />
                <Typography variant="h6">
                    Edit plant
                </Typography>
                <Box sx={{
                    flexGrow: "grow",
                }}>
                </Box>
            </Box>

            <Box className="edit-section">
                <Divider>Info</Divider>
                <TextField
                    variant="outlined"
                    label="Name"
                    required
                    fullWidth
                    value={plantName}
                    onChange={(event) => setPlantName(event.target.value as string)}
                    error={plantNameError != undefined}
                    helperText={plantNameError}
                />
                <Box sx={{
                    display: "flex",
                    justifyContent: "space-between",
                    gap: "30px",
                    alignItems: "center",
                }}>
                    <Switch
                        checked={useDate}
                        onChange={(event) => setUseDate(event.target.checked)}
                    />
                    <LocalizationProvider dateAdapter={AdapterDayjs}>
                        <DatePicker
                            label="Date of purchase"
                            value={date}
                            disabled={!useDate}
                            onChange={(newValue) => setDate(newValue != undefined ? newValue : dayjs(new Date()))}
                            sx={{
                                flexGrow: 1
                            }}
                        />
                    </LocalizationProvider>
                </Box>
            </Box>
            <Box className="edit-section">
                <Divider>Scientific classification</Divider>
                <TextField
                    variant="outlined"
                    label="Family"
                    fullWidth
                    value={family || ""}
                    onChange={(event) => setFamily(event.target.value)}
                />
                <TextField
                    variant="outlined"
                    fullWidth
                    label="Genus"
                    value={genus || ""}
                    onChange={(event) => setGenus(event.target.value)}
                />
                <TextField
                    variant="outlined"
                    fullWidth
                    required
                    label="Species"
                    value={species}
                    onChange={(event) => setSpecies(event.target.value)}
                />
            </Box>

            <Box sx={{flexGrow: 1}} />

            <Button
                sx={{
                    backgroundColor: "primary.main",
                    color: "white",
                }}
                startIcon={<SaveOutlinedIcon />}
                onClick={updatePlant}
            >
                Update info
            </Button>
            <Button
                sx={{
                    backgroundColor: "rgba(255, 168, 168, .4)",
                    color: "red",
                    marginBottom: "30px !important",
                }}
                startIcon={<DeleteIcon />}
                onClick={() => setOpenConfirmDialog(true)}
            >
                Remove this plant
            </Button>
        </Box>
    </Drawer>;
}