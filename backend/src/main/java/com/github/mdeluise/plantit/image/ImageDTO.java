package com.github.mdeluise.plantit.image;

import io.swagger.v3.oas.annotations.media.Schema;

import java.util.Date;

@Schema(name = "Image", description = "Represents a plant's image.")
public class ImageDTO {
    @Schema(description = "ID of the image.", accessMode = Schema.AccessMode.READ_ONLY)
    private String id;
    @Schema(description = "Save date of the image.", accessMode = Schema.AccessMode.READ_ONLY)
    private Date savedAt;
    @Schema(description = "URL to retrieve the content of the image.", accessMode = Schema.AccessMode.READ_ONLY)
    private String url;
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


    public Date getSavedAt() {
        return savedAt;
    }


    public void setSavedAt(Date savedAt) {
        this.savedAt = savedAt;
    }


    public String getUrl() {
        return url;
    }


    public void setUrl(String url) {
        this.url = url;
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
