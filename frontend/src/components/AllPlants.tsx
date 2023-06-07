import { Box } from "@mui/material";
import { AxiosInstance } from "axios";
import UserPlant from "./UserPlant";
import { useState, useEffect } from "react";
import { trackedEntity } from "../interfaces";

export default function AllPlants(props: { requestor: AxiosInstance }) {
    const [entities, setEntities] = useState<trackedEntity[]>([]);

    useEffect(() => {
        props.requestor.get("/tracked-entity")
            .then((res) => {
                setEntities(res.data.content);
            })
    }, []);

    return (
        <Box sx={{
            display: "flex",
            flexWrap: "wrap",
            gap: "20px",
            padding: "5px 0",
        }}>
            {entities.map((entity) => {
                return <UserPlant
                    entity={entity}
                    key={entity.id}
                    style={{
                        width: "45%",
                        height: "fit-content"
                    }}
                />
            })}
        </Box>
    )
}