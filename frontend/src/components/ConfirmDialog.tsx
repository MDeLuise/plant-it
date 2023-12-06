import { Dialog, DialogContent, DialogContentText, DialogActions, Button } from "@mui/material";

export default function ConfirmDeleteDialog(props: {
    open: boolean,
    text: string,
    close: () => void,
    printError: (msg: any) => void,
    confirmCallBack: () => void;
}) {
    return <Dialog open={props.open} onClose={props.close}>
        <DialogContent>
            <DialogContentText>
                {props.text}
            </DialogContentText>
        </DialogContent>
        <DialogActions>
            <Button onClick={props.close}>Cancel</Button>
            <Button onClick={props.confirmCallBack}>Confirm</Button>
        </DialogActions>
    </Dialog>;
}