import { Box, Button, Dialog, DialogTitle, Link, Tab, Tabs, TextField, Typography } from "@mui/material";
import { useCallback, useEffect, useState } from "react";
import { useDropzone } from 'react-dropzone';
import DeleteIcon from '@mui/icons-material/Delete';

export interface UploadedFile {
    content: string,
    name: string,
    size: number,
    original: File,
    date?: Date,
}

function FilePreview(props: {
    file: UploadedFile,
    removeFile: () => void;
}) {
    const renderName = (name: string) => {
        const extension: string = name.split(".")[name.split.length - 1];
        let result = name;
        if (name.length > 15) {
            result = `${name.substring(0, 15)}...${extension}`;
        }
        return result;
    }

    return <Box sx={{
        width: "100%",
        display: "flex",
        height: "40%",
        gap: "10px",
        padding: "10px",
        margin: "10px 0",
        backgroundColor: "background.default",
        borderRadius: "10px",
        alignItems: "center",
        justifyContent: "space-between",
    }}>
        <Box sx={{
            width: "auto",
            height: "100%",
            objectFit: "cover",
            aspectRatio: 1,
        }}>
            <img
                src={props.file.content}
                style={{
                    objectFit: "cover",
                    width: "100%",
                    height: "auto",
                    aspectRatio: 1,
                }}
            />
        </Box>
        <Typography>{renderName(props.file.name)}</Typography>
        <DeleteIcon onClick={props.removeFile} />
    </Box>
}

function FilesPreview(props: {
    files: UploadedFile[],
    removeFile: (name: string) => void;
}) {
    return <Box sx={{
        overflowY: "scroll",
        gap: "5px",
        height: "20vh",
    }}>
        {
            props.files.map((file: UploadedFile) => {
                return <FilePreview file={file} removeFile={() => props.removeFile(file.name)} />
            })
        }
    </Box>
}

function UploadFile(props: {
    fileToUpload: UploadedFile[],
    setFileToUpload: (arg: UploadedFile[]) => void,
    maxFileCount?: number,
}) {
    const onDrop = useCallback((acceptedFiles: File[]) => {
        acceptedFiles.map((file: File) => {
            const reader = new FileReader();
            reader.onload = (e) => {
                const toAdd = {
                    name: file.name,
                    size: file.size,
                    content: e.target?.result,
                    original: file,
                } as UploadedFile;
                props.setFileToUpload([toAdd, ...props.fileToUpload]);
            };
            reader.readAsDataURL(file);
            return file;
        });
    }, []);

    const { getRootProps, getInputProps, isDragActive } = useDropzone({
        accept: {
            'image/*': [],
        },
        onDrop: onDrop,
        maxFiles: props.maxFileCount,
    });

    const removeFile = (name: string): void => {
        const newFilesToUpload: UploadedFile[] = [...props.fileToUpload].filter(fl => fl.name !== name);
        props.setFileToUpload(newFilesToUpload);
    }

    useEffect(() => {
        if (props.maxFileCount == undefined || props.fileToUpload.length <= props.maxFileCount) {
            return;
        }
        props.setFileToUpload([...props.fileToUpload].slice(0, -1));
    }, [props.fileToUpload])

    return (
        <Box>
            <Box {...getRootProps({ className: "dropzone" })}>
                <input className="input-zone" {...getInputProps()} />
                <Box
                    className="text-center"
                    sx={{
                        border: "1px grey dashed",
                        width: "90%",
                        margin: "10px auto",
                        padding: "30px 30px",
                    }}>
                    <Box>
                        <p className="dropzone-content">
                            {isDragActive ? (
                                <p className="dropzone-content">
                                    Release to drop the files here
                                </p>
                            ) : (
                                <p className="dropzone-content">
                                    Drag and Drop files here, or <Link>Chose files</Link>
                                </p>
                            )}
                        </p>
                    </Box>
                </Box>
            </Box>
            {
                props.fileToUpload.length > 0 &&
                <FilesPreview files={props.fileToUpload} removeFile={removeFile} />
            }
        </Box>
    );
}


export default function InsertOrUpload(props: {
    open: boolean,
    onClose: () => void,
    title?: string,
    insert: (arg: string) => void,
    uploadFile: (arg: UploadedFile[]) => void,
    maxFileCount?: number;
}) {
    const [selectedTab, setSelectedTab] = useState<number>(0);
    const [fileToUpload, setFileToUpload] = useState<UploadedFile[]>([]);
    const [url, setUrl] = useState<string>();

    return <Dialog onClose={props.onClose} open={props.open}>
        <DialogTitle alignContent="center">{props.title}</DialogTitle>
        <Tabs
            centered
            variant="fullWidth"
            value={selectedTab}
            onChange={(_e, v) => {
                if (v === 0) {
                    setUrl(undefined);
                } else {
                    setFileToUpload([]);
                }
                setSelectedTab(v);
            }}
        >
            <Tab label="File" />
            <Tab label="URL" />
        </Tabs>
        <Box sx={{ padding: "10px 20px 10px 20px" }}>
            <Box style={{ display: selectedTab === 0 ? undefined : "none" }}>
                <UploadFile
                    setFileToUpload={setFileToUpload}
                    fileToUpload={fileToUpload}
                    maxFileCount={props.maxFileCount}
                />
            </Box>
            <Box style={{ display: selectedTab === 1 ? undefined : "none", margin: "20px 0", }}>
                <TextField
                    fullWidth
                    placeholder="https://..."
                    value={url || ""}
                    onChange={e => setUrl(e.currentTarget.value)}
                />
            </Box>

        </Box>
        <Box
            sx={{
                width: "100%",
                display: "flex",
                justifyContent: "space-evenly",
                marginBottom: "20px",
            }}>
            <Button
                sx={{
                    width: "40%",
                    border: "1px solid grey",
                    padding: "10px 15px"
                }}
                onClick={props.onClose}>
                Cancel
            </Button>
            <Button
                sx={{
                    width: "40%",
                    backgroundColor: "primary.main",
                    color: "white",
                    padding: "10px 15px",
                    "&:hover": { backgroundColor: "primary.main" },
                }}
                onClick={() => {
                    if (selectedTab === 0 && fileToUpload.length > 0) {
                        props.uploadFile(fileToUpload);
                        props.onClose();
                    } else if (selectedTab === 1 && url !== undefined) {
                        props.insert(url);
                        props.onClose();
                    }
                }}>
                Confirm
            </Button>
        </Box>
    </Dialog >
}