package com.github.mdeluise.plantit.diary.entry;

import io.swagger.v3.oas.annotations.media.Schema;

import java.util.Date;

@Schema(name = "Diary entry", description = "Represents an entry in the diary.")
public class DiaryEntryDTO {
    @Schema(description = "ID of the diary entry.", accessMode = Schema.AccessMode.READ_ONLY)
    private Long id;
    @Schema(description = "Type of the diary entry.")
    private String type;
    @Schema(description = "Note attached to the diary entry.")
    private String note;
    @Schema(description = "Date of the diary entry.")
    private Date date;
    @Schema(description = "Diary ID of the entry.")
    private Long diaryId;
    @Schema(description = "ID of the tracked entity.", accessMode = Schema.AccessMode.READ_ONLY)
    private Long diaryTargetId;
    @Schema(description = "Personal name of the tracked entity.", accessMode = Schema.AccessMode.READ_ONLY)
    private String diaryTargetPersonalName;


    public Long getId() {
        return id;
    }


    public void setId(Long id) {
        this.id = id;
    }


    public String getType() {
        return type;
    }


    public void setType(String type) {
        this.type = type;
    }


    public String getNote() {
        return note;
    }


    public void setNote(String note) {
        this.note = note;
    }


    public Date getDate() {
        return date;
    }


    public void setDate(Date date) {
        this.date = date;
    }


    public Long getDiaryId() {
        return diaryId;
    }


    public void setDiaryId(Long diaryId) {
        this.diaryId = diaryId;
    }


    public Long getDiaryTargetId() {
        return diaryTargetId;
    }


    public void setDiaryTargetId(Long diaryTargetId) {
        this.diaryTargetId = diaryTargetId;
    }


    public void setDiaryTargetPersonalName(String diaryTargetPersonalName) {
        this.diaryTargetPersonalName = diaryTargetPersonalName;
    }


    public String getDiaryTargetPersonalName() {
        return diaryTargetPersonalName;
    }
}
