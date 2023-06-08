import { Box, CircularProgress } from "@mui/material";
import { AxiosInstance } from "axios";
import LogEntry from "./LogEntry";
import { useState, useEffect, useRef } from "react";
import { diaryEntry } from "../interfaces";

export default function AllLogs(props: { requestor: AxiosInstance, entries: diaryEntry[]; }) {
    const pageSize = 2;
    const [entities, setEntities] = useState<diaryEntry[]>([]);
    const [pageNo, setPageNo] = useState<number>(-1);
    const [circularProgressVisible, setCircularProgressVisible] = useState<boolean>(false);
    const [fetchNew, setFetchNew] = useState<boolean>(true);

    const observerCallback = (entries: IntersectionObserverEntry[], _observer: IntersectionObserver) => {
        const entry = entries[0];
        if (entry.isIntersecting) {
            setFetchNew(true);
        }
    };

    const observer = new IntersectionObserver(observerCallback, {
        rootMargin: '0px',
        threshold: 1.0,
    });

    useEffect(() => {
        if (pageNo === -1) {
            return;
        }
        if ((pageNo * pageSize === entities.length) && fetchNew) {
            getPage();
        }
    }, [pageNo, entities, fetchNew]);

    const getPage = () => {
        if (myRef.current !== undefined) {
            observer.unobserve(myRef.current as Element);
        }
        setFetchNew(false);
        setCircularProgressVisible(true);
        props.requestor.get(`/diary/entry?pageNo=${pageNo}&pageSize=${pageSize}`)
            .then((res) => {
                let newEntitites: diaryEntry[] = [];
                entities.forEach((en: diaryEntry) => {
                    newEntitites.push(en);
                });
                res.data.content.forEach((en: diaryEntry) => {
                    newEntitites.push(en);
                });
                setEntities(newEntitites);
                setCircularProgressVisible(false);
                setPageNo(pageNo + 1);
                if (!res.data.last) {
                    if (myRef.current !== undefined) {
                        observer.observe(myRef.current as Element);
                    }
                }
            });
    };

    useEffect(() => {
        setPageNo(0);
        setTimeout(() => {
            if (myRef.current !== undefined) {
                observer.observe(myRef.current as Element);
            }
        }, 500);
    }, []);

    const myRef = useRef<Element>();

    return (
        <Box sx={{ marginTop: "20px" }}>
            <Box sx={{
                display: "flex",
                flexDirection: "column",
                gap: "20px",
            }}>
                {
                    props.entries.filter((en) => !entities.includes(en)).map((entity) => {
                        return <LogEntry
                            entity={entity}
                            last={false}
                            key={entity.id} lastRef={myRef}
                        />;
                    })
                }
                {
                    entities.map((entity, index) => {
                        return <LogEntry
                            entity={entity}
                            last={index == entities.length - 1}
                            key={entity.id} lastRef={myRef}
                        />;
                    })
                }
                <CircularProgress
                    sx={{
                        margin: "0 auto",
                        visibility: circularProgressVisible ? "visible" : "hidden"
                    }}
                />
            </Box>
        </Box>
    );
};