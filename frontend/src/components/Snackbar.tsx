import { Snackbar, Alert, AlertColor } from "@mui/material";

export function Snackbars(props: {
    open: boolean,
    severity: AlertColor,
    text: string,
    setOpen: (arg: boolean) => void;
}) {

    const handleClose = (_event?: React.SyntheticEvent | Event, reason?: string) => {
        if (reason === 'clickaway') {
            return;
        }
        props.setOpen(false);
    };

    return (
        <div>
            <Snackbar
                open={props.open}
                autoHideDuration={5000}
                onClose={handleClose}
                anchorOrigin={{
                    vertical: "top",
                    horizontal: "center"
                }}
            >
                <Alert
                    onClose={handleClose}
                    severity={props.severity}
                    variant="filled"
                    sx={{ width: '100%' }}
                >
                    {props.text}
                </Alert>
            </Snackbar>
        </div>
    );
}
