package com.github.mdeluise.plantit.tracked;

import com.github.mdeluise.plantit.tracked.state.State;
import io.swagger.v3.oas.annotations.media.Schema;

import java.util.Date;

public abstract class AbstractTrackedEntityDTO {
    @Schema(description = "ID of the entity.", accessMode = Schema.AccessMode.READ_ONLY)
    private Long id;
    @Schema(description = "Start date entity.")
    private Date startDate;
    @Schema(description = "Personal name of the entity.")
    private String personalName;
    @Schema(description = "End date of the entity.")
    private Date endDate;
    @Schema(description = "State of the entity.")
    private State state;
    @Schema(description = "Owner ID of the entity.")
    private Long ownerId;
    @Schema(description = "Type of the entity.")
    private String type;
    @Schema(description = "ID of the entity's thumbnail.")
    private Long thumbnailImageId;
    @Schema(description = "ID of the entity's diary.")
    private Long diaryId;


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


    public State getState() {
        return state;
    }


    public void setState(State state) {
        this.state = state;
    }


    public Long getOwnerId() {
        return ownerId;
    }


    public void setOwnerId(Long ownerId) {
        this.ownerId = ownerId;
    }


    public String getType() {
        return type;
    }


    public void setType(String type) {
        this.type = type;
    }


    public Long getThumbnailImageId() {
        return thumbnailImageId;
    }


    public void setThumbnailImageId(Long thumbnailImageId) {
        this.thumbnailImageId = thumbnailImageId;
    }


    public Long getDiaryId() {
        return diaryId;
    }


    public void setDiaryId(Long diaryId) {
        this.diaryId = diaryId;
    }
}
