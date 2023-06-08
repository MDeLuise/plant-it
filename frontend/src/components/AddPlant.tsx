import { Box, Button, Drawer, TextField } from "@mui/material";
import { AxiosInstance } from "axios";
import { botanicalInfo, trackedEntity } from "../interfaces";
import { useEffect, useState } from "react";

export default function AddPlant(props: {
    requestor: AxiosInstance,
    open: boolean,
    setOpen: (arg: boolean) => void,
    entity?: botanicalInfo,
    trackedEntities: trackedEntity[];
}) {
    const [plantName, setPlantName] = useState<string>("");

    const getName = (): void => {
        if (props.entity === undefined) {
            setPlantName("unknown");
            return;
        }
        if (props.entity.id === null) {
            setPlantName(props.entity.scientificName);
            return;
        }
        props.requestor.get(`/botanical-info/${props.entity.id}/_count`)
            .then((res) => {
                let incrementalName = props.entity!.scientificName;
                if (res.data > 0) {
                    incrementalName += ` ${res.data}`;
                }
                setPlantName(incrementalName);
            });
    };

    const addPlant = (): void => {
        props.requestor.post("/tracked-entity/plant", {
            botanicalInfo: props.entity,
            personalName: plantName,
            type: "PLANT",  
            state: "PURCHASED",
        })
            .then((res) => {
                props.setOpen(false);
                props.trackedEntities.push(res.data);
                props.entity!.id = res.data.botanicalInfo.id;
                getName();
            });
    };

    useEffect(() => {
        getName();
    }, [props.entity]);

    return (
        <Drawer
            anchor={"bottom"}
            open={props.open}
            onClose={() => props.setOpen(false)}
            PaperProps={{
                style: { borderRadius: "15px 15px 0 0" }
            }}
        >
            <Box
                sx={{
                    height: "90vh",
                    display: "flex",
                    flexDirection: "column",
                    padding: "35px",
                }}>
                <Box sx={{
                    display: "flex",
                    justifyContent: "space-between",
                    gap: "30px",
                    alignItems: "center",
                }}>
                    <Box sx={{
                        borderRadius: "50%",
                        height: "65px",
                        width: "65px",
                        overflow: "hidden"
                    }}>
                        <img
                            src={props.entity?.imageUrl}
                            style={{
                                height: "100%",
                                width: "100%",
                                objectFit: "cover"
                            }}
                        />
                    </Box>
                    <TextField
                        variant="outlined"
                        placeholder="Name"
                        sx={{ flexGrow: "1" }}
                        value={plantName}
                        onChange={(event) => setPlantName(event.target.value)}
                    />
                </Box>
                <Box sx={{ flexGrow: "1" }}></Box>
                <Button
                    variant="contained"
                    sx={{
                        m: "10px",
                        borderRadius: "10px",
                        padding: "15px",
                    }}
                    onClick={addPlant}
                >
                    Save plant
                </Button>
            </Box>
        </Drawer>
    );
}