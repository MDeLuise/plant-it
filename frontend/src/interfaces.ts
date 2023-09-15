export interface botanicalInfo {
    id: number,
    scientificName: string,
    family: string,
    genus: string,
    species: string,
    imageUrl?: string,
    imageId?: string,
    systemWide: boolean,
}

export interface plant {
    id: number,
    startDate?: Date,
    endDate?: Date,
    personalName: string,
    state: string,
    ownerId: number,
    botanicalInfo: botanicalInfo,
    diaryId: number,
    note?: string
}

export interface diaryEntry {
    id: number,
    type: string,
    note: string,
    date: Date,
    diaryId: number,
    diaryTargetId: number,
    diaryTargetPersonalName: string,
}