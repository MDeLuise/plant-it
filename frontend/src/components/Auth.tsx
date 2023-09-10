import { useEffect, useState } from "react";
import axios, { AxiosError, AxiosInstance } from 'axios';
import { NavigateFunction, useNavigate } from "react-router";
import secureLocalStorage from "react-secure-storage";
import Avatar from '@mui/material/Avatar';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import Link from '@mui/material/Link';
import Grid from '@mui/material/Grid';
import Box from '@mui/material/Box';
import LockOutlinedIcon from '@mui/icons-material/LockOutlined';
import PersonAddAltOutlinedIcon from '@mui/icons-material/PersonAddAltOutlined';
import Typography from '@mui/material/Typography';
import InputLabel from '@mui/material/InputLabel';
import InputAdornment from '@mui/material/InputAdornment';
import OutlinedInput from '@mui/material/OutlinedInput';
import IconButton from '@mui/material/IconButton';
import Visibility from '@mui/icons-material/Visibility';
import VisibilityOff from '@mui/icons-material/VisibilityOff';
import FormControl from '@mui/material/FormControl';
import { FormHelperText } from "@mui/material";
import ErrorDialog from "./ErrorDialog";
import { isBackendReachable } from "../common";

export default function (props: { requestor: AxiosInstance; }) {
    const navigate: NavigateFunction = useNavigate();
    const [authMode, setAuthMode] = useState<string>("signin");
    const [username, setUsername] = useState<string>("");
    const [password, setPassword] = useState<string>("");
    const [usernameError, setUsernameError] = useState<string>();
    const [passwordError, setPasswordError] = useState<string>();
    const [showPassword, setShowPassword] = useState<boolean>(false);
    const [errorDialogShown, setErrorDialogShown] = useState<boolean>(false);
    const [errorDialogText, setErrorDialogText] = useState<string>();

    const doLogin = (event: React.SyntheticEvent) => {
        event.preventDefault();
        props.requestor.defaults.headers.common['Key'] = undefined;
        props.requestor.post("authentication/login", {
            username: username,
            password: password
        })
            .then((response) => {
                let jwt = response.data["jwt"]["value"];
                getOrCreateApiKey(jwt);
                secureLocalStorage.setItem("plant-it-username", username);
            })
            .catch((err: AxiosError) => {
                setErrorDialogText((err.response?.data as any).message);
                setErrorDialogShown(true);
            });
    };

    const getOrCreateApiKey = (jwt: string) => {
        const apiKeyName: string = "frontend-app_" + username;
        props.requestor.get("api-key/name/" + apiKeyName, {
            headers: {
                "Authorization": 'Bearer ' + jwt
            }
        })
            .then((response) => {
                secureLocalStorage.setItem("plant-it-key", response.data.value);
                navigate('/');
            })
            .catch((_error) => {
                props.requestor.post("api-key/?name=" + apiKeyName, {}, {
                    headers: {
                        "Authorization": 'Bearer ' + jwt
                    }
                })
                    .then((response) => {
                        secureLocalStorage.setItem("plant-it-key", response.data);
                        navigate('/');
                    })
                    .catch((err) => {
                        setErrorDialogText((err.response?.data as any).message);
                        setErrorDialogShown(true);
                    });
            });
    };

    const signUp = (event: React.SyntheticEvent) => {
        event.preventDefault();
        props.requestor.post("authentication/signup", {
            username: username,
            password: password
        })
            .then((_response) => {
                doLogin(event);
            })
            .catch((err: AxiosError) => {
                setErrorDialogText((err.response?.data as any).message);
                setErrorDialogShown(true);
            });
    };

    const changeAuthMode = () => {
        setAuthMode(authMode === "signin" ? "signup" : "signin");
        setUsernameError(undefined);
        setPasswordError(undefined);
    };


    const changeUsername = (value: string): void => {
        if (authMode == "signup" && (value.length > 20 || value.length < 3)) {
            setUsernameError("username length must be between 3 and 20");
        } else {
            setUsernameError(undefined);
        }
        setUsername(value);
    };


    const changePassword = (value: string): void => {
        if (authMode == "signup" && (value.length > 20 || value.length < 8)) {
            setPasswordError("password length must be between 8 and 20");
        } else {
            setPasswordError(undefined);
        }
        setPassword(value);
    };


    const isSubmitButtonEnabled = (): boolean => {
        return (usernameError === undefined && passwordError === undefined) &&
            username.length > 0 && password.length > 0;
    };


    useEffect(() => {
        isBackendReachable(props.requestor)
            .then((res) => {
                if (!res) {
                    setErrorDialogText("Cannot connect to the backend");
                    setErrorDialogShown(true);
                }
            });
    }, []);

    return (
        <Box
            display="flex"
            justifyContent="center"
            alignItems="center"
            minHeight="100vh"
        >

            <ErrorDialog
                text={errorDialogText}
                open={errorDialogShown}
                close={() => setErrorDialogShown(false)}
            />

            <Box
                sx={{
                    marginTop: 8,
                    display: 'flex',
                    flexDirection: 'column',
                    alignItems: 'center',
                    width: "90vw"
                }}
            >
                <Avatar sx={{ m: 1, bgcolor: 'secondary.main' }}>
                    {authMode == "signin" ? <LockOutlinedIcon /> : <PersonAddAltOutlinedIcon />}
                </Avatar>
                <Typography component="h1" variant="h5">
                    {authMode == "signin" ? "Sign In" : "Sign Up"}
                </Typography>
                <Box component="form" onSubmit={authMode === "signin" ? doLogin : signUp} noValidate sx={{ mt: 1 }}>
                    <TextField
                        margin="normal"
                        required
                        fullWidth
                        id="username"
                        label="Username"
                        name="username"
                        autoComplete="username"
                        autoFocus
                        onChange={(e) => changeUsername(e.target.value)}
                        error={usernameError != undefined}
                        helperText={usernameError}
                    />
                    <FormControl fullWidth margin="normal" variant="outlined" required>
                        <InputLabel htmlFor="password-input">Password</InputLabel>
                        <OutlinedInput
                            id="password-input"
                            type={showPassword ? 'text' : 'password'}
                            onChange={(e) => changePassword(e.target.value)}
                            endAdornment={
                                <InputAdornment position="end">
                                    <IconButton
                                        aria-label="toggle password visibility"
                                        onClick={() => setShowPassword(!showPassword)}
                                        edge="end"
                                    >
                                        {showPassword ? <VisibilityOff /> : <Visibility />}
                                    </IconButton>
                                </InputAdornment>
                            }
                            label="Password"
                            error={passwordError != undefined}
                        />
                        {
                            passwordError != undefined &&
                            <FormHelperText error>
                                {passwordError}
                            </FormHelperText>
                        }
                    </FormControl>
                    <Button
                        type="submit"
                        fullWidth
                        variant="contained"
                        sx={{ mt: 3, mb: 2 }}
                        disabled={!isSubmitButtonEnabled()}
                    >
                        {authMode == "signin" ? "Login" : "Register"}
                    </Button>
                    <Grid container style={{ justifyContent: "center", }}>
                        <Link href="#" variant="body2" onClick={changeAuthMode}>
                            {authMode == "signin" ? "Don't have an account? Sign Up" : "Already have an account? Sign In"}
                        </Link>
                    </Grid>
                </Box>
            </Box>
        </Box>
    );
}
