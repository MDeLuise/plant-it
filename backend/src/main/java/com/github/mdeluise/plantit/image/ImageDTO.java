package com.github.mdeluise.plantit.image;

import java.util.Date;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(name = "Image", description = "Represents a plant's image.")
public class ImageDTO {
    @Schema(description = "ID of the image.", accessMode = Schema.AccessMode.READ_ONLY)
    private String id;
    @Schema(description = "Creation date of the image.", accessMode = Schema.AccessMode.READ_ONLY)
    private Date createOn;
    @Schema(description = "Description of the image.", accessMode = Schema.AccessMode.READ_ONLY)
    private String description;
    @Schema(description = "Target ID of the image.", accessMode = Schema.AccessMode.READ_ONLY)
    private Long targetId;


    public String getId() {
        return id;
    }


    public void setId(String id) {
        this.id = id;
    }


    public Date getCreateOn() {
        return createOn;
    }


    public void setCreateOn(Date createOn) {
        this.createOn = createOn;
    }


    public String getDescription() {
        return description;
    }


    public void setDescription(String description) {
        this.description = description;
    }


    public Long getTargetId() {
        return targetId;
    }


    public void setTargetId(Long targetId) {
        this.targetId = targetId;
    }
}
