package com.github.mdeluise.plantit.tracked.plant;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfoDTO;
import com.github.mdeluise.plantit.tracked.TrackedEntityDTO;
import io.swagger.v3.oas.annotations.media.Schema;

@Schema(name = "Plant", description = "Represents a plant.")
public class PlantDTO extends TrackedEntityDTO {
    @Schema(description = "Botanical info ID of the plant.")
    private BotanicalInfoDTO botanicalInfo;
    @Schema(description = "Arrangement ID of the plant.")
    private Long arrangementId;


    public PlantDTO() {
        super();
    }


    public BotanicalInfoDTO getBotanicalInfo() {
        return botanicalInfo;
    }


    public void setBotanicalInfo(BotanicalInfoDTO botanicalInfo) {
        this.botanicalInfo = botanicalInfo;
    }


    public Long getArrangementId() {
        return arrangementId;
    }


    public void setArrangementId(Long arrangementId) {
        this.arrangementId = arrangementId;
    }
}
