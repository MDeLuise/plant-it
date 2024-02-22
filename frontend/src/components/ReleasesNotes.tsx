import { Box, Button, Dialog, DialogActions, DialogContent, DialogTitle } from "@mui/material";
import { AxiosInstance } from "axios";
import { useEffect, useState } from "react";
import { systemVersionInfo } from "../interfaces";
import Markdown from 'react-markdown';
import remarkGfm from 'remark-gfm'
import IconButton from '@mui/material/IconButton';
import CloseIcon from '@mui/icons-material/Close';
import { isVersionLessThan } from "../common";


export default function ReleasesNotes(props: {
    requestor: AxiosInstance,
    printError: (err: any) => void;
}) {
    const [systemVersionInfo, setSystemVersionInfo] = useState<systemVersionInfo>();
    const [isFirstStartupAfterUpgrade, setIsFirstStartupAfterUpgrade] = useState<boolean>(false);
    const fetchVersion = (): Promise<systemVersionInfo> => {
        return new Promise((accept, reject) => {
            props.requestor.get("/info/version")
                .then(res => {
                    accept(res.data);
                })
                .catch(err => {
                    reject(err);
                });
        });
    }

    const checkIfIsFirstStartupAfterUpgrade = (): void => {
        const lastVersion: string | number | boolean | object | null = localStorage.getItem("plant-it-version");
        if (typeof (lastVersion) !== "string" && lastVersion !== null) {
            props.printError("Error while retrieving last version of the system");
            return;
        }
        fetchVersion()
            .then(currentVersionInfo => {
                setSystemVersionInfo(currentVersionInfo);
                localStorage.setItem("plant-it-version", currentVersionInfo.currentVersion);
                if (!lastVersion) {
                    setIsFirstStartupAfterUpgrade(true);
                } else {
                    setIsFirstStartupAfterUpgrade(isVersionLessThan(lastVersion, currentVersionInfo.currentVersion));
                }
            })
            .catch(props.printError);
    }

    const handleClose = (): void => {
        setIsFirstStartupAfterUpgrade(false);
    };

    useEffect(() => {
        checkIfIsFirstStartupAfterUpgrade();
    }, []);

    return <Dialog
        open={isFirstStartupAfterUpgrade}
        onClose={handleClose}
    >
        <DialogTitle>{systemVersionInfo?.currentVersion} - release note</DialogTitle>
        <IconButton
            aria-label="close"
            onClick={handleClose}
            sx={{
                position: 'absolute',
                right: 8,
                top: 8,
                color: (theme) => theme.palette.grey[500],
            }}
        >
            <CloseIcon />
        </IconButton>
        <DialogContent>
            <Box>
                <Markdown remarkPlugins={[[remarkGfm, { singleTilde: false }]]}>
                    {systemVersionInfo?.latestReleaseNote!}
                </Markdown>
            </Box>
        </DialogContent>
        <DialogActions>
            <Button autoFocus onClick={handleClose}>
                Got it
            </Button>
        </DialogActions>
    </Dialog>
};