import { Box, Drawer } from "@mui/material";

function ClosableDrawerHeader(props: {

}) {
    return  <Box>
        
    </Box>;
}

export default function ClosableDrawer(props: {
    open: boolean,
    onClose?: () => void,
    content: React.JSX.Element;
}) {
    return <Drawer
        anchor={"bottom"}
        open={props.open}
        onClose={props.onClose}
        PaperProps={{
            style: { borderRadius: "15px 15px 0 0" }
        }}
    >
        <Box
            sx={{
                height: "100vh",
                display: "flex",
                flexDirection: "column",
                gap: "30px",
                padding: "20px",
            }}>
            <ClosableDrawerHeader />
            {props.content}
        </Box>

    </Drawer>;
}