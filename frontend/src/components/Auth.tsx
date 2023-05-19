import { useState } from "react";
import { AxiosInstance } from 'axios';
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

export default function (props: { requestor: AxiosInstance }) {
    let navigate: NavigateFunction = useNavigate();
    let [authMode, setAuthMode] = useState<string>("signin");
    const [username, setUsername] = useState<string>("");
    const [password, setPassword] = useState<string>("");
    const [error, setError] = useState(null);
    const [showPassword, setShowPassword] = useState<boolean>(false);

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
            .catch(setError);
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
                    .catch(setError);
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
            .catch(setError);
    };

    const changeAuthMode = () => {
        setAuthMode(authMode === "signin" ? "signup" : "signin");
        setError(null);
    };

    return (
        <Box
            display="flex"
            justifyContent="center"
            alignItems="center"
            minHeight="100vh"
        >
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
                <p style={{ display: !error ? "none" : "initial" }} className="error text-center mt-3 mb-2">{error ? error["response"]["data"]["message"] : ""}</p>
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
                        onChange={(e) => setUsername(e.target.value)}
                    />
                    <FormControl fullWidth margin="normal" variant="outlined" required>
                        <InputLabel htmlFor="password-input">Password</InputLabel>
                        <OutlinedInput
                            id="password-input"
                            type={showPassword ? 'text' : 'password'}
                            onChange={(e) => setPassword(e.target.value)}
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
                        />
                    </FormControl>
                    <Button
                        type="submit"
                        fullWidth
                        variant="contained"
                        sx={{ mt: 3, mb: 2 }}
                    >
                        {authMode == "signin" ? "Login" : "Register"}
                    </Button>
                    <Grid container>
                        <Link href="#" variant="body2" onClick={changeAuthMode}>
                            {authMode == "signin" ? "Don't have an account? Sign Up" : "Already have an account? Sign In"}
                        </Link>
                    </Grid>
                </Box>
            </Box>
        </Box>
    );
}
