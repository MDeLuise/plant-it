export interface botanicalInfo {
    id: number,
    scientificName: string,
    synonyms: string[],
    family: string,
    genus: string,
    species: string,
    imageUrl: string,
    imageId?: string,
    creator: "USER" | "TREFLE",
    plantCareInfo: plantCareInfo,
};

export interface plantCareInfo {
    minTemp?: number,
    maxTemp?: number,
    phMin?: number,
    phMax?: number,
    light?: number,
    humidity?: number,
    allNull: boolean,
}

export interface plant {
    id: number,
    startDate?: Date,
    endDate?: Date,
    personalName: string,
    state: "PURCHASED" | "PLANTED" | "ALIVE" | "GIFTED" | "DEAD",
    ownerId: number,
    diaryId: number,
    note?: string,
    avatarMode: "NONE" | "RANDOM" | "LAST" | "SPECIFIED",
    avatarImageId?: string,
    botanicalInfoId: number,
    avatarImageUrl?: string;
};

export interface diaryEntry {
    id: number,
    type: string,
    note: string,
    date: Date,
    diaryId: number,
    diaryTargetId: number,
    diaryTargetPersonalName: string,
};
