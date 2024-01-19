import { Accordion, AccordionDetails, AccordionSummary, Avatar, Box, Button, Chip, Dialog, DialogActions, DialogContent, DialogContentText, FormControl, FormHelperText, IconButton, InputAdornment, InputLabel, OutlinedInput, TextField, Typography } from "@mui/material";
import LogoutRoundedIcon from '@mui/icons-material/LogoutRounded';
import secureLocalStorage from "react-secure-storage";
import { NavigateFunction, useNavigate } from "react-router-dom";
import { useEffect, useState } from "react";
import { AxiosInstance } from "axios";
import ArrowForwardIcon from '@mui/icons-material/ArrowForward';
import NewReleasesIcon from '@mui/icons-material/NewReleases';
import LaunchIcon from '@mui/icons-material/Launch';
import ArrowForwardIosSharpIcon from '@mui/icons-material/ArrowForwardIosSharp';
import "../style/Settings.scss";
import Visibility from "@mui/icons-material/Visibility";
import VisibilityOff from "@mui/icons-material/VisibilityOff";

function UsernameDialog(props: {
    open: boolean,
    close: () => void,
    username: string,
    requestor: AxiosInstance,
    printError: (msg: any) => void,
    confirmCallBack: () => void;
}) {
    const [authenticatedUserId, setAuthenticatedUserId] = useState<string>();
    const [newUsername, setNewUsername] = useState<string>(props.username);
    const [newUsernameError, setNewUsernameError] = useState<string>();

    const changeUsername = (newUsername: string): Promise<void> => {
        return new Promise((accept, reject) => {
            if (authenticatedUserId === undefined) {
                props.printError("Could not get user ID");
                return reject();
            }
            props.requestor.put("/user", {
                id: authenticatedUserId,
                username: newUsername,
            })
                .then(_res => {
                    secureLocalStorage.setItem("plant-it-username", newUsername);
                    accept();
                })
                .catch(err => {
                    props.printError(err);
                    reject();
                });
        });
    };

    const checkUsernameConstraintThenExecThenCallback = (): void => {
        if (newUsername.length > 20 || newUsername.length < 3) {
            setNewUsernameError("username length must be between 3 and 20");
            return;
        }
        props.requestor.get(`/user/${newUsername}/_available`)
            .then(res => {
                if (res.data) {
                    changeUsername(newUsername)
                        .then(props.confirmCallBack)
                        .catch(props.printError);
                } else {
                    setNewUsernameError("username already taken");
                }
            })
            .catch(props.printError);
    };

    const changeNewUsername = (value: string): void => {
        setNewUsernameError(undefined);
        setNewUsername(value);
    };

    const getAuthenticatedUserID = (): void => {
        props.requestor.get("/user")
            .then(res => {
                setAuthenticatedUserId(res.data.id);
            })
            .catch(props.printError);
    };

    useEffect(() => {
        getAuthenticatedUserID();
    }, []);

    return <Dialog open={props.open} onClose={props.close}>
        <DialogContent>
            <DialogContentText>
                Insert the new username
            </DialogContentText>
            <TextField
                autoFocus
                margin="normal"
                type="text"
                fullWidth
                variant="standard"
                value={newUsername}
                error={newUsernameError != undefined}
                helperText={newUsernameError}
                placeholder="New username"
                required
                onChange={(event => changeNewUsername(event.target.value))}
            />
        </DialogContent>
        <DialogActions>
            <Button onClick={props.close}>Cancel</Button>
            <Button onClick={checkUsernameConstraintThenExecThenCallback}>Confirm</Button>
        </DialogActions>
    </Dialog>;
}


