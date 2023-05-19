package com.github.mdeluise.plantit.tracked.arrangement;

import com.github.mdeluise.plantit.tracked.AbstractTrackedEntityDTO;
import io.swagger.v3.oas.annotations.media.Schema;

import java.util.Set;

@Schema(name = "Arrangement", description = "Represents an arrangement of plants.")
public class ArrangementDTO extends AbstractTrackedEntityDTO {
    @Schema(description = "IDs of the plant that belongs to this arrangement.")
    private Set<Long> componentIds;


    public Set<Long> getComponentIds() {
        return componentIds;
    }


    public void setComponentIds(Set<Long> componentIds) {
        this.componentIds = componentIds;
    }
}
