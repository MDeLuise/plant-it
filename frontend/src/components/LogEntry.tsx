import { Box, Typography } from "@mui/material";
import { diaryEntry } from "../interfaces";
import WaterDropOutlinedIcon from '@mui/icons-material/WaterDropOutlined';
import YardOutlinedIcon from '@mui/icons-material/YardOutlined';
import AutorenewOutlinedIcon from '@mui/icons-material/AutorenewOutlined';
import QuestionMarkOutlinedIcon from '@mui/icons-material/QuestionMarkOutlined';
import { ReactElement } from "react";
import { titleCase } from "../common";

export default function LogEntry(props: { entity: diaryEntry, last: boolean }) {
    const getTypeIcon = (type: string): ReactElement<any, any> => {
        switch (type.toLowerCase()) {
            case "watering": return <WaterDropOutlinedIcon />
            case "seeding": return <YardOutlinedIcon />
            case "transplanting": return <AutorenewOutlinedIcon />
            default: return <QuestionMarkOutlinedIcon />
        }
    };

    const getTypeIconBackground = (type: string): string => {
        switch (type.toLowerCase()) {
            case "watering": return "rgb(64, 123, 213)"
            // case "seeding": return <YardOutlinedIcon />
            // case "transplanting": return <AutorenewOutlinedIcon />
            default: return "rgb(226, 233, 243)"
        }
    };

    return (
        <Box
            boxShadow={2}
            sx={{
                display: "flex",
                gap: "20px",
                backgroundColor: "background.paper",
                borderRadius: "10px",
                padding: "10px",
            }}>
            <Box sx={{
                backgroundColor: getTypeIconBackground(props.entity.type),
                width: "fit-content",
                height: "fit-content",
                borderRadius: "50%",
                padding: "10px",
                color: "white",
                position: "relative",
                '&::before': {
                    border: '1px solid #c0bfbf',
                    content: '""',
                    display: props.last ? 'none' : 'block',
                    height: '60px',
                    left: '50%',
                    position: 'absolute',
                    top: '50px',
                    boxShadow: "0px 3px 1px -2px rgba(0,0,0,0.2), 0px 2px 2px 0px rgba(0,0,0,0.14), 0px 1px 5px 0px rgba(0,0,0,0.12);"
                }
            }}>
                {getTypeIcon(props.entity.type)}
            </Box>
            <Box>
                <Typography>{new Date(props.entity.date).toLocaleString()}</Typography>
                <Typography style={{ fontWeight: 500 }}>{props.entity.diaryTargetPersonalName}</Typography>
                <Typography>{titleCase(props.entity.type)}</Typography>
            </Box>
        </Box>
    )
}