package com.github.mdeluise.plantit.plant;

import java.util.Objects;

import com.github.mdeluise.plantit.plant.info.PlantInfoDTO;
import io.swagger.v3.oas.annotations.media.Schema;

@Schema(name = "Plant", description = "Represents a plant.")
public class PlantDTO {
    @Schema(description = "ID of the plant.", accessMode = Schema.AccessMode.READ_ONLY)
    private Long id;
    @Schema(description = "Info about the plant.")
    private PlantInfoDTO info;
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
    @Schema(description = "Botanical info ID of the plant.", accessMode = Schema.AccessMode.WRITE_ONLY)
    private Long botanicalInfoId;


    public PlantDTO() {
        this.info = new PlantInfoDTO();
    }


    public Long getId() {
        return id;
    }


    public void setId(Long id) {
        this.id = id;
    }


    public PlantInfoDTO getInfo() {
        return info;
    }


    public void setInfo(PlantInfoDTO plantInfoDTO) {
        this.info = plantInfoDTO;
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


    public Long getBotanicalInfoId() {
        return botanicalInfoId;
    }


    public void setBotanicalInfoId(Long botanicalInfoId) {
        this.botanicalInfoId = botanicalInfoId;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        final PlantDTO plantDTO = (PlantDTO) o;
        return Objects.equals(id, plantDTO.id) && Objects.equals(info, plantDTO.info) &&
                   Objects.equals(ownerId, plantDTO.ownerId) && Objects.equals(avatarImageId, plantDTO.avatarImageId) &&
                   Objects.equals(avatarImageUrl, plantDTO.avatarImageUrl) &&
                   Objects.equals(avatarMode, plantDTO.avatarMode) && Objects.equals(diaryId, plantDTO.diaryId) &&
                   Objects.equals(botanicalInfoId, plantDTO.botanicalInfoId);
    }


    @Override
    public int hashCode() {
        return Objects.hash(
            id, info, ownerId, avatarImageId, avatarImageUrl, avatarMode, diaryId, botanicalInfoId);
    }
}
