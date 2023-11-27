export interface botanicalInfo {
    id: number,
    scientificName: string,
    family: string,
    genus: string,
    species: string,
    imageUrl: string,
    imageId?: string,
    creator: "USER" | "TREFLE",
};

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