function PasswordDialog(props: {
    open: boolean,
    close: () => void,
    requestor: AxiosInstance,
    printError: (msg: any) => void,
    confirmCallBack: () => void;
}) {
    const [showCurrentPassword, setShowCurrentPassword] = useState<boolean>(false);
    const [showNewPassword, setShowNewPassword] = useState<boolean>(false);
    const [currentPassword, setCurrentPassword] = useState<string>("");
    const [newPassword, setNewPassword] = useState<string>("");
    const [newPasswordError, setNewPasswordError] = useState<string>();

    const checkPasswordConstraintThenExecThenCallback = (): void => {
        if (newPassword.length > 20 || newPassword.length < 8) {
            setNewPasswordError("password length must be between 8 and 20");
            return;
        }
        props.requestor.put(`/user/_password`, {
            currentPassword: currentPassword,
            newPassword: newPassword,
        })
            .then(props.confirmCallBack)
            .catch(props.printError);
    };

    const changeNewPassword = (value: string): void => {
        setNewPasswordError(undefined);
        setNewPassword(value);
    };


    return <Dialog open={props.open} onClose={props.close}>
        <DialogContent>
            <DialogContentText>
                Insert the new password
            </DialogContentText>
            <FormControl fullWidth margin="normal" variant="outlined" required>
                <InputLabel htmlFor="current-password-input">Current password</InputLabel>
                <OutlinedInput
                    id="current-password-input"
                    type={showCurrentPassword ? 'text' : 'password'}
                    onChange={(e) => setCurrentPassword(e.target.value)}
                    endAdornment={
                        <InputAdornment position="end">
                            <IconButton
                                aria-label="toggle password visibility"
                                onClick={() => setShowCurrentPassword(!showCurrentPassword)}
                                edge="end"
                            >
                                {showCurrentPassword ? <VisibilityOff /> : <Visibility />}
                            </IconButton>
                        </InputAdornment>
                    }
                    label="Current password"
                />
            </FormControl>
            <FormControl fullWidth margin="normal" variant="outlined" required>
                <InputLabel htmlFor="new-password-input">New password</InputLabel>
                <OutlinedInput
                    id="new-password-input"
                    type={showNewPassword ? 'text' : 'password'}
                    onChange={(e) => changeNewPassword(e.target.value)}
                    endAdornment={
                        <InputAdornment position="end">
                            <IconButton
                                aria-label="toggle password visibility"
                                onClick={() => setShowNewPassword(!showNewPassword)}
                                edge="end"
                            >
                                {showNewPassword ? <VisibilityOff /> : <Visibility />}
                            </IconButton>
                        </InputAdornment>
                    }
                    label="New password"
                    error={newPasswordError != undefined}
                />
                {
                    newPasswordError != undefined &&
                    <FormHelperText error>
                        {newPasswordError}
                    </FormHelperText>
                }
            </FormControl>
        </DialogContent>
        <DialogActions>
            <Button onClick={props.close}>Cancel</Button>
            <Button onClick={checkPasswordConstraintThenExecThenCallback}>Confirm</Button>
        </DialogActions>
    </Dialog>;
}

function SettingsEntry(props: {
    text: string,
    right: React.JSX.Element,
    onClick?: () => void;
}) {
    return <Box
        sx={{
            backgroundColor: "background.paper",
            borderRadius: "10px",
            display: "flex",
            justifyContent: "space-between",
            padding: "15px",
        }}
        onClick={props.onClick}
    >
        <Box>{props.text}</Box>
        {props.right}
    </Box>;
}

function SettingsHeader(props: {
    username: string;
}) {
    return <Box sx={{
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        gap: "10px",
    }}>
        <Avatar
            alt={props.username}
            src="/static/images/avatar/1.jpg"
            sx={{
                width: "20%",
                height: "auto",
                aspectRatio: 1,
            }}
        />
        <Typography
            variant="body1"
            style={{ fontWeight: 600 }}
        >
            {props.username}
        </Typography>
    </Box>;
}

function StatsSection(props: {
    title: string,
    value: number;
}) {
    return (
        <Box sx={{
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            width: "45%",
            borderRadius: "5px",
            backgroundColor: "background.default",
            padding: "15px",
        }}>
            <Box>
                {props.title}
            </Box>
            <Box>
                {props.value}
            </Box>
        </Box>
    );
}

function Stats(props: {
    requestor: AxiosInstance,
    visibility: boolean,
    printError: (err: any) => void;
}) {
    const [expanded, setExpanded] = useState<boolean>(true);
    const [totalEvents, setTotalEvents] = useState<number>(0);
    const [totalPlants, setTotalPlants] = useState<number>(0);
    const [totalBotanicalInfo, setTotalBotanicalInfo] = useState<number>(0);
    const [totalPhotos, setTotalPhotos] = useState<number>(0);
    const [erorr, setError] = useState<boolean>(false);

    useEffect(() => {
        if (props.visibility && !erorr) {
            props.requestor.get("diary/entry/_count")
                .then(res => setTotalEvents(res.data))
                .catch(err => {
                    setError(true);
                    props.printError(err);
                });
            props.requestor.get("plant/_count")
                .then(res => setTotalPlants(res.data))
                .catch(err => {
                    setError(true);
                    props.printError(err);
                });
            props.requestor.get("plant/_countBotanicalInfo")
                .then(res => setTotalBotanicalInfo(res.data))
                .catch(err => {
                    setError(true);
                    props.printError(err);
                });
            props.requestor.get("image/entity/_count")
                .then(res => setTotalPhotos(res.data))
                .catch(err => {
                    setError(true);
                    props.printError(err);
                });
        }
    });

    return (
        <Accordion
            disableGutters
            square
            elevation={0}
            expanded={expanded}
            onChange={(_event: React.SyntheticEvent, newExpanded: boolean) => setExpanded(newExpanded)}
            sx={{
                backgroundColor: "background.paper",
                borderRadius: "10px",
                '&:not(:last-child)': {
                    borderBottom: 0,
                },
                '&:before': {
                    display: 'none',
                },
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
                }}>
                    <Box
                        sx={{
                            display: "flex",
                            alignItems: "center",
                            gap: "5px",
                            padding: 0,
                        }}
                    >
                        <Typography>Stats</Typography>
                    </Box>
                </Box>
            </AccordionSummary>
            <AccordionDetails
                sx={{
                    display: "flex",
                    gap: "10px",
                    justifyContent: "center",
                    flexWrap: "wrap",
                }}
            >
                <StatsSection
                    title="Events"
                    value={totalEvents}
                />
                <StatsSection
                    title="Plants"
                    value={totalPlants}
                />
                <StatsSection
                    title="Species"
                    value={totalBotanicalInfo}
                />
                <StatsSection
                    title="Photos"
                    value={totalPhotos}
                />
                {/* <Box sx={{ width: "45%" }} /> */}
            </AccordionDetails>
        </Accordion>
    );
}


