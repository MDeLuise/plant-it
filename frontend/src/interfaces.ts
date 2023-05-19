export interface tracker {
    id: number,
    name: string,
    description: string,
    unit: string,
    lastObservation?: observation
}

export interface observation {
    id: number,
    trackerId: number,
    trackerName: string,
    unit: string,
    instant: Date,
    value: number
}

export interface botanicalName {
    id: number,
    scientificName: string,
    family: string,
    genus: string,
    imageId: number
}

export interface trackedEntity {
    id: number,
    startDate?: Date,
    endDate?: Date,
    personalName?: string,
    state: string,
    ownerId: number,
    type: "PLANT" | "ARRANGEMENT",
    botanicalName: botanicalName,
    diaryId: number
}

export interface diaryEntry {
    id: number,
    type: string,
    note: string,
    date: Date,
    diaryId: number,
    diaryTargetId: number
}