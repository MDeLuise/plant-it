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
        <Box sx={{
            display: "flex",
            gap: "20px",
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
                    height: '40px',
                    left: '50%',
                    position: 'absolute',
                    top: '50px',
                }
            }}>
                {getTypeIcon(props.entity.type)}
            </Box>
            <Box>
                <Typography>{new Date(props.entity.date).toLocaleString()}</Typography>
                <Typography style={{fontWeight: 500}}>{props.entity.diaryTargetPersonalName}</Typography>
                <Typography>{titleCase(props.entity.type)}</Typography>
            </Box>
        </Box>
    )
}