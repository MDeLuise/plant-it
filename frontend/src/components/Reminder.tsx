import { List, ListItem, ListItemAvatar, Avatar, ListItemText, Typography, Box, Switch } from "@mui/material";
import { reminder } from "../interfaces";
import WaterDropOutlinedIcon from '@mui/icons-material/WaterDropOutlined';
import YardOutlinedIcon from '@mui/icons-material/YardOutlined';
import AutorenewOutlinedIcon from '@mui/icons-material/AutorenewOutlined';
import QuestionMarkOutlinedIcon from '@mui/icons-material/QuestionMarkOutlined';
import LunchDiningOutlinedIcon from '@mui/icons-material/LunchDiningOutlined';
import BatterySaverOutlinedIcon from '@mui/icons-material/BatterySaverOutlined';
import VisibilityOutlinedIcon from '@mui/icons-material/VisibilityOutlined';
import ShowerOutlinedIcon from '@mui/icons-material/ShowerOutlined';
import ScienceOutlinedIcon from '@mui/icons-material/ScienceOutlined';
import WavesOutlinedIcon from '@mui/icons-material/WavesOutlined';
import ContentCutIcon from '@mui/icons-material/ContentCut';
import ChildCareIcon from '@mui/icons-material/ChildCare';
import AddHomeIcon from '@mui/icons-material/AddHome';
import AddCircleRoundedIcon from '@mui/icons-material/AddCircleRounded';
import DeleteIcon from '@mui/icons-material/Delete';
import { ReactElement, useEffect, useState } from "react";
import { AxiosInstance } from "axios";
import { AddOrModifyReminder } from "./AddOrModifyReminder";
import ConfirmDeleteDialog from "./ConfirmDialog";

export function Reminder(props: {
    entity: reminder,
    setEnabled: (arg: boolean) => void,
    delete: () => void,
    onClick: () => void;
}) {
    const getTypeIcon = (type: string): ReactElement<any, any> => {
        switch (type.toLowerCase()) {
            case "watering": return <WaterDropOutlinedIcon />;
            case "seeding": return <YardOutlinedIcon />;
            case "transplanting": return <AddHomeIcon />;
            case "fertilizing": return <LunchDiningOutlinedIcon />;
            case "biostimulating": return <BatterySaverOutlinedIcon />;
            case "observation": return <VisibilityOutlinedIcon />;
            case "misting": return <ShowerOutlinedIcon />;
            case "treatment": return <ScienceOutlinedIcon />;
            case "water_changing": return <WavesOutlinedIcon />;
            case "propagating": return <ChildCareIcon />;
            case "pruning": return <ContentCutIcon />;
            case "repotting": return <AutorenewOutlinedIcon />;
            default: return <QuestionMarkOutlinedIcon />;
        }
    };

    const getTitle = (): string => {
        const unitStr: string = props.entity.frequency.unit.toLocaleLowerCase();
        return `Every ${props.entity.frequency.quantity} ${unitStr}`
    };

    const getDescription = (): string => {
        const startStr: string = `from ${new Date(props.entity.start).toLocaleDateString()}`;
        const endStr: string = props.entity.end ? ` to ${new Date(props.entity.end).toLocaleDateString()}` : "";
        return startStr + endStr;
    };

    return <ListItem
        disableGutters={true}
        sx={{
            padding: 0,
        }}
    >
        <ListItemAvatar sx={{ padding: 0 }} onClick={props.onClick}>
            <Avatar>
                {getTypeIcon(props.entity.action)}
            </Avatar>
        </ListItemAvatar>
        <ListItemText primary={getTitle()} secondary={getDescription()} onClick={props.onClick} />
        <DeleteIcon onClick={props.delete} />
        <Switch
            edge="end"
            onChange={e => props.setEnabled(e.target.checked)}
            checked={props.entity.enabled}
        />
    </ListItem>
}


