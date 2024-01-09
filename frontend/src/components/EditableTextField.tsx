import { TextField, Typography } from "@mui/material";
import { useState, useEffect } from "react";

export function EditableTextField(props: {
    editable: boolean,
    text?: string,
    maxLength?: number,
    onChange?: (arg: string) => void,
    variant?: "body1" | "h6",
    style?: {},
    rows?: number;
}) {
    const [value, setValue] = useState<string>();

    useEffect(() => {
        setValue(props.text || "");
    }, [props.text]);


    const renderedText = (arg?: string) => {
        if (arg === undefined) {
            return arg;
        }
        if (props.maxLength !== undefined && arg.length > props.maxLength) {
            return arg.substring(0, props.maxLength) + "...";
        }
        return arg;
    }

    return props.editable ?
        <TextField
            variant="standard"
            InputProps={{ disableUnderline: props.editable ? false : true }}
            disabled={!props.editable}
            onChange={(e) => {
                setValue(e.target.value);
                if (props.onChange != undefined) {
                    props.onChange(e.target.value);
                }
            }}
            value={value}
            sx={{
                ...props.style,
                color: "black",
            }}
        />
        :
        <Typography
            sx={{ ...props.style }}
            variant={props.variant}
            //multiline={props.rows ? Math.max(1, props.rows) > 1 : false}
            //rows={props.rows ? Math.max(1, props.rows) : 1}
        >
            {renderedText(props.text)}
        </Typography>;
}