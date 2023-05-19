package com.github.mdeluise.plantit.diary;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(name = "Diary", description = "Represents a diary.")
public class DiaryDTO {
    @Schema(description = "ID of the diary.", accessMode = Schema.AccessMode.READ_ONLY)
    private Long id;
    @Schema(description = "Target ID of the diary.")
    private Long targetId;
    @Schema(description = "Owner ID of the diary.")
    private Long userId;
    @Schema(description = "Number of entities in the diary.", accessMode = Schema.AccessMode.READ_ONLY)
    private Long entriesCount;


    public Long getId() {
        return id;
    }


    public void setId(Long id) {
        this.id = id;
    }


    public Long getTargetId() {
        return targetId;
    }


    public void setTargetId(Long targetId) {
        this.targetId = targetId;
    }


    public Long getUserId() {
        return userId;
    }


    public void setUserId(Long userId) {
        this.userId = userId;
    }


    public Long getEntriesCount() {
        return entriesCount;
    }


    public void setEntriesCount(Long entriesCount) {
        this.entriesCount = entriesCount;
    }
}
