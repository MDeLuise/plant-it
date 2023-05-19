import { AxiosInstance } from "axios";
import { trackedEntity } from "../interfaces";
import { useEffect, useState } from "react";
import { Box, Skeleton, Tab, Tabs, Typography } from "@mui/material";
import { useParams } from "react-router-dom";

// interface TabPanelProps {
//     children?: React.ReactNode;
//     index: number;
//     value: number;
// }

// function TabPanel(props: TabPanelProps) {
//     const { children, value, index, ...other } = props;

//     return (
//         <div
//             role="tabpanel"
//             hidden={value !== index}
//             id={`simple-tabpanel-${index}`}
//             aria-labelledby={`simple-tab-${index}`}
//             {...other}
//         >
//             {value === index && (
//                 <Box sx={{ p: 3 }}>
//                     <Typography>{children}</Typography>
//                 </Box>
//             )}
//         </div>
//     );
// }

export default function PlantPage(props: { requestor: AxiosInstance, isLoggedIn: () => boolean }) {
    // const { entityId } = useParams();
    // const [entity, setEntity] = useState<trackedEntity>();
    // const [image, setImage] = useState<string>();
    // const [loadingEntity, setLoadingEntity] = useState<boolean>(true);
    // const [loadingImage, setLoadingImage] = useState<boolean>(true);
    // const [activeTab, setActiveTab] = useState<number>(0);

    // const getEntity = (): void => {
    //     setLoadingEntity(true);
    //     props.requestor.get(`/tracked-entity/${entityId}`)
    //     .then((response) => {
    //         setEntity(response.data);
    //     })
    //     .finally(() => setLoadingEntity(false))
    // }

    // const getEntity = (): void => {
    //     setLoadingEntity(true);
    //     props.requestor.get(`/tracked-entity/${entityId}`)
    //     .then((response) => {
    //         setEntity(response.data);
    //     })
    //     .finally(() => setLoadingEntity(false))
    // }

    // useEffect(() => {
    //     props.requestor.get(`/image/${props.entity.botanicalName.imageId}`, { responseType: 'arraybuffer' })
    //         .then((res) => {
    //             setImage(Buffer.from(res.data).toString("base64"));
    //         })
    //         .finally(() => setLoading(false))
    // }, []);

    // return (
    //     <Box>
    //         <Box>
    //             {
    //                 !loading &&
    //                 <img
    //                     src={`data:image/png;base64,${image}`}
    //                     style={{
    //                         width: "100%",
    //                         height: "100%",
    //                         objectFit: "cover"
    //                     }}
    //                 />
    //                 ||
    //                 <Skeleton variant="rounded" sx={{ width: "100%", height: "100%" }} />
    //             }
    //         </Box>
    //         <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
    //             <Tabs
    //                 value={activeTab}
    //                 onChange={(_event: React.SyntheticEvent, newValue: number) => setActiveTab(newValue)}
    //             >
    //                 <Tab label="Description" />
    //                 <Tab label="Diary" />
    //             </Tabs>
    //         </Box>
    //         <TabPanel value={activeTab} index={0}>
    //             Item One
    //         </TabPanel>
    //         <TabPanel value={activeTab} index={1}>
    //             Item Two
    //         </TabPanel>
    //         <TabPanel value={activeTab} index={2}>
    //             Item Three
    //         </TabPanel>
    //     </Box>
    // )
    return (<></>)
}