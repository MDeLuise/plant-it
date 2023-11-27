package com.github.mdeluise.plantit.plantinfo;

import java.util.Set;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;

class NoOpPlantInfoExtractor extends AbstractPlantInfoExtractorStep {
    NoOpPlantInfoExtractor() {
        super();
    }


    @Override
    public Set<BotanicalInfo> extractPlantsInternal(String partialPlantScientificName, int size) {
        return Set.of();
    }


    @Override
    public Set<BotanicalInfo> getAllInternal(int size) {
        return Set.of();
    }
}
