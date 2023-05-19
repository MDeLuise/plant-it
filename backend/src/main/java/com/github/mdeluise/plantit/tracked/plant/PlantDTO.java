package com.github.mdeluise.plantit.tracked.plant;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoDTO;
import com.github.mdeluise.plantit.tracked.AbstractTrackedEntityDTO;
import io.swagger.v3.oas.annotations.media.Schema;

@Schema(name = "Plant", description = "Represents a plant.")
public class PlantDTO extends AbstractTrackedEntityDTO {
    @Schema(description = "Target ID of the plant.")
    private BotanicalInfoDTO botanicalName;
    @Schema(description = "Arrangement ID of the plant.")
    private Long arrangementId;


    public BotanicalInfoDTO getBotanicalName() {
        return botanicalName;
    }


    public void setBotanicalName(BotanicalInfoDTO botanicalName) {
        this.botanicalName = botanicalName;
    }


    public Long getArrangementId() {
        return arrangementId;
    }


    public void setArrangementId(Long arrangementId) {
        this.arrangementId = arrangementId;
    }
}
