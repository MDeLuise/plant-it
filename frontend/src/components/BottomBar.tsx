import { Box } from "@mui/material";
import {
    AiOutlineHome,
    AiFillHome,
    AiOutlineSearch,
    AiOutlineCalendar,
    AiFillCalendar,
    AiOutlineUser,
} from 'react-icons/ai';
import { FaUser } from "react-icons/fa";
import { IconType } from "react-icons/lib";
import "../style/BottomBar.scss";
import { useState } from "react";
import { Fab } from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import { AxiosInstance } from "axios";

function BottomBarSection(props: {
    iconDisabled: IconType,
    iconEnabled: IconType,
    active: boolean,
    setActive: () => void,
}) {
    let [toggle, setToggle] = useState<boolean>(true);

    return (
        <Box
            sx={{
                opacity: props.active ? 1 : .3,
                flexGrow: 1,
                textAlign: "center",
                padding: "10px",
                animation: (props.active && toggle) ? "zoomInOut" : "none",
                animationDuration: ".5s",
            }}
            onClick={() => {
                if (props.active) {
                    window.scrollTo({ top: 0, left: 0, behavior: "auto" });
                    setToggle(false);
                    setTimeout(() => {
                        setToggle(true);
                    }, 100);
                } else {
                    props.setActive();
                }
            }}
        >
            {
                props.active &&
                <props.iconEnabled fontSize={"25px"} />
                ||
                <props.iconDisabled fontSize={"25px"} />
            }
        </Box>
    );
}

export default function BottomBar(props: {
    activeTab: number,
    setActiveTab: (arg: number) => void,
    requestor: AxiosInstance,
    openAddLogEntry: () => void,
    online: boolean;
}) {
    return (
        <Box
            boxShadow={.5}
            sx={{
                position: "fixed",
                bottom: "20px",
                left: "50%",
                transform: "translate(-50%, 0%)",
                right: "50%",
                width: "90vw",
                height: "50px",
                display: "flex",
                backgroundColor: "rgba(255, 255, 255, .95)",
                color: "primary.main",
                alignItems: "center",
                padding: "10px",
                borderRadius: "50px",
                zIndex: 10,
            }}
        >

            <BottomBarSection
                setActive={() => props.setActiveTab(0)}
                active={props.activeTab == 0}
                iconEnabled={AiFillHome}
                iconDisabled={AiOutlineHome}
            />
            <BottomBarSection
                setActive={() => props.setActiveTab(1)}
                active={props.activeTab == 1}
                iconEnabled={AiFillCalendar}
                iconDisabled={AiOutlineCalendar}
            />
            <Fab
                color="primary"
                aria-label="add"
                sx={{
                    position: "relative",
                    top: "-10px"
                }}
                onClick={props.openAddLogEntry}
                disabled={!props.online}
            >
                <AddIcon />
            </Fab>
            <BottomBarSection
                setActive={() => props.setActiveTab(2)}
                active={props.activeTab == 2}
                iconEnabled={AiOutlineSearch}
                iconDisabled={AiOutlineSearch}
            />
            <BottomBarSection
                setActive={() => props.setActiveTab(3)}
                active={props.activeTab == 3}
                iconEnabled={FaUser}
                iconDisabled={AiOutlineUser}
            />
        </Box>
    );
}