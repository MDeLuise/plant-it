import { Box, Link } from "@mui/material";
import ArrowBackIcon from '@mui/icons-material/ArrowBack';

export default function TopBar(props: { text: string, backUrl?: string }) {
    return (
        <Box sx={{
            width: "90vw",
            height: "40px",
            marginBottom: "40px",
            backgroundColor: "color.secondary",
            display: "flex",
            // justifyContent: "space-between",
            alignItems: "center",
            gap: "20px !important"
        }}>
            <Link href={props.backUrl == undefined ? "/" : props.backUrl}>
                <ArrowBackIcon />
            </Link>
            {props.text}
            {/* <Box></Box> */}
        </Box >
    )
}