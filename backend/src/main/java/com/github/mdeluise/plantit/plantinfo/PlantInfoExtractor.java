package com.github.mdeluise.plantit.plantinfo;

import com.github.mdeluise.plantit.botanicalinfo.BotanicalInfo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.Optional;

public interface PlantInfoExtractor {
    Optional<BotanicalInfo> extractInfo(String plantScientificName);

    Page<BotanicalInfo> extractPlants(String partialPlantScientificName, Pageable pageable);

    Page<BotanicalInfo> getAll(Pageable pageable);
}
