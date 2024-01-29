import { Box, Typography, Link } from "@mui/material";
import { useState } from "react";

export function ReadMoreReadLess(props: {
    text: string,
    size: number;
}) {
    const [expanded, setExpanded] = useState<boolean>(false);

    return (
        <Box sx={{ width: "100%", }}>
            {
                <Typography
                    sx={{
                        border: "1px solid #b4b4b4",
                        borderRadius: "10px",
                        padding: "16.5px 14px",
                        whiteSpace: "pre-line",
                    }}
                >
                    {
                        props.text.length > props.size && !expanded &&
                        props.text.substring(0, props.size) + "…" ||
                        props.text + " "
                    }
                    {
                        props.text.length > props.size && " " &&
                        <Link onClick={() => { setExpanded(!expanded); }} >
                            {expanded ? "Read less" : "Read more"}
                        </Link>
                    }
                </Typography>
            }
        </Box>);
}