export function ReminderList(props: {
    plantId?: number,
    requestor: AxiosInstance,
    printError: (err: any) => void;
}) {
    const [reminders, setReminders] = useState<reminder[]>([]);
    const [editAddDialogOpen, setEditAddDialogOpen] = useState<boolean>(false);
    const [editDialogEntity, setEditDialogEntity] = useState<reminder>();
    const [confirmDialogStatus, setConfirmDialogStatus] = useState<{
        reminder?: reminder,
        open: boolean;
    }>({ open: false });

    const deleteReminder = (id: number): void => {
        props.requestor.delete(`reminder/${id}`)
            .then(_res => {
                const newReminders: reminder[] = reminders.filter(rem => rem.id !== id);
                setReminders(newReminders);
            })
            .catch(props.printError);
    };


    const toggleEnableReminder = (id: number, value: boolean): void => {
        const toChangeIndex: number = reminders.findIndex(rem => rem.id === id);
        const toUpdate: reminder = reminders[toChangeIndex];
        toUpdate.enabled = value;
        props.requestor.put(`/reminder/${toUpdate.id}`, toUpdate)
            .then(res => {
                const newReminders: reminder[] = [...reminders];
                newReminders[toChangeIndex] = res.data;
                setReminders(newReminders);
            })
            .catch(props.printError);
    };


    const addOrModifyReminder = (entity: reminder): void => {
        const toChangeIndex: number = reminders.findIndex(rem => rem.id === entity.id);
        if (toChangeIndex === -1) {
            const newReminders: reminder[] = [...reminders, entity];
            setReminders(newReminders);
        } else {
            const newReminders: reminder[] = [...reminders];
            newReminders[toChangeIndex] = entity;
            setReminders(newReminders);
        }
    };


    useEffect(() => {
        if (props.plantId) {
            props.requestor.get(`reminder/${props.plantId}`)
                .then(res => setReminders(res.data))
                .catch(props.printError)
        }
    }, [props.plantId]);

    return <Box>

        <ConfirmDeleteDialog
            open={confirmDialogStatus.open}
            close={() => setConfirmDialogStatus({ ...confirmDialogStatus, open: false })}
            printError={props.printError}
            confirmCallBack={() => {
                deleteReminder(confirmDialogStatus.reminder!.id)
                setConfirmDialogStatus({ ...confirmDialogStatus, open: false });
            }}
            text="Are you sure you want to delete the reminder?"
        />

        <AddOrModifyReminder
            requestor={props.requestor}
            printError={props.printError}
            open={editAddDialogOpen}
            setOpen={() => setEditAddDialogOpen(true)}
            onConfirm={() => setEditAddDialogOpen(false)}
            onClose={(arg?: reminder) => {
                if (arg) {
                    addOrModifyReminder(arg);
                }
                setEditAddDialogOpen(false);
            }}
            entity={editDialogEntity}
            plantId={props.plantId}
        />

        {
            reminders.length === 0 &&
            <Typography style={{ textDecoration: "italic" }}>No reminder yet</Typography>
        }

        <List sx={{ width: '100%', padding: 0 }}>
            {
                reminders.map(reminder => {
                    return <Reminder
                        entity={reminder}
                        delete={() => {
                            setConfirmDialogStatus({
                                reminder: reminder,
                                open: true
                            });
                        }}
                        setEnabled={arg => toggleEnableReminder(reminder.id, arg)}
                        key={reminder.id}
                        onClick={() => {
                            setEditDialogEntity(reminder);
                            setEditAddDialogOpen(true);
                        }}
                    />
                })
            }
        </List>
        <ListItem
            disableGutters={true}
            onClick={() => {
                setEditDialogEntity(undefined);
                setEditAddDialogOpen(true);
            }}
        >
            <ListItemAvatar>
                <Avatar sx={{
                    backgroundColor: "primary.main",
                }}>
                    <AddCircleRoundedIcon />
                </Avatar>
            </ListItemAvatar>
            <ListItemText primary={"Add new"} color="primary.main" />
        </ListItem>
    </Box>
}
