import { Box, InputAdornment, OutlinedInput, Skeleton } from "@mui/material";
import { useEffect, useState } from "react";
import { AxiosInstance } from "axios";
import { botanicalName } from "../interfaces";
import TopBar from "./TopBar";
import SearchRoundedIcon from '@mui/icons-material/SearchRounded';
import CloseRoundedIcon from '@mui/icons-material/CloseRounded';
import BotanicalEntity from "./BotanicalEntity";
import { isBigScreen } from "../common";

export default function AddEntities(props: { requestor: AxiosInstance, isLoggedIn: () => boolean }) {
    const [scientificName, setScientificName] = useState<string>("");
    const [botanicalNames, setBotanicalNames] = useState<botanicalName[]>([]);
    const [loading, setLoading] = useState<boolean>(true);

    const retrieveBotanicalNames = (): void => {
        let backendUrl: string;
        if (scientificName == "") {
            backendUrl = "botanical-info"
        } else {
            backendUrl = `botanical-info/partial/${scientificName}`
        }
        setLoading(true);
        props.requestor.get(backendUrl)
            .then((res => {
                let newBotanicalNames: botanicalName[] = [];
                res.data.content.forEach((botanicalName: botanicalName) => {
                    newBotanicalNames.push(botanicalName);
                })
                setBotanicalNames(newBotanicalNames);
            }))
            .finally(() => setLoading(false))
    }

    useEffect(() => {
        retrieveBotanicalNames();
    }, [scientificName]);

    return (
        <Box sx={{ width: "90%", margin: "0 auto" }}>
            <TopBar text="Search" backUrl="/" />
            <OutlinedInput
                fullWidth
                onChange={(event: React.ChangeEvent<HTMLInputElement>) => setScientificName(event.target.value)}
                startAdornment={
                    <InputAdornment position="start" sx={{ opacity: 0.5 }}>
                        <SearchRoundedIcon />
                    </InputAdornment>
                }
                endAdornment={
                    <InputAdornment position="start" sx={{ opacity: 0.5 }}>
                        <CloseRoundedIcon onClick={() => setScientificName("")}/>
                    </InputAdornment>
                }
                placeholder="Search"
                value={scientificName}
            />
            <Box sx={{ display: "flex", gap: "40px", flexWrap: "wrap", marginTop: "30px" }}>
                {
                    loading &&
                    <>
                        <Skeleton variant="rounded" sx={{ width: isBigScreen() ? "30vw" : "39vw", height: 20 / 9 * (isBigScreen() ? 30 : 39) + "vw"}} />
                        <Skeleton variant="rounded" sx={{ width: isBigScreen() ? "30vw" : "39vw", height: 20 / 9 * (isBigScreen() ? 30 : 39) + "vw" }} />
                    </>
                }
                {botanicalNames.map(botNa => {
                    return <BotanicalEntity entity={botNa} requestor={props.requestor} />
                })}
            </Box>

        </Box>
    )
}