package com.github.mdeluise.plantit.plantinfo;

import java.util.List;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;

public interface PlantInfoExtractorStep extends ChainElement<PlantInfoExtractorStep> {
    List<BotanicalInfo> extractPlants(String partialPlantScientificName, int size);

    List<BotanicalInfo> getAll(int size);
}
