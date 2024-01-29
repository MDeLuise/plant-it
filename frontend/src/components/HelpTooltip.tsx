import { Tooltip, IconButton } from "@mui/material";
import { useState } from "react";
import HelpOutlineIcon from '@mui/icons-material/HelpOutline';

export function HelpTooltip(props: {
    text: string;
}) {
    const [open, setOpen] = useState(false);

    const handleToggle = () => {
        setOpen((prevOpen) => !prevOpen);
    };

    const handleClose = () => {
        setOpen(false);
    };

    return (
        <Tooltip
            arrow
            title={props.text}
            open={open}
            onClose={handleClose}
            disableTouchListener
        >
            <IconButton onClick={handleToggle}>
                <HelpOutlineIcon />
            </IconButton>
        </Tooltip>
    )
};