export default function Settings(props: {
    requestor: AxiosInstance,
    visibility: boolean,
    printError: (err: any) => void;
}) {
    let navigate: NavigateFunction = useNavigate();
    const username = secureLocalStorage.getItem("plant-it-username") as string;
    const [version, setVersion] = useState<{ current?: string, latest: boolean }>({ latest: true });
    const [usernameDialogOpen, setUsernameDialogOpen] = useState<boolean>(false);
    const [passwordDialogOpen, setPasswordDialogOpen] = useState<boolean>(false);
    const repoLink = "https://github.com/MDeLuise/plant-it";
    const repoOpenIssues = "https://github.com/MDeLuise/plant-it/issues/new/choose";
    const repoLastVersion = "https://github.com/MDeLuise/plant-it/releases/latest";

    const logout = (): void => {
        secureLocalStorage.removeItem("plant-it-key");
        navigate("/auth");
    };

    const getVersion = (): void => {
        props.requestor.get("/info/version")
            .then(res => setVersion({current: res.data.currentVersion, latest: res.data.isLatest }))
            .catch(props.printError);
    };

    const navigateTo = (url: string): void => {
        var anchor = document.createElement('a');
        anchor.href = url;
        anchor.target = "_blank";
        anchor.click();
    };

    useEffect(() => {
        getVersion();
    }, []);

    return <Box sx={{
        display: "flex",
        gap: "10px",
        flexDirection: "column",
    }}>

        <UsernameDialog
            open={usernameDialogOpen}
            requestor={props.requestor}
            printError={props.printError}
            close={() => setUsernameDialogOpen(false)}
            username={username}
            confirmCallBack={() => {
                setUsernameDialogOpen(false);
            }}
        />

        <PasswordDialog
            open={passwordDialogOpen}
            requestor={props.requestor}
            printError={props.printError}
            close={() => setPasswordDialogOpen(false)}
            confirmCallBack={() => {
                setPasswordDialogOpen(false);
            }}
        />

        <SettingsHeader username={username} />

        <Box className={"setting-section"}>
            <SettingsEntry
                text="Change username"
                right={<ArrowForwardIcon sx={{
                    opacity: .5,
                }} />}
                onClick={() => {
                    setUsernameDialogOpen(true);
                }}
            />
            <SettingsEntry
                text="Change password"
                right={<ArrowForwardIcon sx={{
                    opacity: .5,
                }} />}
                onClick={() => {
                    setPasswordDialogOpen(true);
                }}
            />
        </Box>

        <Stats
            requestor={props.requestor}
            visibility={props.visibility}
            printError={props.printError}
        />
        <Box className={"setting-section"}>
            <SettingsEntry
                text="App version"
                right={
                    <Box sx={{ display: 'flex', gap: '10px' }}>
                        <Typography>
                            {version.current}
                        </Typography>
                        {
                            version.latest ||
                            <NewReleasesIcon sx={{ color: "primary.main" }} />
                        }
                    </Box>
                }
                onClick={version.latest ? undefined : () => navigateTo(repoLastVersion)}
            />
            <SettingsEntry
                text="Open source"
                right={<LaunchIcon sx={{
                    opacity: .5,
                }} />}
                onClick={() => navigateTo(repoLink)}
            />
            <SettingsEntry
                text="Report issue"
                right={<LaunchIcon sx={{
                    opacity: .5,
                }} />}
                onClick={() => navigateTo(repoOpenIssues)}
            />
        </Box>
        <Box>
            <Button
                variant="contained"
                color="error"
                fullWidth
                onClick={logout}
                startIcon={<LogoutRoundedIcon />}
            >
                Log out
            </Button>
        </Box>
    </Box>;
}