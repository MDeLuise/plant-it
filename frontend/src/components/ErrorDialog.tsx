import { Button, Dialog, DialogActions, DialogContent, DialogTitle, Typography, styled } from "@mui/material";
import IconButton from '@mui/material/IconButton';
import CloseIcon from '@mui/icons-material/Close';

const BootstrapDialog = styled(Dialog)(({ theme }) => ({
    '& .MuiDialogContent-root': {
        padding: theme.spacing(2),
    },
    '& .MuiDialogActions-root': {
        padding: theme.spacing(1),
    },
}));

export default function ErrorDialog(props: {
    text?: string,
    open: boolean,
    close: () => void;
}) {
    return <div>
        <BootstrapDialog
            onClose={props.close}
            open={props.open}
        >
            <DialogTitle sx={{ m: 0, p: 2 }} >
                Error
            </DialogTitle>
            <IconButton
                aria-label="close"
                onClick={props.close}
                sx={{
                    position: 'absolute',
                    right: 8,
                    top: 8,
                    color: (theme) => theme.palette.grey[500],
                }}
            >
                <CloseIcon />
            </IconButton>
            <DialogContent dividers sx={{
                overflowWrap: "break-word",
            }}>
                <Typography gutterBottom>
                    {props.text}
                </Typography>
            </DialogContent>
            <DialogActions>
                <Button
                    autoFocus
                    onClick={props.close}
                    fullWidth
                >
                    Ok
                </Button>
            </DialogActions>
        </BootstrapDialog>
    </div>;
}