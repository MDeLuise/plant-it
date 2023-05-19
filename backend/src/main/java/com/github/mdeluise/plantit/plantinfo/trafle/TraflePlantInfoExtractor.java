package com.github.mdeluise.plantit.plantinfo.trafle;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import com.github.mdeluise.plantit.plantinfo.PlantInfoExtractor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.Optional;

public class TraflePlantInfoExtractor implements PlantInfoExtractor {
    @Override
    public Optional<BotanicalInfo> extractInfo(String plantScientificName) {
        return Optional.empty();
    }


    @Override
    public Page<BotanicalInfo> extractPlants(String partialPlantScientificName, Pageable pageable) {
        return null;
    }


    @Override
    public Page<BotanicalInfo> getAll(Pageable pageable) {
        return null;
    }
}
