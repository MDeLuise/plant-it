package com.github.mdeluise.plantit.plant;

import java.util.Date;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoDTO;
import io.swagger.v3.oas.annotations.media.Schema;

public class PlantDTO {
    @Schema(description = "ID of the plant.", accessMode = Schema.AccessMode.READ_ONLY)
    private Long id;
    @Schema(description = "Start date plant.")
    private Date startDate;
    @Schema(description = "Personal name of the plant.")
    private String personalName;
    @Schema(description = "End date of the plant.")
    private Date endDate;
    @Schema(description = "PlantState of the plant.")
    private PlantState plantState;
    @Schema(description = "Note of the plant.")
    private String note;
    @Schema(description = "Owner ID of the plant.", accessMode = Schema.AccessMode.READ_ONLY)
    private Long ownerId;
    @Schema(description = "ID of the plant's avatar.")
    private String avatarImageId;
    @Schema(description = "URL of the plant's avatar.")
    private String avatarImageUrl;
    @Schema(description = "Avatar mode of the plant.")
    private String avatarMode;
    @Schema(description = "ID of the plant's diary.", accessMode = Schema.AccessMode.READ_ONLY)
    private Long diaryId;
    @Schema(description = "Botanical info ID of the plant.")
    private BotanicalInfoDTO botanicalInfo;


    public PlantDTO() {
    }


    public Long getId() {
        return id;
    }


    public void setId(Long id) {
        this.id = id;
    }


    public Date getStartDate() {
        return startDate;
    }


    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }


    public String getPersonalName() {
        return personalName;
    }


    public void setPersonalName(String personalName) {
        this.personalName = personalName;
    }


    public Date getEndDate() {
        return endDate;
    }


    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }


    public PlantState getState() {
        return plantState;
    }


    public void setState(PlantState plantState) {
        this.plantState = plantState;
    }


    public String getNote() {
        return note;
    }


    public void setNote(String note) {
        this.note = note;
    }


    public Long getOwnerId() {
        return ownerId;
    }


    public void setOwnerId(Long ownerId) {
        this.ownerId = ownerId;
    }


    public String getAvatarMode() {
        return avatarMode;
    }


    public void setAvatarMode(String avatarMode) {
        this.avatarMode = avatarMode;
    }


    public String getAvatarImageId() {
        return avatarImageId;
    }


    public void setAvatarImageId(String avatarImageId) {
        this.avatarImageId = avatarImageId;
    }


    public String getAvatarImageUrl() {
        return avatarImageUrl;
    }


    public void setAvatarImageUrl(String avatarImageUrl) {
        this.avatarImageUrl = avatarImageUrl;
    }


    public Long getDiaryId() {
        return diaryId;
    }


    public void setDiaryId(Long diaryId) {
        this.diaryId = diaryId;
    }


    public BotanicalInfoDTO getBotanicalInfo() {
        return botanicalInfo;
    }


    public void setBotanicalInfo(BotanicalInfoDTO botanicalInfo) {
        this.botanicalInfo = botanicalInfo;
    }
}
