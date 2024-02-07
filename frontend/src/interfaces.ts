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
    ownerId: number,
    diaryId: number,
    avatarMode: "NONE" | "RANDOM" | "LAST" | "SPECIFIED",
    avatarImageId?: string,
    botanicalInfoId: number,
    avatarImageUrl?: string;
    info: plantInfo;
};

export interface plantInfo {
    note?: string,
    startDate?: Date,
    endDate?: Date,
    personalName: string,
    state: "PURCHASED" | "PLANTED" | "ALIVE" | "GIFTED" | "DEAD",
    purchasedPrice?: number,
    currencySymbol?: string,
    seller?: string,
    location?: string;
}

export interface diaryEntry {
    id: number,
    type: string,
    note: string,
    date: Date,
    diaryId: number,
    diaryTargetId: number,
    diaryTargetPersonalName: string,
};

export interface systemVersionInfo {
    currentVersion: string,
    latestVersion: string,
    isLatest: boolean,
    latestReleaseNote: string,
}

export interface userStats {
    diaryEntryCount: number,
    plantCount: number,
    botanicalInfoCount: number,
    imageCount: number,
}
