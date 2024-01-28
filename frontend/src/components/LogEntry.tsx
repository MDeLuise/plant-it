import { MutableRefObject } from "react";
import { Box, Typography } from "@mui/material";
import { diaryEntry } from "../interfaces";
import WaterDropOutlinedIcon from '@mui/icons-material/WaterDropOutlined';
import YardOutlinedIcon from '@mui/icons-material/YardOutlined';
import AutorenewOutlinedIcon from '@mui/icons-material/AutorenewOutlined';
import QuestionMarkOutlinedIcon from '@mui/icons-material/QuestionMarkOutlined';
import LunchDiningOutlinedIcon from '@mui/icons-material/LunchDiningOutlined';
import BatterySaverOutlinedIcon from '@mui/icons-material/BatterySaverOutlined';
import VisibilityOutlinedIcon from '@mui/icons-material/VisibilityOutlined';
import ShowerOutlinedIcon from '@mui/icons-material/ShowerOutlined';
import ScienceOutlinedIcon from '@mui/icons-material/ScienceOutlined';
import WavesOutlinedIcon from '@mui/icons-material/WavesOutlined';
import ContentCutIcon from '@mui/icons-material/ContentCut';
import ChildCareIcon from '@mui/icons-material/ChildCare';
import AddHomeIcon from '@mui/icons-material/AddHome';
import { ReactElement } from "react";
import { alpha } from "@mui/material";
import KeyboardArrowRightIcon from '@mui/icons-material/KeyboardArrowRight';

export default function NewLogEntry(props: {
    entity: diaryEntry,
    last?: boolean,
    lastRef?: MutableRefObject<any>,
    editEvent: () => void;
}) {
    const getTypeIcon = (type: string): ReactElement<any, any> => {
        switch (type.toLowerCase()) {
            case "watering": return <WaterDropOutlinedIcon />;
            case "seeding": return <YardOutlinedIcon />;
            case "transplanting": return <AddHomeIcon />;
            case "fertilizing": return <LunchDiningOutlinedIcon />;
            case "biostimulating": return <BatterySaverOutlinedIcon />;
            case "observation": return <VisibilityOutlinedIcon />;
            case "misting": return <ShowerOutlinedIcon />;
            case "treatment": return <ScienceOutlinedIcon />;
            case "water_changing": return <WavesOutlinedIcon />;
            case "propagating": return <ChildCareIcon />;
            case "pruning": return <ContentCutIcon />;
            case "repotting": return <AutorenewOutlinedIcon />;
            default: return <QuestionMarkOutlinedIcon />;
        }
    };

    const getTypeIconBackground = (type: string): string => {
        switch (type.toLowerCase()) {
            case "watering": return "rgb(64, 123, 213)";
            case "seeding": return "rgb(48, 86, 54)";
            case "transplanting": return "rgb(121, 72, 36)";
            case "fertilizing": return "rgb(234, 94, 7)";
            case "biostimulating": return "rgb(234, 147, 7)";
            case "treatment": return "rgb(152, 60, 65)";
            case "observation": return "rgb(92, 93, 94)";
            case "misting": return "rgb(4, 34, 77)";
            case "water_changing": return "rgb(120, 154, 201)";
            case "propagating": return "rgb(249, 136, 136)";
            case "pruning": return "rgb(165, 136, 249)";
            case "repotting": return "rgb(195, 95, 21)";
            default: return "rgb(226, 233, 243)";
        }
    };

    return (
        <Box
            key={props.entity.id}
            ref={props.last ? props.lastRef : undefined}
            boxShadow={5}
            sx={{
                display: "flex",
                gap: "20px",
                backgroundColor: alpha(getTypeIconBackground(props.entity.type), .7),
                borderRadius: "10px",
                padding: "10px",
                alignItems: "center",
                //border: "1px solid white"
            }}
            onClick={props.editEvent}
        >
            <Box sx={{
                width: "fit-content",
                height: "fit-content",
                borderRadius: "50%",
                padding: "10px",
                color: "white"
            }}>
                {
                    getTypeIcon(props.entity.type)
                }
            </Box>
            <Box>
                <Typography>
                    {
                        `${new Date(props.entity.date).toLocaleDateString()},
                         ${Math.floor(((new Date()).getTime() - new Date(props.entity.date).getTime()) / (1000 * 3600 * 24))} days ago`
                    }
                </Typography>
                <Typography style={{ fontWeight: 500 }}>
                    {
                        props.entity.diaryTargetPersonalName
                    }
                </Typography>
            </Box>
            <Box sx={{ flexGrow: 1, textAlign: "end" }}>
                <KeyboardArrowRightIcon />
            </Box>
        </Box>
    );
}